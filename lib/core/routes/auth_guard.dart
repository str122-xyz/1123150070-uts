import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectIfNeeded();
    });
  }

  void _redirectIfNeeded() {
    if (!mounted) return;

    final status = context.read<AuthProvider>().status;

    if (status == AuthStatus.emailNotVerified) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/verify-email',
        (route) => false,
      );
    } else if (status != AuthStatus.authenticated) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    // Jika udah login & verified
    if (status == AuthStatus.authenticated) {
      return widget.child;
    }

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Colors.brown)),
    );
  }
}
