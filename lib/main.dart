import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/inbound/inbound_torrent_open.dart';
import 'package:qbpanel/router/app_router.dart';
import 'package:qbpanel/theme/system_ui.dart';
import 'package:qbpanel/theme/theme_builder.dart';
import 'package:qbpanel/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  enableEdgeToEdge();
  runApp(const ProviderScope(child: QBPanelApp()));
}

class QBPanelApp extends ConsumerStatefulWidget {
  const QBPanelApp({super.key});

  @override
  ConsumerState<QBPanelApp> createState() => _QBPanelAppState();
}

class _QBPanelAppState extends ConsumerState<QBPanelApp> {
  InboundTorrentOpen? _inboundOpen;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final inbound = InboundTorrentOpen(ref);
        _inboundOpen = inbound;
        inbound.start();
      });
    }
  }

  @override
  void dispose() {
    _inboundOpen?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(themeSettingProvider);

    return ThemeBuilder(
      themeSettings: settings,
      builder: (light, dark) {
        return MaterialApp.router(
          title: 'qBPanel',
          debugShowCheckedModeBanner: false,
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
