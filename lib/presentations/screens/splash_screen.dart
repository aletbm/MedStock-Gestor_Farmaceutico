import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/presentations/providers/session_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        ref.read(splashDoneProvider.notifier).state = true;
        final session = ref.read(sessionProvider);
        if (session == true) context.go('/product-list');
        if (session == false) context.go('/login');
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/medstock_logo.png', width: 200),
            SizedBox(height: 40),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}