import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait mode only for mobile)
  // This is done asynchronously to avoid blocking
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase asynchronously
  // Wrapped in try-catch to handle initialization errors gracefully
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      debug: false, // Set to true for development debugging
    );
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
    // Continue running app even if Supabase fails to initialize
    // User will see error messages when trying to use backend features
  }

  // Set up error handling for the app
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Run the app
  runApp(const AgriVisionApp());
}
