abstract final class SpKey {
  static const theme = _Theme();
  static const locale = _Locale();
  static const list = _List();
}

class _Theme {
  const _Theme();
  final keyMode = 'theme_mode';
  final keyDynamic = 'theme_use_dynamic_color';
  final keySeedColor = 'theme_seed_color';
}

class _Locale {
  const _Locale();
  final keyMode = 'app_locale_mode';
}

class _List {
  const _List();
  final keyDensity = 'list_density';
}
