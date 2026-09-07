/// qBittorrent WebAPI 版本（`/app/webapiVersion`，如 `2.0` / `2.11.2`）。
class WebApiVersion implements Comparable<WebApiVersion> {
  const WebApiVersion(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  /// WebAPI 2.0 = qBittorrent 4.1.0，本 App 支持的下限。
  static const minSupported = WebApiVersion(2, 0, 0);

  static WebApiVersion? tryParse(String? raw) {
    if (raw == null) return null;
    var text = raw.trim();
    if (text.isEmpty) return null;
    if (text.startsWith('v') || text.startsWith('V')) {
      text = text.substring(1);
    }
    final parts = text.split('.');
    final major = int.tryParse(parts[0]);
    if (major == null) return null;
    final minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final patch = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return WebApiVersion(major, minor, patch);
  }

  bool isAtLeast(int major, [int minor = 0, int patch = 0]) {
    if (this.major != major) return this.major > major;
    if (this.minor != minor) return this.minor > minor;
    return this.patch >= patch;
  }

  bool get isSupported => isAtLeast(
        minSupported.major,
        minSupported.minor,
        minSupported.patch,
      );

  @override
  int compareTo(WebApiVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  @override
  String toString() => '$major.$minor.$patch';

  @override
  bool operator ==(Object other) =>
      other is WebApiVersion &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);
}
