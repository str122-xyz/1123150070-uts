import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/catalog/presentation/providers/product_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => CatalogProvider()..fetchProducts(),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
      title: 'Ngopss',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
