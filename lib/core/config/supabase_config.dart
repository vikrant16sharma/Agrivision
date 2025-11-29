class SupabaseConfig {
  static const String supabaseUrl =
      'https://fggdlxyyedjtwwpfndiv.supabase.co';

  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZnZ2RseHl5ZWRqdHd3cGZuZGl2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyNzQ3MTAsImV4cCI6MjA3Njg1MDcxMH0.rrZXXkVaQuxCLht-hJ6z89Zbr1tQtS2EU8Fb2EHVK6A';

  /// Base URL for Edge Functions
  static const String functionsBaseUrl =
      '$supabaseUrl/functions/v1/make-server-dfec6474';
}
