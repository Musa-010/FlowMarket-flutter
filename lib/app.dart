import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';

class FlowMarketApp extends ConsumerStatefulWidget {
  const FlowMarketApp({super.key});

  @override
  ConsumerState<FlowMarketApp> createState() => _FlowMarketAppState();
}

class _FlowMarketAppState extends ConsumerState<FlowMarketApp> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((uri) {
      final router = ref.read(appRouterProvider);
      final path = uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : '');
      router.go(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FlowMarket',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
