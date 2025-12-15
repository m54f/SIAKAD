// This is a basic smoke test for the application.
//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:academic_system/main.dart'; // Pastikan import ini benar
import 'package:academic_system/utils/constants.dart'; // Impor untuk mendapatkan AppStrings

void main() {
  testWidgets('App should launch and show login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login screen is displayed by finding the app title.
    // AppStrings.appName adalah 'Sistem Informasi Akademik'
    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}