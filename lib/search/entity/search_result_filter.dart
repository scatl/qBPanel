import 'package:qbpanel/l10n/app_localizations.dart';

/// 客户端结果过滤（对齐 qB WebUI seeds / size 过滤器）。
class SearchResultFilter {
  const SearchResultFilter({
    this.minSeeders = 0,
    this.maxSeeders = 0,
    this.minSizeValue = 0,
    this.minSizeUnit = 2,
    this.maxSizeValue = 0,
    this.maxSizeUnit = 3,
  });

  /// 0 表示不限制。
  final int minSeeders;
  final int maxSeeders;

  final double minSizeValue;
  final int minSizeUnit;
  final double maxSizeValue;
  final int maxSizeUnit;

  bool get isActive =>
      minSeeders > 0 ||
      maxSeeders > 0 ||
      minSizeValue > 0 ||
      maxSizeValue > 0;

  SearchResultFilter copyWith({
    int? minSeeders,
    int? maxSeeders,
    double? minSizeValue,
    int? minSizeUnit,
    double? maxSizeValue,
    int? maxSizeUnit,
  }) {
    return SearchResultFilter(
      minSeeders: minSeeders ?? this.minSeeders,
      maxSeeders: maxSeeders ?? this.maxSeeders,
      minSizeValue: minSizeValue ?? this.minSizeValue,
      minSizeUnit: minSizeUnit ?? this.minSizeUnit,
      maxSizeValue: maxSizeValue ?? this.maxSizeValue,
      maxSizeUnit: maxSizeUnit ?? this.maxSizeUnit,
    );
  }
}

enum SearchSizeUnit {
  bytes(0, 'B'),
  kib(1, 'KiB'),
  mib(2, 'MiB'),
  gib(3, 'GiB'),
  tib(4, 'TiB'),
  pib(5, 'PiB'),
  eib(6, 'EiB');

  const SearchSizeUnit(this.power, this.label);

  final int power;
  final String label;

  static SearchSizeUnit fromPower(int power) {
    return SearchSizeUnit.values.firstWhere(
      (u) => u.power == power,
      orElse: () => SearchSizeUnit.mib,
    );
  }
}

/// 搜索插件选择（对应 `plugins` 参数）。
enum SearchPluginMode {
  enabled,
  all,
  single;

  String label(AppLocalizations l10n) => switch (this) {
        SearchPluginMode.enabled => l10n.searchPluginEnabled,
        SearchPluginMode.all => l10n.searchPluginAll,
        SearchPluginMode.single => l10n.searchPluginSingle,
      };
}
