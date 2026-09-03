import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/inbound/inbound_torrent_open.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/router/app_router.dart';
import 'package:qbpanel/theme/system_ui.dart';
import 'package:qbpanel/theme/theme_builder.dart';
import 'package:qbpanel/theme/theme_controller.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  enableEdgeToEdge();
  runApp(ProviderScope(child: QBPanelApp(launchArgs: args)));
}

class QBPanelApp extends ConsumerStatefulWidget {
  const QBPanelApp({super.key, this.launchArgs = const []});

  final List<String> launchArgs;

  @override
  ConsumerState<QBPanelApp> createState() => _QBPanelAppState();
}

class _QBPanelAppState extends ConsumerState<QBPanelApp>
    with WidgetsBindingObserver {
  InboundTorrentOpen? _inboundOpen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final inbound = InboundTorrentOpen(ref);
        _inboundOpen = inbound;
        inbound.start(launchArgs: widget.launchArgs);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inboundOpen?.dispose();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    final locale = locales?.firstOrNull ??
        WidgetsBinding.instance.platformDispatcher.locale;
    ref.read(platformLocaleProvider.notifier).setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(themeSettingProvider);
    final locale = ref.watch(resolvedAppLocaleProvider);

    return ThemeBuilder(
      themeSettings: settings,
      builder: (light, dark) {
        return MaterialApp.router(
          title: 'qBPanel',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          themeMode: settings.themeMode,
          theme: light,
          darkTheme: dark,
          routerConfig: appRouter,
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: systemUiOverlayStyle(brightness),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
