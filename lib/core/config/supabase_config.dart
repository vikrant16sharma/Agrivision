import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl =
      'https://omtnrbsqvprkwezywbnh.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9tdG5yYnNxdnBya3d3ZXp5d2JuaCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzYxNzc3NzgzLCJleHAiOjIwNzczNTM3ODN9.52oU_Oz4sj_wWB9C3ciSpC4ZKvROmSIc-DZFwq82nzI';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}