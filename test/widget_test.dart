// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_website/Views/sign up/signUpView.dart';
import 'package:quiz_website/menu.dart';
import 'package:quiz_website/main.dart';
import 'package:quiz_website/Views/CreateQuiz/imageBased.dart';

import 'package:quiz_website/selectAQuiz.dart';

import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:quiz_website/Views/Forgot%20Password/forgotpassword.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateShortAns.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateMCQ.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockFirebase extends Mock implements Firebase {}

class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => '1234';
}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => [
    MockQueryDocumentSnapshot(),
  ];
}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  Map<String, dynamic> data() => {
    'email': 'test@test.com',
    'password': 'password',
  };
}

class MockFirebaseAuthFunctions {
  static Future<User?> signInWithEmailAndPassword({required String email, required String password, required FirebaseAuth auth}) async {
    // Check if email and password are valid
    if (email.isNotEmpty && password.isNotEmpty) {
      // Create a mock FirebaseUser
      final user = MockFirebaseUser();

      // Return the mock FirebaseUser
      return user;
    } else {
      // Throw an exception if email or password are empty
      throw FirebaseAuthException(code: 'invalid-email-and-password');
    }
  }
}


void main() {
  testWidgets('Test welcome page loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('INNOVATECH\nQUIZ PLATFORM'), findsOneWidget);
    expect(find.text('1'), findsNothing);

  });

  testWidgets('Login button on welcome page navigates to login page', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MyApp());

    // Find the login button
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // Tap the login button
    await tester.tap(loginButton);

    // Rebuild the widget tree with the new page
    await tester.pumpAndSettle();

    // Check that the login page is loaded
    expect(find.byType(LoginPage), findsOneWidget);
  });
  testWidgets('Signup button on welcome page navigates to sign up page', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MyApp());

    // Find the login button
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');

    // Tap the login button
    await tester.tap(signUpButton);

    // Rebuild the widget tree with the new page
    await tester.pumpAndSettle();

    // Check that the login page is loaded
    expect(find.byType(Signup), findsOneWidget);
  });

  testWidgets('Signup button on login page navigates to sign up page', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );
    // Find the sign up button
    final signUpButton = find.widgetWithText(TextButton, 'Sign up');

    // Tap the sign up button
    await tester.tap(signUpButton);

    // Rebuild the widget tree with the new page
    await tester.pumpAndSettle();

    // Check that the login page is loaded
    expect(find.byType(Signup), findsOneWidget);
  });

  testWidgets('login button on sign up page navigates to login page', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      const MaterialApp(
        home: Signup(),
      ),
    );

    await tester.dragUntilVisible(
      find.byType(TextButton),
      find.widgetWithText(TextButton, 'Login'),
      const Offset(0, -100),
    );

    await tester.tap(find.widgetWithText(TextButton, 'Login'));

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });


  testWidgets('Test sign out button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuPage(testFlag: true,),
      ),
    );

    final signOutButton = find.widgetWithText(TextButton, 'Sign out');

    // Tap sign out button and verify navigation
    await tester.tap(signOutButton);
    await tester.pumpAndSettle();
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('Goes to create a quiz page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuPage(testFlag: true,),
      ),
    );

    final createQuizButton = find.text('Create a Quiz');
    expect(createQuizButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(createQuizButton);
    await tester.pumpAndSettle();
    expect(find.byType(CreateQuizPage), findsOneWidget);
  });

  testWidgets('Forgot password button on login page navigates to forgot password page', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );
    // Find the sign up button
    final forgotButton = find.widgetWithText(TextButton, 'Forgot Password?');

    // Tap the sign up button
    await tester.tap(forgotButton);

    // Rebuild the widget tree with the new page
    await tester.pumpAndSettle();

    // Check that the login page is loaded
    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });

  testWidgets('cant proceed from create a quiz with no input', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateQuizPage(),
      ),
    );

    await tester.dragUntilVisible(
      find.byType(ElevatedButton),
      find.widgetWithText(ElevatedButton, 'Next'),
      const Offset(0, -100),
    );
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Enter quiz description"), findsOneWidget);
  });




  testWidgets('create a short answer quiz requires input of both question and answer', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShortAnswerQuestionPage(),
      ),
    );

    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Enter a question"), findsOneWidget);
    expect(find.text("Enter an answer"), findsOneWidget);
  });

  testWidgets('Valid question and answer in short questions goes to next question', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShortAnswerQuestionPage(),
      ),
    );
    expect(find.text("Question 1"), findsOneWidget);
    final QuestionField = find.widgetWithText(TextFormField, 'Enter your question here');
    final AnswerField = find.widgetWithText(TextFormField, 'Enter the correct answer here');
    expect(QuestionField, findsOneWidget);
    expect(AnswerField, findsOneWidget);

    await tester.enterText(QuestionField, 'What is your name');
    await tester.enterText(AnswerField, 'Bob');

    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 2"), findsOneWidget);

  });

  testWidgets('User can go back and edit previous questions in Short answer quizes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShortAnswerQuestionPage(),
      ),
    );
    expect(find.text("Question 1"), findsOneWidget);
    final QuestionField = find.widgetWithText(TextFormField, 'Enter your question here');
    final AnswerField = find.widgetWithText(TextFormField, 'Enter the correct answer here');
    expect(QuestionField, findsOneWidget);
    expect(AnswerField, findsOneWidget);

    await tester.enterText(QuestionField, 'What is your name');
    await tester.enterText(AnswerField, 'Bob');

    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 2"), findsOneWidget);
    expect(find.text("Enter your question here"), findsOneWidget);
    final prevButton = find.text('Previous Question');
    expect(prevButton, findsOneWidget);
    expect(nextButton, findsOneWidget);
    await tester.tap(prevButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 1"), findsOneWidget);
    expect(find.text("What is your name"), findsOneWidget);

  });


  testWidgets('create a mcq requires input of both question and 4 answers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: mCQ_Question_Page(),
      ),
    );

    await tester.dragUntilVisible(
      find.byType(ElevatedButton),
      find.widgetWithText(ElevatedButton, 'Next'),
      const Offset(0, -100),
    );
    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Enter a question"), findsOneWidget);
    expect(find.text("Enter an answer"), findsNWidgets(4));
  });

  testWidgets('create a mcq goes to next question when input valid', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: mCQ_Question_Page(),
      ),
    );
    expect(find.text("Question 1"), findsOneWidget);
    final QuestionField = find.widgetWithText(TextFormField, 'Enter your question here');
    final AnswerField1 = find.widgetWithText(TextFormField, 'Option 1 (correct answer)');
    final AnswerField2 = find.widgetWithText(TextFormField, 'Option 2');
    final AnswerField3 = find.widgetWithText(TextFormField, 'Option 3');
    final AnswerField4 = find.widgetWithText(TextFormField, 'Option 4');
    expect(QuestionField, findsOneWidget);
    expect(AnswerField1, findsOneWidget);
    expect(AnswerField2, findsOneWidget);
    expect(AnswerField3, findsOneWidget);
    expect(AnswerField4, findsOneWidget);


    await tester.enterText(QuestionField, 'What is your name');
    await tester.enterText(AnswerField1, 'Bob1');
    await tester.enterText(AnswerField2, 'Bob2');
    await tester.enterText(AnswerField3, 'Bob3');
    await tester.enterText(AnswerField4, 'Bob4');

    await tester.dragUntilVisible(
      find.byType(ElevatedButton),
      find.widgetWithText(ElevatedButton, 'Next'),
      const Offset(0, -100),
    );
    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 2"), findsOneWidget);

  });

  testWidgets('User can go back and edit previous questions in MCQ', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: mCQ_Question_Page(),
      ),
    );
    expect(find.text("Question 1"), findsOneWidget);
    final QuestionField = find.widgetWithText(TextFormField, 'Enter your question here');
    final AnswerField1 = find.widgetWithText(TextFormField, 'Option 1 (correct answer)');
    final AnswerField2 = find.widgetWithText(TextFormField, 'Option 2');
    final AnswerField3 = find.widgetWithText(TextFormField, 'Option 3');
    final AnswerField4 = find.widgetWithText(TextFormField, 'Option 4');
    expect(QuestionField, findsOneWidget);
    expect(AnswerField1, findsOneWidget);
    expect(AnswerField2, findsOneWidget);
    expect(AnswerField3, findsOneWidget);
    expect(AnswerField4, findsOneWidget);


    await tester.enterText(QuestionField, 'What is your name');
    await tester.enterText(AnswerField1, 'Bob1');
    await tester.enterText(AnswerField2, 'Bob2');
    await tester.enterText(AnswerField3, 'Bob3');
    await tester.enterText(AnswerField4, 'Bob4');

    await tester.dragUntilVisible(
      find.byType(ElevatedButton),
      find.widgetWithText(ElevatedButton, 'Next'),
      const Offset(0, -100),
    );
    final nextButton = find.text('Next Question');
    expect(nextButton, findsOneWidget);

    // Tap create quiz button and verify navigation
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 2"), findsOneWidget);
    expect(find.text('Option 1 (correct answer)'), findsOneWidget);
    expect(find.text('Option 2'), findsOneWidget);
    expect(find.text('Option 3'), findsOneWidget);
    expect(find.text('Option 4'), findsOneWidget);


    final prevButton = find.text('Previous Question');
    expect(prevButton, findsOneWidget);
    await tester.tap(prevButton);
    await tester.pumpAndSettle();
    expect(find.text("Question 1"), findsOneWidget);
    expect(find.text("What is your name"), findsOneWidget);
    expect(find.text("Bob1"), findsOneWidget);
    expect(find.text("Bob2"), findsOneWidget);
    expect(find.text("Bob3"), findsOneWidget);
    expect(find.text("Bob4"), findsOneWidget);

  });
  group('Form Validation Tests', ()
  {
    late SignupState
    instance;

    setUp(() {
      instance = SignupState();
    });

    test('Empty username should return an error', () {
      final result = instance.validateUsername('');
      expect(result, 'Username must be longer than 3 characters');
    });

    test('Short username should return an error', () {
      final result = instance.validateUsername('ab');
      expect(result, 'Username must be longer than 3 characters');
    });

    test('Valid username should return null', () {
      final result = instance.validateUsername('john_doe');
      expect(result, null);
    });

    test('Empty name should return an error', () {
      final result = instance.validateName('');
      expect(result, 'Username must be at least 2 characters');
    });

    test('Short name should return an error', () {
      final result = instance.validateName('A');
      expect(result, 'Username must be at least 2 characters');
    });

    test('Valid name should return null', () {
      final result = instance.validateName('John Doe');
      expect(result, null);
    });

    test('Empty password should return an error', () {
      final result = instance.validatePassword('');
      expect(result, 'Must be longer than 5 characters');
    });

    test('Short password should return an error', () {
      final result = instance.validatePassword('1234');
      expect(result, 'Must be longer than 5 characters');
    });

    test('Weak password should return an error', () {
      final result = instance.validatePassword('abcd1234');
      expect(
          result, 'Must contain mix of lowercase, uppercase, digits, symbols.');
    });

    testWidgets('valid email required to reset password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );


      final resetButton = find.widgetWithText(ElevatedButton, 'Reset Password');

      // Tap create quiz button and verify navigation
      await tester.tap(resetButton);
      await tester.pumpAndSettle();
      expect(find.text("Enter Valid Email"), findsOneWidget);

    });

    testWidgets('select a quiz to answer button goes to select quiz page', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuPage(testFlag: true,),
        ),
      );


      final doQuizButton = find.widgetWithText(ElevatedButton, 'Answer a Quiz');

      // Tap create quiz button and verify navigation
      await tester.tap(doQuizButton);
      await tester.pumpAndSettle();
      expect(find.byType(SelectPage), findsOneWidget);

    });
    test('Strong password should return null', () {
      final result = instance.validatePassword('Abcd1234@');
      expect(result, null);
    });

    test('Empty confirm password should return an error', () {
      final result = instance.validateConfirm('');
      expect(result, null);
    });


    test('Invalid email should return an error', () {
      final result = instance.validateEmail('invalid.email.com');
      expect(result, 'Enter Valid Email');
    });

    test('Valid email should return null', () {
      final result = instance.validateEmail('valid.email@example.com');
      expect(result, null);
    });
  });

  // testWidgets('create image quiz loads correctly', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: imageBased(numQuest: 3),
  //     ),
  //   );
  //
  //   expect(find.text("Image-Based Quiz"), findsOneWidget);
  //   expect(find.byType(TextFormField), findsOneWidget);
  //   await tester.dragUntilVisible(
  //     find.byType(ElevatedButton),
  //     find.widgetWithText(ElevatedButton, 'Next'),
  //     const Offset(0, -100),
  //   );
  //
  //   expect(find.byType(FloatingActionButton), findsNWidgets(6));
  // });


}










