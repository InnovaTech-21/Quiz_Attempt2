import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:quiz_website/Database%20Services/database.dart';

class MockDataService extends Mock implements DatabaseService {
  @override
  Future<String?> getUser() async {
    final firestore = FakeFirebaseFirestore();
    late String? username = "Shak";
    late String? testCategories = "";
    await firestore
        .collection('Users')
        .doc('97bpFHEbhuVYzi85avKcMUA92MB3')
        .set({
      'user_name': "Shak",
    });
    // Get doc from Category collection
    DocumentSnapshot docSnapshot = await firestore
        .collection('Users')
        .doc('97bpFHEbhuVYzi85avKcMUA92MB3')
        .get();

    // Get data from doc and return as array
    testCategories = docSnapshot['user_name'];

    return username;
  }

  @override
  Future<String?> getUserID() async {
    final firestore = FakeFirebaseFirestore();
    late String? userID = "9eMkcVepH2tE66t3fICp";
    late String? testCategories = "";
    await firestore.collection('Quizzes').doc('9eMkcVepH2tE66t3fICp').set({
      'Quiz_ID': "9eMkcVepH2tE66t3fICp",
    });
    // Get doc from Category collection
    DocumentSnapshot docSnapshot =
        await firestore.collection('Quizzes').doc('9eMkcVepH2tE66t3fICp').get();

    // Get data from doc and return as array
    testCategories = docSnapshot['Quiz_ID'];

    return userID;
  }

  @override
  Future<Map<String, dynamic>> addUpdatedScore(
      String quizSelected, int _currentIndex, questionlength) async {
    final firestore = FakeFirebaseFirestore();
    CollectionReference users = firestore.collection('QuizResults');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      "Quiz_ID": quizSelected,
      "CorrectAns": _currentIndex,
      "TotalAns": questionlength,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "UserID": await getUser(),
    };

