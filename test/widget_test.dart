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

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockBuildContext extends Mock implements BuildContext {}
class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential({required this.user});

  @override
  final User user;

}
class MockUser extends Mock implements User {
  MockUser({this.email = '', this.password = ''});

  @override
  final String email;
  @override
  final String password;
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('INNOVATECH QUIZ PLATFORM'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  // group('Firebase auth tests', ()
  // {
  //   late MockFirebaseAuth mockFirebaseAuth;
  //
  //   setUp(() {
  //     // Create a new mock instance of the FirebaseAuth class for each test
  //     mockFirebaseAuth = MockFirebaseAuth();
  //   });
  //
  //   test('User can log in with valid credentials', () async {
  //     // Create a new mock user
  //     final mockUser = MockUser(email: 'test@example.com', password: 'password123');
  //
  //     // Mock the signInWithEmailAndPassword method of mockFirebaseAuth
  //     when(mockFirebaseAuth.signInWithEmailAndPassword(
  //         email: 'test@example.com', password: 'password123'))
  //         .thenAnswer((_) async {
  //           print('signInWithEmailAndPassword called');
  //           return MockUserCredential(user: mockUser);
  //     });
  //
  //     // Call the loginUsingEmailPassword function with the mock FirebaseAuth instance
  //     final result = await LoginPageState.loginUsingEmailPassword(email: 'test@example.com',
  //         password: 'password123',
  //         context: MockBuildContext(),
  //         auth: mockFirebaseAuth);
  //
  //     // Verify that the method returned the expected result
  //     expect(result, equals(mockUser));
  //   });
  //
  // });
  }


