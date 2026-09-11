import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:clarity/main.dart';
import 'package:clarity/services/session_service.dart';
import 'package:clarity/services/user_repository.dart';
import 'package:clarity/services/task_repository.dart';
import 'package:clarity/providers/theme_provider.dart';
import 'package:clarity/providers/auth_provider.dart';
import 'package:clarity/providers/task_provider.dart';

void main() {
  testWidgets('Clarity smoke test loads successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final sessionService = SessionService(prefs);
    final userRepository = UserRepository(prefs);
    final taskRepository = TaskRepository(prefs);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(sessionService)),
          ChangeNotifierProvider(create: (_) => AuthProvider(sessionService, userRepository)),
          ChangeNotifierProvider(create: (_) => TaskProvider(taskRepository)),
        ],
        child: const ClarityApp(),
      ),
    );

    // Initial render is the login screen
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
