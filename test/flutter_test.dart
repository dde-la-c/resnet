import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pruebaresnet/screens/login_screen.dart';
import 'package:pruebaresnet/screens/signup_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Validating login with empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Por favor completa todos los campos'), findsOneWidget);
    });

    // Add more test cases for different scenarios in LoginScreen
  });

  group('SignUpScreen', () {
    testWidgets('Validating registration with empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Por favor completa todos los campos'), findsOneWidget);
    });

    // Add more test cases for different scenarios in SignUpScreen
  });
}
