import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository({required this.supabase});

  // Sign Up
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Call custom signup endpoint
    final response = await supabase.functions.invoke(
      'make-server-dfec6474/signup',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    if (response.status == 200) {
      // Now sign in
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return authResponse.user;
    } else {
      throw Exception(response.data['error'] ?? 'Signup failed');
    }
  }

  // Sign In
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  // Sign Out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Get Current User as UserModel
  UserModel? getCurrentUserModel() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ?? 'User',
      createdAt: user.createdAt != null ? DateTime.parse(user.createdAt!) : null,
    );
  }

  // Auth State Stream
  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }
}