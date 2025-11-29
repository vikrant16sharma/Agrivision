import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/config/supabase_config.dart';

import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/scan/disease_scan_screen.dart';
import 'ui/screens/scan/scan_results_screen.dart';
import 'ui/widgets/navigation/bottom_navigation.dart';

// NEW: Add your yield screen import
import 'ui/screens/yield/yield_prediction_screen.dart';

import 'data/services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/scan_repository.dart';
import 'data/repositories/prediction_repository.dart';

import 'presentation/auth_provider.dart';
import 'presentation/scan_provider.dart';
import 'presentation/prediction_provider.dart';

/// Root application widget
class AgriVisionApp extends StatefulWidget {
  const AgriVisionApp({super.key});

  @override
  State<AgriVisionApp> createState() => _AgriVisionAppState();
}

class _AgriVisionAppState extends State<AgriVisionApp> {
  late final ApiService _apiService;
  late final AuthRepository _authRepository;
  late final ScanRepository _scanRepository;
  late final PredictionRepository _predictionRepository;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.lightOverlayStyle);
  }

  void _initializeServices() {
    final supabase = Supabase.instance.client;

    _apiService = ApiService(
      supabase: supabase,
    );

    _authRepository = AuthRepository(supabase: supabase);
    _scanRepository = ScanRepository(apiService: _apiService);
    _predictionRepository = PredictionRepository(apiService: _apiService);
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
          AuthProvider(authRepository: _authRepository)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScanProvider(scanRepository: _scanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PredictionProvider(predictionRepository: _predictionRepository),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'AgriVision',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: _buildHome(authProvider),
            routes: _buildRoutes(),
          );
        },
      ),
    );
  }

  Widget _buildHome(AuthProvider authProvider) {
    if (authProvider.isLoading) return const SplashScreen();
    return authProvider.isAuthenticated
        ? const MainScreen()
        : const LoginScreen();
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => const MainScreen(),
      '/login': (context) => const LoginScreen(),
      '/scan': (context) => const DiseaseScanScreen(),
      '/scan-results': (context) => const ScanResultsScreen(),

      // NEW: Route for yield prediction screen
      '/yield': (context) => const YieldPredictionScreen(),
    };
  }
}

/// SIMPLE SPLASH SCREEN
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16A34A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.agriculture,
                  size: 60, color: Colors.green),
            ),
            const SizedBox(height: 24),
            const Text(
              'AgriVision',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI-Powered Agricultural Assistant',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// MAIN SCREEN WITH BOTTOM NAVIGATION
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const DiseaseScanScreen(),
    const HistoryScreen(),
    const AdminScreen(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AgriVisionBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }
}

/// HISTORY SCREEN
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('History Screen',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text(
              'View your scan and prediction history',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

  }
}

/// ADMIN SCREEN
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Admin Dashboard',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('View system statistics and analytics',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
