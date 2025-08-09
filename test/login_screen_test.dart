import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/services/backend_service.dart';
import 'package:flutter_application_1/config/env_config.dart';

void main() {
  setUpAll(() async {
    // Initialize environment config for tests
    await EnvConfig.initialize();
    // Initialize the backend service for tests
    BackendService.initialize();
  });
  group('LoginScreen Tests', () {
    testWidgets('LoginScreen displays all required elements', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Wait for initialization
      await tester.pump();

      // Verify that the login screen displays the required elements
      expect(find.text('Chào mừng bạn trở lại!'), findsOneWidget);

      // Check for email field
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and password fields

      // Check for login button (title and button both have "Đăng nhập")
      expect(find.text('Đăng nhập'), findsNWidgets(2)); // Title and button

      // Check for Google sign-in button
      expect(find.text('Đăng nhập với Google'), findsOneWidget);

      // Check for forgot password link
      expect(find.text('Quên mật khẩu?'), findsOneWidget);
    });

    testWidgets('Email validation works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Find the email field (first TextFormField)
      final emailField = find.byType(TextFormField).first;

      // Enter invalid email
      await tester.enterText(emailField, 'invalid-email');

      // Tap login button to trigger validation
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pump();

      // Check if validation error appears
      expect(find.text('Email không hợp lệ'), findsOneWidget);
    });

    testWidgets('Password validation works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Find the password field (second TextFormField)
      final passwordField = find.byType(TextFormField).at(1);

      // Enter short password
      await tester.enterText(passwordField, '123');

      // Tap login button to trigger validation
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pump();

      // Check if validation error appears
      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Find the password field
      final passwordField = find.byType(TextFormField).at(1);

      // Enter some text
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Find the visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility);
      expect(visibilityButton, findsOneWidget);

      // Tap the visibility button
      await tester.tap(visibilityButton);
      await tester.pump();

      // Check if icon changed to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Forgot password button shows snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Wait for initialization
      await tester.pump();

      // Scroll down to make the forgot password button visible
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      // Find and tap forgot password button
      final forgotPasswordButton = find.text('Quên mật khẩu?');
      await tester.tap(forgotPasswordButton);
      await tester.pump();

      // Check if snackbar appears
      expect(
        find.text('Tính năng quên mật khẩu sẽ được phát triển'),
        findsOneWidget,
      );
    });

    testWidgets('Valid form submission shows success message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Enter valid email and password
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pump();

      // Check if loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the simulated login process to complete
      await tester.pump(const Duration(seconds: 3));

      // Check if success message appears
      expect(find.text('Đăng nhập thành công!'), findsOneWidget);
    });
  });
}
