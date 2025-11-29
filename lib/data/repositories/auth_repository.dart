import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository({required this.supabase});

  // Sign Up New User
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'user_metadata': {'name': name},
        },
      );

      return response.user;
    } on AuthException catch (e) {
      throw Exception('Auth Error: ${e.message}');
    } catch (_) {
      throw Exception('Sign-up failed');
    }
  }

  // Sign In User
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      throw Exception('Auth Error: ${e.message}');
    } catch (_) {
      throw Exception('Sign-in failed');
    }
  }

  // Logout User
  Future<void> signOut() async {
    await supabase.auth.signOut(scope: SignOutScope.local);
  }

  // Current user
  User? getCurrentUser() => supabase.auth.currentUser;

  // Convert to UserModel
  UserModel? getCurrentUserModel() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final meta = user.userMetadata?['user_metadata'] ?? {};

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: meta['name'] ?? "Farmer",
      createdAt: DateTime.tryParse(user.createdAt ?? '') ?? DateTime.now(),
    );
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
