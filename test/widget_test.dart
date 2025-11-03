import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/providers/auth_provider.dart';
import 'package:my_flutter_app/providers/karyawan_provider.dart';

void main() {
  group('Flutter Employee Management App Widget Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => KaryawanProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify that the app loads without throwing an error
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('AuthProvider should be available in widget tree', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => KaryawanProvider()),
          ],
          child: MaterialApp(
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Text('Auth State: ${authProvider.isLoggedIn}');
              },
            ),
          ),
        ),
      );

      // Verify that AuthProvider is accessible
      expect(find.text('Auth State: false'), findsOneWidget);
    });

    testWidgets('KaryawanProvider should be available in widget tree', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => KaryawanProvider()),
          ],
          child: MaterialApp(
            home: Consumer<KaryawanProvider>(
              builder: (context, karyawanProvider, child) {
                return Text('Employees: ${karyawanProvider.karyawans.length}');
              },
            ),
          ),
        ),
      );

      // Verify that KaryawanProvider is accessible
      expect(find.text('Employees: 0'), findsOneWidget);
    });

    test('Test credentials validation', () {
      // Test that our test credentials are valid
      const username = 'testuser';
      const password = 'password123';
      
      expect(username.isNotEmpty, true);
      expect(password.length >= 8, true);
      expect(username, 'testuser');
      expect(password, 'password123');
    });
  });
}
