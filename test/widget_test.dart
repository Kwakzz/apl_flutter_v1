import 'package:apl/homepage.dart';
import 'package:apl/launch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:apl/main.dart'; 

void main() {
  testWidgets('Test Initial Screen', (WidgetTester tester) async {
    // Simulate a logged-in user by adding necessary keys to SharedPreferences.
    SharedPreferences.setMockInitialValues({
      'email_address': 'test@example.com',
      'password': 'testpassword',
    });

    // Build your app and trigger a frame.
    await tester.pumpWidget(LaunchScreen());

    // Verify that HomePage is displayed for a logged-in user.
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(LaunchScreen), findsNothing);
  });

  testWidgets('Test Initial Screen for Guest', (WidgetTester tester) async {
    // Simulate a guest user by not adding necessary keys to SharedPreferences.
    SharedPreferences.setMockInitialValues({});

    // Build your app and trigger a frame.
    await tester.pumpWidget(LaunchScreen());

    // Verify that LaunchScreen is displayed for a guest user.
    expect(find.byType(LaunchScreen), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
}
