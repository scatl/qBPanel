#ifndef RUNNER_INBOUND_WIN_H_
#define RUNNER_INBOUND_WIN_H_

#include <windows.h>

#include <string>
#include <vector>

// COPYDATASTRUCT::dwData for second-instance file / magnet handoff.
constexpr ULONG_PTR kQbPanelCopyDataId = 0x51425031;  // 'QBP1'

// Marks this top-level window so a second process can find it.
void MarkInboundWindow(HWND hwnd);

// True if another instance was running and received |args| (caller should exit).
bool TryForwardToExistingInstance(const std::vector<std::string>& args);

std::string JoinInboundArgs(const std::vector<std::string>& args);
std::vector<std::string> SplitInboundArgs(const char* data, size_t len);

#endif  // RUNNER_INBOUND_WIN_H_

