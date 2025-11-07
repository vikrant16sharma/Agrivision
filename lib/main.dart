import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/config/supabase_config.dart';
import 'package:provider/provider.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/auth_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait mode only for mobile)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SupabaseConfig.initialize();
  // TODO: Initialize Supabase
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',
  //   anonKey: 'YOUR_ANON_KEY',
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = AuthProvider(authRepository: AuthRepository());
            provider.initialize(); // ✅ works even if initialize() is async
            return provider;
          },
        ),
      ],
      child: const AgriVisionApp(),
    ),
  );

}
