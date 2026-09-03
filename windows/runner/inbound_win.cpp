#include "inbound_win.h"

namespace {

constexpr wchar_t kMutexName[] = L"Local\\qBPanel.SingleInstance";
constexpr wchar_t kWindowProp[] = L"qBPanel.InboundWindow";

HANDLE g_instance_mutex = nullptr;

BOOL CALLBACK FindInboundProc(HWND hwnd, LPARAM lparam) {
  if (GetPropW(hwnd, kWindowProp) != nullptr) {
    *reinterpret_cast<HWND*>(lparam) = hwnd;
    return FALSE;
  }
  return TRUE;
}

HWND FindInboundWindow() {
  HWND found = nullptr;
  EnumWindows(FindInboundProc, reinterpret_cast<LPARAM>(&found));
  return found;
}

}  // namespace

void MarkInboundWindow(HWND hwnd) {
  if (hwnd) {
    SetPropW(hwnd, kWindowProp, reinterpret_cast<HANDLE>(1));
  }
}

bool TryForwardToExistingInstance(const std::vector<std::string>& args) {
  HANDLE mutex = CreateMutexW(nullptr, TRUE, kMutexName);
  if (mutex == nullptr) {
    return false;
  }
  if (GetLastError() != ERROR_ALREADY_EXISTS) {
    g_instance_mutex = mutex;
    return false;
  }
  CloseHandle(mutex);

  HWND hwnd = nullptr;
  for (int i = 0; i < 40 && hwnd == nullptr; i++) {
    hwnd = FindInboundWindow();
    if (hwnd == nullptr) {
      Sleep(50);
    }
  }
  if (hwnd == nullptr) {
    return false;
  }

  const std::string payload = JoinInboundArgs(args);
  COPYDATASTRUCT cds{};
  cds.dwData = kQbPanelCopyDataId;
  cds.cbData = static_cast<DWORD>(payload.size());
  cds.lpData = payload.empty()
                   ? nullptr
                   : const_cast<char*>(payload.data());

  DWORD pid = 0;
  GetWindowThreadProcessId(hwnd, &pid);
  if (pid != 0) {
    AllowSetForegroundWindow(pid);
  }
  SendMessageW(hwnd, WM_COPYDATA, 0, reinterpret_cast<LPARAM>(&cds));
  return true;
}

std::string JoinInboundArgs(const std::vector<std::string>& args) {
  std::string out;
  for (size_t i = 0; i < args.size(); i++) {
    if (i != 0) {
      out.push_back('\n');
    }
    out += args[i];
  }
  return out;
}

std::vector<std::string> SplitInboundArgs(const char* data, size_t len) {
  std::vector<std::string> out;
  if (data == nullptr || len == 0) {
    return out;
  }
  std::string all(data, len);
  size_t start = 0;
  while (start <= all.size()) {
    const size_t end = all.find('\n', start);
    if (end == std::string::npos) {
      if (start < all.size()) {
        out.push_back(all.substr(start));
      }
      break;
    }
    if (end > start) {
      out.push_back(all.substr(start, end - start));
    }
    start = end + 1;
  }
  return out;
}
