import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_apps_market_1123150112/core/router/app_router.dart';
import 'package:uts_apps_market_1123150112/core/router/auth_guard.dart';
import 'package:uts_apps_market_1123150112/core/theme/app_theme.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/pages/login_page.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/pages/register_page.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/pages/verify_email_page.dart';
import 'package:uts_apps_market_1123150112/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_apps_market_1123150112/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:uts_apps_market_1123150112/features/product/presentation/providers/product_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTS Apps Market',
      theme: AppTheme.light,
      initialRoute: AppRouter.dashboard,
      routes: {
        AppRouter.login:       (_) => const LoginPage(),
        AppRouter.register:    (_) => const RegisterPage(),
        AppRouter.verifyEmail: (_) => const VerifyEmailPage(),

        // Hanya masuk jika status = authenticated
        AppRouter.dashboard: (_) => const AuthGuard(child: DashboardPage()),
      },
    );
  }
}
