import 'package:qbpanel/storage/db/app_database.dart';

/// 一次请求用的连接参数（激活服务器或保存前探测）。
class ServerConnection {
  const ServerConnection({
    required this.host,
    required this.port,
    required this.useHttps,
    this.path = '',
    this.apiKey = '',
    this.username = '',
    this.password = '',
  });

  factory ServerConnection.fromServer(QbServer server) {
    return ServerConnection(
      host: server.host,
      port: server.port,
      useHttps: server.useHttps,
      path: server.path,
      apiKey: server.apiKey,
      username: server.username,
      password: server.password,
    );
  }

  final String host;
  final int port;
  final bool useHttps;
  final String path;
  final String apiKey;
  final String username;
  final String password;

  bool get usesApiKey => apiKey.trim().isNotEmpty;

  bool get usesCookie => !usesApiKey && username.trim().isNotEmpty;

  bool get hasCredentials => usesApiKey || usesCookie;

  String get baseUrl {
    final scheme = useHttps ? 'https' : 'http';
    final prefix = path.trim().replaceAll(RegExp(r'^/+|/+$'), '');
    if (prefix.isEmpty) {
      return '$scheme://$host:$port';
    }
    return '$scheme://$host:$port/$prefix';
  }

  String get sessionKey => '$baseUrl|${username.trim()}';
}
