import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;
  bool _resendCooldown = false;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final success = await auth.checkEmailVerified();
      if (success && mounted) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown) return;
    await context.read<AuthProvider>().resendVerificationEmail();

    setState(() {
      _resendCooldown = true;
      _countdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _countdown--;
      });
      if (_countdown <= 0) {
        t.cancel();
        setState(() => _resendCooldown = false);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verifikasi sudah dikirim ulang')),
      );
    }
  }
}
