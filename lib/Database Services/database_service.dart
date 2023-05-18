import '../Views/CreateQuiz/CreateMCQ.dart';

abstract class DatabaseService {
  Future<String?> getUser();
  Future<void> addSignupToFirestore(
      String email, password, username, name, DateTime givendate);
  Future<void> addUpdatedScore(
      String quizSelected, int _currentIndex, questionlength);
  Future<List<Map<String, dynamic>>> getMCQQuestionsAnswers(
      String x, List<String> _questions);
  Future<List<Map<String, dynamic>>> getShortQuestionsAnswers(
      String x, List<String> _questions, bool isShuffled);
  Future<List<Map<String, dynamic>>> getMAQQuestionsAnswers(
      String x, List<String> _questions);
  Future<void> addDataToCreateaQuizFirestore(
      String getQuizName, getQuizType, getQuizDescription, getQuizCategory, String imageURL);
  Future<void> addNumberOfQuestions(
      String quizID, int numQuestions, bool isTimed, int time);
  Future<String> _getQuizID();
  Future<void> addImagesToFirestore(String question, Image1url, image2url,
      image3url, image4url, image5url, image6url, int index);
  Future<void> resetPassword(String email);
  Future<List<Map<String, dynamic>>> getQuizInformation(String x);
  Future<String> getQuizID();
  Future<void> updateQuizzesStattus();
  Future<void> PublishDataToFirestore(
      int index, int Quiztype, List<String> questions, List<String> answers);
}
