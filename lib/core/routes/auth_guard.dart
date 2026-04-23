import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Pantau status login user secara realtime
    final status = context.watch<AuthProvider>().status;

    // Switch expression
    return switch (status) {
      AuthStatus.authenticated => child, //jika udah login & verified -> Lanjut
      AuthStatus.emailNotVerified =>
        const VerifyEmailPage(), //jika login tapi belum verified -> Tahan
      _ =>
        const LoginPage(), //udh gitu (unauthenticated/initial) -> Tendang ke Login
    };
  }
}
