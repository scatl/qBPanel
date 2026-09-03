#include "flutter_window.h"

#include <flutter/standard_method_codec.h>
#include <optional>
#include <shellapi.h>
#include <string>
#include <vector>

#include "flutter/generated_plugin_registrant.h"
#include "inbound_win.h"
#include "utils.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  MarkInboundWindow(GetHandle());
  DragAcceptFiles(GetHandle(), TRUE);
  SetupInboundChannel();

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::SetupInboundChannel() {
  inbound_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "qbpanel/inbound",
          &flutter::StandardMethodCodec::GetInstance());
  inbound_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        if (call.method_name() == "ready") {
          inbound_ready_ = true;
          const auto queued = pending_inbound_;
          pending_inbound_.clear();
          for (const auto& args : queued) {
            DispatchInboundArgs(args);
          }
          result->Success();
          return;
        }
        result->NotImplemented();
      });
}

void FlutterWindow::DispatchInboundArgs(const std::vector<std::string>& args) {
  if (!inbound_ready_ || inbound_channel_ == nullptr) {
    pending_inbound_.push_back(args);
    return;
  }
  flutter::EncodableList list;
  list.reserve(args.size());
  for (const auto& arg : args) {
    list.emplace_back(arg);
  }
  inbound_channel_->InvokeMethod(
      "opened", std::make_unique<flutter::EncodableValue>(list));
}

void FlutterWindow::BringToForeground() {
  const HWND hwnd = GetHandle();
  if (hwnd == nullptr) {
    return;
  }
  if (IsIconic(hwnd)) {
    ShowWindow(hwnd, SW_RESTORE);
  }
  SetForegroundWindow(hwnd);
}

void FlutterWindow::OnDestroy() {
  inbound_channel_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (message == WM_COPYDATA) {
    const auto* cds = reinterpret_cast<COPYDATASTRUCT*>(lparam);
    if (cds != nullptr && cds->dwData == kQbPanelCopyDataId) {
      BringToForeground();
      DispatchInboundArgs(SplitInboundArgs(
          static_cast<const char*>(cds->lpData), cds->cbData));
      return TRUE;
    }
  }
  if (message == WM_DROPFILES) {
    const auto drop = reinterpret_cast<HDROP>(wparam);
    const UINT count = DragQueryFileW(drop, 0xFFFFFFFF, nullptr, 0);
    std::vector<std::string> paths;
    for (UINT i = 0; i < count; i++) {
      const UINT len = DragQueryFileW(drop, i, nullptr, 0);
      if (len == 0) {
        continue;
      }
      std::wstring wide(len, L'\0');
      DragQueryFileW(drop, i, wide.data(), len + 1);
      paths.push_back(Utf8FromUtf16(wide.c_str()));
    }
    DragFinish(drop);
    if (!paths.empty()) {
      BringToForeground();
      DispatchInboundArgs(paths);
    }
    return 0;
  }

  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
