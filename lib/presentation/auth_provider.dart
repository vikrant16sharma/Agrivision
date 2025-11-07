import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Initialize auth state
  void initialize() {
    _currentUser = authRepository.getCurrentUserModel();
    notifyListeners();

    authRepository.authStateChanges.listen((AuthState data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _currentUser = authRepository.getCurrentUserModel();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _currentUser = null;
      }
      notifyListeners();
    });
}

  /// Sign up new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authRepository.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        _currentUser = authRepository.getCurrentUserModel();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in existing user
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authRepository.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = authRepository.getCurrentUserModel();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}