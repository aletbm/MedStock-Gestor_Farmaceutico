import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medstock/debug_server.dart';
import 'package:medstock/presentations/providers/theme_provider.dart';
import 'core/router/app_router.dart';

void main() {
  assert((){
    startDebugServer();
    return true;
  }());
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(themeDataProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MedStock',
      theme: theme,
      routerConfig: router,
    );
  }
}

//& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" forward tcp:8080 tcp:8080
//& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" reboot