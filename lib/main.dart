import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/add_task/add_task_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/lists/lists_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/session_service.dart';
import 'services/task_repository.dart';
import 'services/user_repository.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent local storage
  final prefs = await SharedPreferences.getInstance();
  final sessionService = SessionService(prefs);
  final userRepository = UserRepository(prefs);
  final taskRepository = TaskRepository(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(sessionService)),
        ChangeNotifierProvider(create: (_) => AuthProvider(sessionService, userRepository)),
        ChangeNotifierProvider(create: (_) => TaskProvider(taskRepository)),
      ],
      child: const ClarityApp(),
    ),
  );
}

class ClarityApp extends StatelessWidget {
  const ClarityApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Flowstate - Tasks & Momentum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  String _currentScreen = 'dashboard';

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // If user is not logged in, enforce the LoginScreen
    if (!auth.isLoggedIn || _currentScreen == 'login') {
      return LoginScreen(
        onLoginSuccess: () {
          setState(() {
            _currentScreen = 'dashboard';
          });
        },
      );
    }

    // Handle back navigation nicely on Android and Web browser back
    return PopScope(
      canPop: _currentScreen == 'dashboard',
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentScreen != 'dashboard') {
          setState(() {
            _currentScreen = 'dashboard';
          });
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _buildScreen(_currentScreen),
      ),
    );
  }

  Widget _buildScreen(String screen) {
    switch (screen) {
      case 'dashboard':
        return DashboardScreen(
          key: const ValueKey('dashboard'),
          onNavigate: _navigateTo,
        );
      case 'calendar':
        return CalendarScreen(
          key: const ValueKey('calendar'),
          onNavigate: _navigateTo,
        );
      case 'add_task':
        return AddTaskScreen(
          key: const ValueKey('add_task'),
          onBack: () => _navigateTo('dashboard'),
        );
      case 'lists':
        return ListsScreen(
          key: const ValueKey('lists'),
          onNavigate: _navigateTo,
        );
      case 'settings':
        return SettingsScreen(
          key: const ValueKey('settings'),
          onNavigate: _navigateTo,
        );
      default:
        return DashboardScreen(
          key: const ValueKey('dashboard_default'),
          onNavigate: _navigateTo,
        );
    }
  }
}
