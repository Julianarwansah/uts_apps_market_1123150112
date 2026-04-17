import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/pages/login_page.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/pages/verify_email_page.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/providers/auth_provider.dart';

// Bungkus halaman yang butuh autentikasi dengan AuthGuard
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    return switch (status) {
      AuthStatus.authenticated    => child,                   // Lanjut ke halaman
      AuthStatus.emailNotVerified => const VerifyEmailPage(), // Redirect verifikasi
      _                           => const LoginPage(),       // Redirect login
    };
  }
}

// Penggunaan di routes:
// dashboard: (_) => const AuthGuard(child: DashboardPage())
//            ↑ DashboardPage HANYA muncul jika status = authenticated
