// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QbServersTable extends QbServers
    with TableInfo<$QbServersTable, QbServer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QbServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8080),
  );
  static const VerificationMeta _useHttpsMeta = const VerificationMeta(
    'useHttps',
  );
  @override
  late final GeneratedColumn<bool> useHttps = GeneratedColumn<bool>(
    'use_https',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_https" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
    'api_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _apiVersionMeta = const VerificationMeta(
    'apiVersion',
  );
  @override
  late final GeneratedColumn<String> apiVersion = GeneratedColumn<String>(
    'api_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _buildInfoMeta = const VerificationMeta(
    'buildInfo',
  );
  @override
  late final GeneratedColumn<String> buildInfo = GeneratedColumn<String>(
    'build_info',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    host,
    port,
    useHttps,
    path,
    apiKey,
    appVersion,
    apiVersion,
    buildInfo,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qb_servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<QbServer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('use_https')) {
      context.handle(
        _useHttpsMeta,
        useHttps.isAcceptableOrUnknown(data['use_https']!, _useHttpsMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    }
    if (data.containsKey('api_key')) {
      context.handle(
        _apiKeyMeta,
        apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    if (data.containsKey('api_version')) {
      context.handle(
        _apiVersionMeta,
        apiVersion.isAcceptableOrUnknown(data['api_version']!, _apiVersionMeta),
      );
    }
    if (data.containsKey('build_info')) {
      context.handle(
        _buildInfoMeta,
        buildInfo.isAcceptableOrUnknown(data['build_info']!, _buildInfoMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QbServer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QbServer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      useHttps: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_https'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      apiKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_key'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      apiVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_version'],
      )!,
      buildInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}build_info'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $QbServersTable createAlias(String alias) {
    return $QbServersTable(attachedDatabase, alias);
  }
}

class QbServer extends DataClass implements Insertable<QbServer> {
  final int id;

  /// 显示名称，如「家里 NAS」
  final String name;

  /// 主机
  final String host;

  /// 端口
  final int port;

  /// 是否 HTTPS
  final bool useHttps;

  /// WebUI 路径前缀，不含首尾 `/`，如 `nas/qb`；无反向代理则空
  final String path;

  /// apikey
  final String apiKey;

  /// `/app/version`，保存时写入
  final String appVersion;

  /// `/app/webapiVersion`，保存时写入
  final String apiVersion;

  /// `/app/buildInfo` 的 JSON 文本，保存时写入
  final String buildInfo;

  /// 是否当前选中
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const QbServer({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.useHttps,
    required this.path,
    required this.apiKey,
    required this.appVersion,
    required this.apiVersion,
    required this.buildInfo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['use_https'] = Variable<bool>(useHttps);
    map['path'] = Variable<String>(path);
    map['api_key'] = Variable<String>(apiKey);
    map['app_version'] = Variable<String>(appVersion);
    map['api_version'] = Variable<String>(apiVersion);
    map['build_info'] = Variable<String>(buildInfo);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QbServersCompanion toCompanion(bool nullToAbsent) {
    return QbServersCompanion(
      id: Value(id),
      name: Value(name),
      host: Value(host),
      port: Value(port),
      useHttps: Value(useHttps),
      path: Value(path),
      apiKey: Value(apiKey),
      appVersion: Value(appVersion),
      apiVersion: Value(apiVersion),
      buildInfo: Value(buildInfo),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory QbServer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QbServer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      useHttps: serializer.fromJson<bool>(json['useHttps']),
      path: serializer.fromJson<String>(json['path']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      apiVersion: serializer.fromJson<String>(json['apiVersion']),
      buildInfo: serializer.fromJson<String>(json['buildInfo']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'useHttps': serializer.toJson<bool>(useHttps),
      'path': serializer.toJson<String>(path),
      'apiKey': serializer.toJson<String>(apiKey),
      'appVersion': serializer.toJson<String>(appVersion),
      'apiVersion': serializer.toJson<String>(apiVersion),
      'buildInfo': serializer.toJson<String>(buildInfo),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  QbServer copyWith({
    int? id,
    String? name,
    String? host,
    int? port,
    bool? useHttps,
    String? path,
    String? apiKey,
    String? appVersion,
    String? apiVersion,
    String? buildInfo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => QbServer(
    id: id ?? this.id,
    name: name ?? this.name,
    host: host ?? this.host,
    port: port ?? this.port,
    useHttps: useHttps ?? this.useHttps,
    path: path ?? this.path,
    apiKey: apiKey ?? this.apiKey,
    appVersion: appVersion ?? this.appVersion,
    apiVersion: apiVersion ?? this.apiVersion,
    buildInfo: buildInfo ?? this.buildInfo,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  QbServer copyWithCompanion(QbServersCompanion data) {
    return QbServer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      useHttps: data.useHttps.present ? data.useHttps.value : this.useHttps,
      path: data.path.present ? data.path.value : this.path,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      apiVersion: data.apiVersion.present
          ? data.apiVersion.value
          : this.apiVersion,
      buildInfo: data.buildInfo.present ? data.buildInfo.value : this.buildInfo,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QbServer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('useHttps: $useHttps, ')
          ..write('path: $path, ')
          ..write('apiKey: $apiKey, ')
          ..write('appVersion: $appVersion, ')
          ..write('apiVersion: $apiVersion, ')
          ..write('buildInfo: $buildInfo, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    host,
    port,
    useHttps,
    path,
    apiKey,
    appVersion,
    apiVersion,
    buildInfo,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QbServer &&
          other.id == this.id &&
          other.name == this.name &&
          other.host == this.host &&
          other.port == this.port &&
          other.useHttps == this.useHttps &&
          other.path == this.path &&
          other.apiKey == this.apiKey &&
          other.appVersion == this.appVersion &&
          other.apiVersion == this.apiVersion &&
          other.buildInfo == this.buildInfo &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QbServersCompanion extends UpdateCompanion<QbServer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> host;
  final Value<int> port;
  final Value<bool> useHttps;
  final Value<String> path;
  final Value<String> apiKey;
  final Value<String> appVersion;
  final Value<String> apiVersion;
  final Value<String> buildInfo;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const QbServersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.useHttps = const Value.absent(),
    this.path = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.apiVersion = const Value.absent(),
    this.buildInfo = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  QbServersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String host,
    this.port = const Value.absent(),
    this.useHttps = const Value.absent(),
    this.path = const Value.absent(),
    required String apiKey,
    this.appVersion = const Value.absent(),
    this.apiVersion = const Value.absent(),
    this.buildInfo = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       host = Value(host),
       apiKey = Value(apiKey);
  static Insertable<QbServer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? host,
    Expression<int>? port,
    Expression<bool>? useHttps,
    Expression<String>? path,
    Expression<String>? apiKey,
    Expression<String>? appVersion,
    Expression<String>? apiVersion,
    Expression<String>? buildInfo,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (useHttps != null) 'use_https': useHttps,
      if (path != null) 'path': path,
      if (apiKey != null) 'api_key': apiKey,
      if (appVersion != null) 'app_version': appVersion,
      if (apiVersion != null) 'api_version': apiVersion,
      if (buildInfo != null) 'build_info': buildInfo,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  QbServersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? host,
    Value<int>? port,
    Value<bool>? useHttps,
    Value<String>? path,
    Value<String>? apiKey,
    Value<String>? appVersion,
    Value<String>? apiVersion,
    Value<String>? buildInfo,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return QbServersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      useHttps: useHttps ?? this.useHttps,
      path: path ?? this.path,
      apiKey: apiKey ?? this.apiKey,
      appVersion: appVersion ?? this.appVersion,
      apiVersion: apiVersion ?? this.apiVersion,
      buildInfo: buildInfo ?? this.buildInfo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (useHttps.present) {
      map['use_https'] = Variable<bool>(useHttps.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (apiVersion.present) {
      map['api_version'] = Variable<String>(apiVersion.value);
    }
    if (buildInfo.present) {
      map['build_info'] = Variable<String>(buildInfo.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QbServersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('useHttps: $useHttps, ')
          ..write('path: $path, ')
          ..write('apiKey: $apiKey, ')
          ..write('appVersion: $appVersion, ')
          ..write('apiVersion: $apiVersion, ')
          ..write('buildInfo: $buildInfo, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QbServersTable qbServers = $QbServersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [qbServers];
}

typedef $$QbServersTableCreateCompanionBuilder =
    QbServersCompanion Function({
      Value<int> id,
      required String name,
      required String host,
      Value<int> port,
      Value<bool> useHttps,
      Value<String> path,
      required String apiKey,
      Value<String> appVersion,
      Value<String> apiVersion,
      Value<String> buildInfo,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$QbServersTableUpdateCompanionBuilder =
    QbServersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> host,
      Value<int> port,
      Value<bool> useHttps,
      Value<String> path,
      Value<String> apiKey,
      Value<String> appVersion,
      Value<String> apiVersion,
      Value<String> buildInfo,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$QbServersTableFilterComposer
    extends Composer<_$AppDatabase, $QbServersTable> {
  $$QbServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useHttps => $composableBuilder(
    column: $table.useHttps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiKey => $composableBuilder(
    column: $table.apiKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiVersion => $composableBuilder(
    column: $table.apiVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buildInfo => $composableBuilder(
    column: $table.buildInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QbServersTableOrderingComposer
    extends Composer<_$AppDatabase, $QbServersTable> {
  $$QbServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useHttps => $composableBuilder(
    column: $table.useHttps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiKey => $composableBuilder(
    column: $table.apiKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiVersion => $composableBuilder(
    column: $table.apiVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buildInfo => $composableBuilder(
    column: $table.buildInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QbServersTableAnnotationComposer
    extends Composer<_$AppDatabase, $QbServersTable> {
  $$QbServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<bool> get useHttps =>
      $composableBuilder(column: $table.useHttps, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apiVersion => $composableBuilder(
    column: $table.apiVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buildInfo =>
      $composableBuilder(column: $table.buildInfo, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$QbServersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QbServersTable,
          QbServer,
          $$QbServersTableFilterComposer,
          $$QbServersTableOrderingComposer,
          $$QbServersTableAnnotationComposer,
          $$QbServersTableCreateCompanionBuilder,
          $$QbServersTableUpdateCompanionBuilder,
          (QbServer, BaseReferences<_$AppDatabase, $QbServersTable, QbServer>),
          QbServer,
          PrefetchHooks Function()
        > {
  $$QbServersTableTableManager(_$AppDatabase db, $QbServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QbServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QbServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QbServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<bool> useHttps = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> apiKey = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<String> apiVersion = const Value.absent(),
                Value<String> buildInfo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => QbServersCompanion(
                id: id,
                name: name,
                host: host,
                port: port,
                useHttps: useHttps,
                path: path,
                apiKey: apiKey,
                appVersion: appVersion,
                apiVersion: apiVersion,
                buildInfo: buildInfo,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String host,
                Value<int> port = const Value.absent(),
                Value<bool> useHttps = const Value.absent(),
                Value<String> path = const Value.absent(),
                required String apiKey,
                Value<String> appVersion = const Value.absent(),
                Value<String> apiVersion = const Value.absent(),
                Value<String> buildInfo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => QbServersCompanion.insert(
                id: id,
                name: name,
                host: host,
                port: port,
                useHttps: useHttps,
                path: path,
                apiKey: apiKey,
                appVersion: appVersion,
                apiVersion: apiVersion,
                buildInfo: buildInfo,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QbServersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QbServersTable,
      QbServer,
      $$QbServersTableFilterComposer,
      $$QbServersTableOrderingComposer,
      $$QbServersTableAnnotationComposer,
      $$QbServersTableCreateCompanionBuilder,
      $$QbServersTableUpdateCompanionBuilder,
      (QbServer, BaseReferences<_$AppDatabase, $QbServersTable, QbServer>),
      QbServer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QbServersTableTableManager get qbServers =>
      $$QbServersTableTableManager(_db, _db.qbServers);
}
