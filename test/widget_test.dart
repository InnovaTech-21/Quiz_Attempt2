// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_website/Views/Login/login_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_website/Views/Login/login_view.dart';

import 'package:quiz_website/menu.dart';
import 'package:quiz_website/main.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_website/Views/AnswerQuiz/ShortQuizAns.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:quiz_website/main.dart';



class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock User class
class MockUser extends Mock implements User {}

// Mock FirebaseFirestore class
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('INNOVATECH QUIZ PLATFORM'), findsOneWidget);
    expect(find.text('1'), findsNothing);

  }


  );
  group('MenuPage', () {
    late MenuPage menuPage;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirebaseFirestore;
    late MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseFirestore = MockFirebaseFirestore();
      mockUser = MockUser();
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      menuPage = MenuPage();
    });

    testWidgets('Test sign out button', (WidgetTester tester) async {
      await tester.pumpWidget(menuPage);

      final signOutButton = find.text('Sign out');
      expect(signOutButton, findsOneWidget);

      // Tap sign out button and verify navigation
      await tester.tap(signOutButton);
      await tester.pumpAndSettle();
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Test review quiz button', (WidgetTester tester) async {
      await tester.pumpWidget(menuPage);

      final reviewQuizButton = find.text('Review a Quiz');
      expect(reviewQuizButton, findsOneWidget);

      // Tap review quiz button and verify navigation
      await tester.tap(reviewQuizButton);
      await tester.pumpAndSettle();
      expect(find.byType(ShortQuizAnswer), findsOneWidget);
    });

    testWidgets('Test create quiz button', (WidgetTester tester) async {
      await tester.pumpWidget(menuPage);

      final createQuizButton = find.text('Create a Quiz');
      expect(createQuizButton, findsOneWidget);

      // Tap create quiz button and verify navigation
      await tester.tap(createQuizButton);
      await tester.pumpAndSettle();
      expect(find.byType(CreateQuizPage), findsOneWidget);
    });


  });
  late LoginPageState loginPageState;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    loginPageState = LoginPageState();
  });

  group('Login', () {
    testWidgets('Login button enabled when email and password are entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Login(
              auth: mockAuth,
            ),
          ),
        ),
      );

      final emailInput = find.byType(TextFormField).first;
      final passwordInput = find.byType(TextFormField).last;
      final loginButton = find.byType(ElevatedButton);

      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(emailInput, 'test@test.com');
      await tester.enterText(passwordInput, 'password');

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Login Successful'), findsOneWidget);
    });

    testWidgets('Login button disabled when email or password is not entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Login(
              auth: mockAuth,
            ),
          ),
        ),
      );

      final emailInput = find.byType(TextFormField).first;
      final passwordInput = find.byType(TextFormField).last;
      final loginButton = find.byType(ElevatedButton);

      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(emailInput, '');
      await tester.enterText(passwordInput, '');

      expect(tester.widget<ElevatedButton>(loginButton).enabled, false);
    });

    testWidgets('Login button triggers login process', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Login(
              auth: mockAuth,
            ),
          ),
        ),
      );

      final emailInput = find.byType(TextFormField).first;
      final passwordInput = find.byType(TextFormField).last;
      final loginButton = find.byType(ElevatedButton);

      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(emailInput, 'test@test.com');
      await tester.enterText(passwordInput, 'password');

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(mockAuth.signInWithEmailAndPassword(email: 'test@test.com', password: 'password')).called(1);
    });
  });
 // testWidgets('_showDialog displays message', (WidgetTester tester) async {
    // Build the widget tree
 //   await tester.pumpWidget(MaterialApp(
  //    home: Builder(builder: (BuildContext context) {
 //       return ElevatedButton(
     //     onPressed: () => const LoginPage()._showDialog('Hello, world!', context),
    //      child: const Text('Show Dialog'),
     //   );
    //  }),
   // ));

    // Tap the button to show the dialog
  //  await tester.tap(find.text('Show Dialog'));
  //  await tester.pumpAndSettle();

    // Verify that the dialog is displayed with the correct message
  //  expect(find.text('Hello, world!'), findsOneWidget);
 // });

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

class MockCollectionReference {
}

class MockDocumentSnapshot {
}



