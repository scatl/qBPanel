import 'package:drift/drift.dart';

/// qBittorrent 服务器连接配置
class QbServers extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 显示名称，如「家里 NAS」
  TextColumn get name => text().withLength(min: 1, max: 64)();

  /// 主机
  TextColumn get host => text().withLength(min: 1, max: 255)();

  /// 端口
  IntColumn get port => integer().withDefault(const Constant(8080))();

  /// 是否 HTTPS
  BoolColumn get useHttps => boolean().withDefault(const Constant(false))();

  /// WebUI 路径前缀，不含首尾 `/`，如 `nas/qb`；无反向代理则空
  TextColumn get path => text().withDefault(const Constant(''))();

  /// apikey
  TextColumn get apiKey => text()();

  /// `/app/version`，保存时写入
  TextColumn get appVersion => text().withDefault(const Constant(''))();

  /// `/app/webapiVersion`，保存时写入
  TextColumn get apiVersion => text().withDefault(const Constant(''))();

  /// `/app/buildInfo` 的 JSON 文本，保存时写入
  TextColumn get buildInfo => text().withDefault(const Constant(''))();

  /// 是否当前选中
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
