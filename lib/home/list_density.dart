import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/storage/sp_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 首页种子列表密度。
enum ListDensity {
  standard,
  compact;

  String label(AppLocalizations l10n) => switch (this) {
    ListDensity.standard => l10n.settingsListDensityStandard,
    ListDensity.compact => l10n.settingsListDensityCompact,
  };

  static ListDensity parse(String? raw) {
    return ListDensity.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ListDensity.standard,
    );
  }
}

final listDensityProvider =
    NotifierProvider<ListDensityController, ListDensity>(
      ListDensityController.new,
    );

class ListDensityController extends Notifier<ListDensity> {
  @override
  ListDensity build() {
    Future.microtask(_restore);
    return ListDensity.standard;
  }

  Future<void> _restore() async {
    final sp = await SharedPreferences.getInstance();
    state = ListDensity.parse(sp.getString(SpKey.list.keyDensity));
  }

  Future<void> setDensity(ListDensity density) async {
    state = density;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SpKey.list.keyDensity, density.name);
  }
}