    await users.doc(docRef.id).set(userData);
    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> userData1 = {
      "Quiz_ID": docSnapshot["Quiz_ID"],
      "CorrectAns": docSnapshot["CorrectAns"],
      "TotalAns": docSnapshot["TotalAns"],
      "Date_Created": docSnapshot["Date_Created"],
      "UserID": docSnapshot["UserID"],
    };
    return userData1;
  }

  @override
  Future<String?> updateQuizzesStattus() async {
    final firestore = FakeFirebaseFirestore();
    late String? testCategories = "";
    late String? x = "Finished";

    await firestore.collection('Quizzes').doc('9eMkcVepH2tE66t3fICp').set({
      'Status': "Finished",
    });
// Update the document
    await firestore.collection('Quizzes').doc('9eMkcVepH2tE66t3fICp').update({
      'Status': 'Finished',
    });
    DocumentSnapshot docSnapshot =
        await firestore.collection('Quizzes').doc('9eMkcVepH2tE66t3fICp').get();

    testCategories = docSnapshot['Status'];
    return x;
  }

  @override
  Future<Map<String, dynamic>> addSignupToFirestore(
      String email, password, username, name, DateTime Dateofbirth) async {
    final firestore = FakeFirebaseFirestore();

    ///user created successfully, now add data to Firestore
    CollectionReference users = firestore.collection('Users');

    Map<String, dynamic> userData = {
      // 'date_of_birth': Dateofbirth,
      'levels': 0,
      'total_score': 0,
      'user_email': email,
      'user_name': username,
      'user_username': name,
    };

    await users.doc('63Y4rSy2GGRUBHrqTtVkgnyyG8o2').set(userData);
    DocumentSnapshot docSnapshot = await firestore
        .collection('Quizzes')
        .doc('63Y4rSy2GGRUBHrqTtVkgnyyG8o2')
        .get();
    Map<String, dynamic> userData1 = {
      // 'date_of_birth': Dateofbirth,
      'levels': 0,
      'total_score': 0,
      'user_email': email,
      'user_name': username,
      'user_username': name,
    };
    // G
    return userData;
  }

  @override
  Future<Map<String, dynamic>> getQuizInformation1(String x) async {
    final firestore = FakeFirebaseFirestore();
    CollectionReference users = firestore.collection('Quizzes');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> questionAnswerMap1 = {
      "Quiz_ID": '2EQTWRjpKEybsApneeBM',
      "QuizName": 'ABC',
      "Quiz_Description": '123',
      "Quiz_Category": "Anime",
      "Quiz_Type": 'Short Answer',
      "QuizTimed": false,
      "TimerTime": 5,
      "Number_of_questions": '5',
      "Status": "Finished",
      "Date_Created": Timestamp.fromDate(DateTime.now())
    };
    await users.doc(docRef.id).set(questionAnswerMap1);
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
    // Map<String, dynamic> questionsAnswersList = [];

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Quiz_ID": quizDoc["Quiz_ID"],
          "QuizName": quizDoc["QuizName"],
          "Quiz_Description": quizDoc["Quiz_Description"],
          "Quiz_Category": quizDoc["Quiz_Category"],
          "Quiz_Type": quizDoc["Quiz_Type"],
          "QuizTimed": quizDoc["QuizTimed"],
          "TimerTime": quizDoc["TimerTime"],
          "Number_of_questions": quizDoc["Number_of_questions"].toString(),
        };
      }
    }
    return questionAnswerMap1;

    // _userAnswers=List.filled(questionsAnswersList.length, '');
  }

  @override
  Future<String?> getQuizName1(String quizId) async {
    final firestore = FakeFirebaseFirestore();
    late String? QuizName = "abc";
    late String? testCategories = "";
    await firestore
        .collection('Quizzes')
        .doc('97bpFHEbhuVYzi85avKcMUA92MB3')
        .set({
      'QuizName': "abc",
    });
    // Get doc from Category collection
    DocumentSnapshot docSnapshot = await firestore
        .collection('Quizzes')
        .doc('97bpFHEbhuVYzi85avKcMUA92MB3')
        .get();

    // Get data from doc and return as array
    testCategories = docSnapshot['QuizName'];

    return QuizName;
  }

  @override
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final firestore = FakeFirebaseFirestore();
    CollectionReference users = firestore.collection('Users');

    Map<String, dynamic> questionAnswerMap1 = {
      "total_score": 20,
      "ranking": 2,
    };
    await users.doc(userId).set(questionAnswerMap1);

    DocumentSnapshot docSnapshot = await firestore
        .collection('Users')
        .doc(userId)
        .get();

    int total_score = docSnapshot["total_score"];
    int ranking = docSnapshot['ranking'];

    return {
      'total_score': total_score,
      'ranking': ranking,
    };
  }

  @override
  Future<int> addOrUpdateQuizRating(String quizId, int rating) async {
    final firestore = FakeFirebaseFirestore();
    CollectionReference quizR = firestore.collection('QuizRatings');
    late int testCategories = 0;

    Map<String, dynamic> questionAnswerMap1 = {
      "QuizID": quizId,
      "Ratings": rating,
    };

    await quizR.doc(quizId).set(questionAnswerMap1);

    DocumentSnapshot docSnapshot =
        await firestore.collection('QuizRatings').doc(quizId).get();

    testCategories = docSnapshot['Ratings'];

    return testCategories;

  }

  @override
  Future<int> updateLevels(String userId, int increaseBy) async {
     final firestore = FakeFirebaseFirestore();
    CollectionReference users = firestore.collection('Users');

    await users.doc(userId).set({
      'levels': 2,
      });

    await users.doc(userId).update({
      'levels': 2 + increaseBy,
    });  

    DocumentSnapshot docSnapshot = await firestore
        .collection('Users')
        .doc(userId)
        .get();

    int levels = docSnapshot["levels"];

    return levels;
  }

  @override
  Future<int> updateTotalScore(String userId, int newTotalScore) async {
    final firestore = FakeFirebaseFirestore();
    CollectionReference users = firestore.collection('Users');

    await users.doc(userId).set({
      'total_score': 5,
      });

    await users.doc(userId).update({
      'total_score': newTotalScore,
    });

    DocumentSnapshot docSnapshot = await firestore
        .collection('Users')
        .doc(userId)
        .get();

    int updatedScore = docSnapshot["total_score"];

    return updatedScore;
  }


}
