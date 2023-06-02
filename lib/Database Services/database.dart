import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static DatabaseService? _instance;
  factory DatabaseService() {
    if (_instance == null) {
      _instance = DatabaseService._internal();
    }
    return _instance!;
  }

  DatabaseService._internal();
  String userID = '';

  Future<void> setUserID() async {
    String? result = await getUser();
    if (result != null) {
      userID = result;
    }
  }

  ///updatefinished quizzes
  Future<void> updateQuizzesStattus() async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Quizzes').doc(await getQuizID());

// Update the document
    docRef.update({
      'Status': 'Finished',
    });
  }

  Future<void> PublishDataToFirestore(int index, int Quiztype,
      List<String> questions, List<String> answers) async {
    ///Create quizzes created successfully, now add data to Firestore

    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    if (Quiztype == 0) {
      Map<String, dynamic> userData = {
        'Question': questions[index].toString(),
        'Answers': answers[index].toString(),
        'QuizID': await getQuizID(),
        'Question_type': "Short Answer",
        'QuestionNo': index,
      };
      await users.doc(docRef.id).set(userData);
    } else if (Quiztype == 1) {
      List<String> ans = answers[index].split('^');
      String correctAns = ans[0];
      String rand1 = ans[1];
      String rand2 = ans[2];
      String rand3 = ans[3];

      Map<String, dynamic> userData = {
        'Question': questions[index].toString(),
        'Answers': correctAns,
        'Option1': rand1,
        'Option2': rand2,
        'Option3': rand3,
        'QuizID': await getQuizID(),
        'Question_type': "MCQ",
        'QuestionNo': index,
      };

      await users.doc(docRef.id).set(userData);
    }
  }

  ///GetQuizID
  Future<String> getQuizID() async {
    // get number of questions from databse
    String quizID = "";
    final CollectionReference quizzesCollection =
        FirebaseFirestore.instance.collection('Quizzes');

    String? username = userID;
    QuerySnapshot questionsSnapshot = await quizzesCollection
        .where('Username', isEqualTo: username)
        .orderBy('Date_Created', descending: true)
        .limit(1)
        .get();

    if (questionsSnapshot.docs.isNotEmpty) {
      DocumentSnapshot mostRecentQuestion = questionsSnapshot.docs.first;
      quizID = mostRecentQuestion['Quiz_ID'].toString();
    }

    return quizID;
  }

  /// Get User Name
  Future<String?> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String? nameuser = '';
    if (user != null) {
      String uID = user.uid;
      try {
        CollectionReference users =
            FirebaseFirestore.instance.collection('Users');
        final snapshot = await users.doc(uID).get();
        final data = snapshot.data() as Map<String, dynamic>;
        // print (data['user_name']);
        return data['user_name'];
      } catch (e) {
        return 'Error fetching user';
      }
    }
  }

  //signup
  Future<void> addSignupToFirestore(
      String email, password, username, name, DateTime Dateofbirth) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    ///create a user with email and password
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ///user created successfully, now add data to Firestore
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Map<String, dynamic> userData = {
      'date_of_birth': Dateofbirth,
      'levels': 0,
      'total_score': 0,
      'user_email': email,
      'user_name': username,
      'user_username': name,
    };

    await users.doc(userCredential.user!.uid).set(userData);
  }

  Future<void> addOrUpdateQuizRating(String quizId, int rating) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('QuizRatings');

    try {
      final QuerySnapshot querySnapshot =
          await collectionRef.where('QuizID', isEqualTo: quizId).get();

      if (querySnapshot.docs.isEmpty) {
        // Create a new document if it doesn't exist
        await collectionRef.add({
          'QuizID': quizId,
          'Ratings': [rating],
        });
      } else {
        // Update the existing document by appending the new rating
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final List<int> existingRatings =
            List<int>.from(documentSnapshot['Ratings']);
        existingRatings.add(rating);
        await collectionRef.doc(documentSnapshot.id).update({
          'Ratings': existingRatings,
        });
      }

      print('Quiz rating added/updated successfully');
    } catch (error) {
      print('Error adding/updating quiz rating: $error');
    }
  }

  Future<void> updateTotalScore(String userId, int newTotalScore) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');

    try {
      final QuerySnapshot querySnapshot =
          await collectionRef.where('user_name', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await collectionRef.doc(documentSnapshot.id).update({
          'total_score': newTotalScore,
        });

        print('User total score updated successfully');
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error updating user total score: $error');
    }
  }

  Future<void> updateLevels(String userId, int increaseBy) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');

    try {
      final QuerySnapshot querySnapshot =
          await collectionRef.where('user_name', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final int currentLevel = documentSnapshot['levels'] ?? 0;
        final int newLevel = currentLevel + increaseBy;

        await collectionRef.doc(documentSnapshot.id).update({
          'levels': newLevel,
        });

        print('User level updated successfully');
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error updating user level: $error');
    }
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');

    try {
      final QuerySnapshot querySnapshot =
          await collectionRef.where('UserId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          final int totalScore = userData['total_score'];
          final int ranking = userData['ranking'];

          return {
            'total_score': totalScore,
            'ranking': ranking,
          };
        }
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error retrieving user stats: $error');
    }

    return {}; // Return an empty map if user not found or error occurs
  }

  ///add updated score to database
  Future<void> addUpdatedScore(
      String quizSelected, int _currentIndex, questionlength) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('QuizResults');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      "Quiz_ID": quizSelected,
      "CorrectAns": _currentIndex,
      "TotalAns": questionlength,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "UserID": userID,
    };

    await users.doc(docRef.id).set(userData);
  }

  ///get Multiple Choice questions
  Future<List<Map<String, dynamic>>> getMCQQuestionsAnswers(String x) async {
    List<Map<String, dynamic>> questionsAnswersList = [];

    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    QuerySnapshot questionsSnapshot = await users
        .where('QuizID', isEqualTo: x)
        .orderBy('QuestionNo', descending: false)
        .get();

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Question": quizDoc["Question"],
          "Answers": quizDoc["Answers"],
          "Option1": quizDoc["Option1"],
          "Option2": quizDoc["Option2"],
          "Option3": quizDoc["Option3"],
        };
        questionsAnswersList.add(questionAnswerMap);
      }
    }
    return questionsAnswersList;
  }

  Future<List<Map<String, dynamic>>> getShortQuestionsAnswers(String x) async {
    List<Map<String, dynamic>> questionsAnswersList = [];

    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    QuerySnapshot questionsSnapshot = await users
        .where('QuizID', isEqualTo: x)
        .orderBy('QuestionNo', descending: false)
        .get();

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Question": quizDoc["Question"],
          "Answers": quizDoc["Answers"],
        };
        questionsAnswersList.add(questionAnswerMap);
      }
    }
    return questionsAnswersList;
  }

  ///get Multiple Answer Question
  Future<List<Map<String, dynamic>>> getMAQQuestionsAnswers(String x) async {
    List<Map<String, dynamic>> questionsAnswersList = [];

    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    QuerySnapshot questionsSnapshot = await users
        .where('QuizID', isEqualTo: x)
        .orderBy('QuestionNo', descending: false)
        .get();

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Question": quizDoc["Question"],
          "Answers": quizDoc["Answers"],
        };
        questionsAnswersList.add(questionAnswerMap);
      }
    }
    return questionsAnswersList;
  }

  ///add data to create a quiz
  Future<void> addDataToCreateaQuizFirestore(String getQuizName, getQuizType,
      getQuizDescription, getQuizCategory, String imageURL) async {
    User? user = FirebaseAuth.instance.currentUser;
    print(getQuizType);

    ///Create quizzes created successfully, now add data to Firestore
    CollectionReference users =
        FirebaseFirestore.instance.collection('Quizzes');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Status': 'Pending',
      'QuizName': getQuizName,
      'Quiz_Type': getQuizType,
      'Quiz_Description': getQuizDescription,
      'Quiz_Category': getQuizCategory,
      'Number_of_questions': 0,
      'Username': userID,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "Quiz_ID": docRef.id.toString(),
      "Quiz_URL": imageURL,
    };

    await users.doc(docRef.id).set(userData);
  }

  /// Addnumberofquestion to quizzes
  Future<void> addNumberOfQuestions(String quizID, int numQuestions,
      bool isTimed, int time, String id) async {
    CollectionReference quizzesCollection =
        FirebaseFirestore.instance.collection('Quizzes');

    // Get the quiz document with the specified ID
    QuerySnapshot quizQuery =
        await quizzesCollection.where('Quiz_ID', isEqualTo: quizID).get();

    if (quizQuery.docs.length == 1) {
      // Update the number of questions for the quiz
      DocumentReference quizDocRef = quizQuery.docs[0].reference;
      await quizDocRef.update({
        'Number_of_questions': numQuestions,
        'QuizTimed': isTimed,
        'TimerTime': time,
        'prerequisite_quizzes': id
      });

      print('Successfully updated the number of questions for QuizID $quizID');
    } else {
      print(
          'Error: Found ${quizQuery.docs.length} quizzes with QuizID $quizID');
    }
  }
 
  ///reset paseword code
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getQuizInformation(String x) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Quizzes');

    String y = 'Finished';
    QuerySnapshot questionsSnapshot;
    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    if ((x != "All")) {
      questionsSnapshot = await users
          .where('Quiz_Category', isEqualTo: x)
          .where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true)
          .get();
    } else {
      questionsSnapshot = await users
          .where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true)
          .get();
    }

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    // String x = "2";
    List<Map<String, dynamic>> questionsAnswersList = [];

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Quiz_ID": quizDoc["Quiz_ID"],
          "prerequisite_quizzes": quizDoc["prerequisite_quizzes"],
          "Username": quizDoc["Username"],
          "QuizName": quizDoc["QuizName"],
          "Quiz_Description": quizDoc["Quiz_Description"],
          "Quiz_Category": quizDoc["Quiz_Category"],
          "Quiz_Type": quizDoc["Quiz_Type"],
          "QuizTimed": quizDoc["QuizTimed"],
          "TimerTime": quizDoc["TimerTime"],
          "Number_of_questions": quizDoc["Number_of_questions"].toString(),
        };
        questionsAnswersList.add(questionAnswerMap);
      }
    }
    return questionsAnswersList;

    // _userAnswers=List.filled(questionsAnswersList.length, '');
  }

  Future<String> getQuizName(String quizId) async {
    final quizDoc = await FirebaseFirestore.instance
        .collection('Quizzes')
        .doc(quizId)
        .get();

    if (quizDoc.exists) {
      final quizName = quizDoc.data()?['QuizName'];
      return quizName;
    } else {
      throw Exception('Quiz not found');
    }
  }
}
