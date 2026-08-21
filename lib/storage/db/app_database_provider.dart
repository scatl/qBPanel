import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/storage/db/app_database.dart';

/// 全局 Drift 数据库。App 退出时由 Provider 自动 close。
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
