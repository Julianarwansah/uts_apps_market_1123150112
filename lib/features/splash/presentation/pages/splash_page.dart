import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_apps_market_1123150112/core/router/app_router.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // Tunggu sebentar agar splash terlihat
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final status = context.read<AuthProvider>().status;
    switch (status) {
      case AuthStatus.authenticated:
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      case AuthStatus.emailNotVerified:
        Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
      default:
        Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFF1565C0)),
            SizedBox(height: 16),
            Text(
              'Apps Market',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
