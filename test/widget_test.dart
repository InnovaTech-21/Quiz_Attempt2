// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/menu.dart';
import 'package:quiz_website/main.dart';

import 'package:quiz_website/Views/Login/login_view.dart';



class MockBuildContext extends Mock implements BuildContext {}
class DatabaseServiceMock {
  Future<User?>loginUsingEmailPassword({required String email, required String password ,required BuildContext context  }) async{
    // Here, you would implement the logic to retrieve a user
    // from your database using the given username.
    // For this example, we'll just return a hardcoded user.
    User? user;
    if (email == 'john_doe') {
      return user;
    } else {
      return null;
    }
  }
}
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('INNOVATECH QUIZ PLATFORM'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });


  testWidgets('User can log in with valid credentials', (WidgetTester tester) async {
    // Mock the database response to return a user with a valid username and password
    final databaseServiceMock = DatabaseServiceMock();

    ///find out what user is and how it is supposed to be returned to mock
    final mockContext = MockBuildContext();
    User? user;
    when(databaseServiceMock.loginUsingEmailPassword(email: "john_doe", password: 'password123', context: mockContext))
        .thenAnswer((_) async => user);


    // Build the login form widget
    await tester.pumpWidget(LoginPage());

    // Enter the username and password into the login form
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'john_doe');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');

    // Tap the login button
    await tester.tap(find.widgetWithText(TextButton, 'Login'));

    // Wait for the next frame to complete the login process
    await tester.pump();

    // Check that the app navigates to the dashboard page
    expect(find.byType(MenuPage), findsOneWidget);
  });
}
