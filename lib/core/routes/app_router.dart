import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import 'package:ngopss/features/catalog/presentation/pages/dashboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String cart = '/cart';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    onboarding: (_) => const OnboardingPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    verifyEmail: (_) => const VerifyEmailPage(),
    dashboard: (_) => const DashboardPage(),
    cart: (_) => const CartPage(),
  };
}
