import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/service_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    //Kasih delay 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final hasSeenOnboarding = await SecureStorageService.hasSeenOnboarding();
    final token = await SecureStorageService.getToken();

    if (!hasSeenOnboarding) {
      //Baru first pertama kali install
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    } else if (token != null) {
      //Udah pernah install dan token login masih ada
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else {
      //Udah pernah install tapi belum login / abis logout
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/app_icon.png', height: 150, width: 150),
          ],
        ),
      ),
    );
  }
}
