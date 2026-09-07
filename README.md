<div align="center">
  <img src="assets/icons/qbpanel_splash.png" width="128" alt="qBPanel" />
  <h1>qBPanel</h1>
  <p>通过 qBittorrent WebUI API 远程管理种子的 Flutter 客户端</p>
  <p>
    <b>中文</b> | <a href="README.en.md">English</a>
  </p>
  <p>
    <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white" />
    <img alt="qBittorrent" src="https://img.shields.io/badge/qBittorrent-WebAPI%202.0+-15897C" />
    <img alt="Android" src="https://img.shields.io/badge/Android-supported-3DDC84?logo=android&logoColor=white" />
    <img alt="Windows" src="https://img.shields.io/badge/Windows-supported-0078D6?logo=windows&logoColor=white" />
  </p>
</div>

qBPanel 不是下载器本身，而是跑在手机或电脑上的**远程面板**：连上已开启 WebUI 的 qBittorrent（本机、NAS、VPS 均可），查看进度、添加任务、改设置。界面按 Material 3 设计，对齐桌面 WebUI 的常用能力。

## 功能

- **多服务器**：添加、编辑、切换多台 qBittorrent；支持 HTTPS 与自定义路径（如反向代理 `/nas/qb`）
- **登录**：WebUI 用户名 / 密码；qBittorrent 5.2+ 可用 API Key
- **种子列表**：实时轮询进度与速度；搜索、状态 / 分类 / 标签筛选、多种排序；标准 / 紧凑行高
- **添加种子**：磁力链接、HTTP(S) 地址、本地 `.torrent` 文件；可选保存路径、分类、重命名、TMM
- **从系统打开**：Android 可打开 / 分享 `.torrent` 与 `magnet:`；Windows 可通过启动参数或拖放导入（不注册为系统默认打开方式）
- **任务操作**：开始 / 停止 / 强制开始、删除、改保存路径、重命名、分类与标签、限速与分享限制、顺序下载、校验、再汇报、队列、导出 `.torrent`
- **种子详情**：总览（进度条、可用性、速度曲线）、Peer（含 IPv4 / IPv6 与客户端信息）、文件优先级、Tracker、HTTP seeds
- **搜索**：调用 qB 搜索插件，安装 / 启用 / 更新插件
- **日志**：服务器普通日志与封禁 IP（支持按级别筛选）
- **远程设置**：行为、下载、连接、速度、BitTorrent、WebUI、高级选项（改的是当前 qB 服务器，不是本应用）
- **外观**：跟随系统 / 浅色 / 深色、Material You 动态取色、自定义主题色
- **语言**：跟随系统、简体中文、繁體中文、English

## 截图

<table>
  <tr>
    <td align="center"><img src="art/screenshots/1.jpg" width="240" alt="首页" /><br/>首页</td>
    <td align="center"><img src="art/screenshots/5.jpg" width="240" alt="筛选" /><br/>筛选与排序</td>
    <td align="center"><img src="art/screenshots/2.jpg" width="240" alt="添加种子" /><br/>添加种子</td>
  </tr>
  <tr>
    <td align="center"><img src="art/screenshots/8.jpg" width="240" alt="总览" /><br/>详情 · 总览</td>
    <td align="center"><img src="art/screenshots/9.jpg" width="240" alt="Peers" /><br/>详情 · Peers</td>
    <td align="center"><img src="art/screenshots/10.jpg" width="240" alt="文件" /><br/>详情 · 文件</td>
  </tr>
  <tr>
    <td align="center"><img src="art/screenshots/11.jpg" width="240" alt="Trackers" /><br/>详情 · Trackers</td>
    <td align="center"><img src="art/screenshots/3.jpg" width="240" alt="搜索" /><br/>搜索</td>
    <td align="center"><img src="art/screenshots/4.jpg" width="240" alt="搜索插件" /><br/>搜索插件</td>
  </tr>
  <tr>
    <td align="center"><img src="art/screenshots/6.jpg" width="240" alt="日志" /><br/>日志</td>
    <td align="center"><img src="art/screenshots/7.jpg" width="240" alt="封禁 IP" /><br/>封禁 IP</td>
    <td align="center"><img src="art/screenshots/14.jpg" width="240" alt="添加服务器" /><br/>添加服务器</td>
  </tr>
  <tr>
    <td align="center"><img src="art/screenshots/15.jpg" width="240" alt="服务器设置" /><br/>服务器设置</td>
    <td align="center"><img src="art/screenshots/13.jpg" width="240" alt="外观" /><br/>外观</td>
    <td align="center"><img src="art/screenshots/12.jpg" width="240" alt="HTTP seeds" /><br/>详情 · HTTP seeds</td>
  </tr>
</table>

## 使用

1. 在 qBittorrent 中开启 **WebUI**（「工具 → 选项 → WebUI」），记下端口；若走 HTTPS 或反向代理，一并记下路径。
2. 打开 qBPanel → **设置 → 服务器**，填写名称、主机 / IP、端口、路径。
3. 选择登录方式：用户名和密码，或 qB 5.2+ 的 API Key。需要加密传输时打开 **Use HTTPS**。
4. 保存后即可在首页管理种子。没有激活服务器时，请先添加一台，否则无法请求 API。

局域网、Tailscale / 同类组网、或已暴露 WebUI 的公网地址都可以连。请自行保证 WebUI 的访问安全（强密码、API Key、不要把未加固的 WebUI 直接暴露到公网）。

## 平台

| 平台 | 说明 |
|---|---|
| **Android** | 主要目标。可从系统打开 / 分享 `.torrent` 与磁力链接 |
| **Windows** | 可用。通过启动参数或拖放导入种子；不会写入注册表、不会抢默认打开方式 |
| **Web** | 仓库内有工程，能力受限（无本地文件 / 外部打开） |

## 构建

需要 [Flutter 3.9+](https://docs.flutter.dev/get-started/install)。

```bash
flutter pub get
flutter run
```

发布包：

```bash
flutter build apk
flutter build windows
```

## 兼容性

- 最低 **qBittorrent 4.1**（WebAPI 2.0）
- 按服务器返回的 WebAPI 版本启用对应能力（搜索、标签、Peer 列表、API Key 等）
- qB 5.0+ 使用 `start` / `stop`；更早版本使用 `resume` / `pause`

## 声明

本项目与 qBittorrent 官方无隶属关系。请遵守所在地法律法规与版权规定；通过搜索插件下载种子前，请确认来源合法。

## 隐私政策

[隐私政策](docs/privacy-policy.html)

## 鸣谢

感谢 [Cursor](https://cursor.com) 😊
