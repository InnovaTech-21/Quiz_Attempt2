import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShortQuizAnswer extends StatefulWidget {
  ShortQuizAnswer({Key? key, required this.quizID}) : super(key: key);
  String quizID;
  @override
  ShortQuizAnswerState createState() => ShortQuizAnswerState();
}

class ShortQuizAnswerState extends State<ShortQuizAnswer> {
  int _currentIndex = 0;
  late String quizSelected;

  @override
  void initState() {
    super.initState();
    quizSelected = widget.quizID;
  }
  List<TextEditingController> answerControllers = [];
  bool isSubmited=false;
  bool isCorrect=false;
  ///list of questions from database
  final List<String> _questions = []; // load in the questions

  ///List of correct answers
  final List <String> _correctAns=[]; // load in the answers
  ///list of user answers
  List<String> _userAnswers = [];

  ///gets the users score at when they submit
  String getScore(){
    int count=0;
    for(int i=0;i<_questions.length;i++){
      if(_userAnswers[i].toLowerCase()==_correctAns[i].toLowerCase()){
        count++;
      }
    }
    String score='$count/${_questions.length}';
    return score;
  }

  ///saves the users answers to a list as they answer the questions
  void _submitAnswer() {
    setState(() {
      _userAnswers[_currentIndex] = answerControllers[_currentIndex].text;
      _showDialog("Your Score: ${getScore()}");
      isSubmited=true;
    });
  }


  ///allows user to go back to a previous question and reanswer it
  void _goToPreviousQuestion() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        answerControllers[_currentIndex].text = _userAnswers[_currentIndex];
      }
    });

    answerControllers[_currentIndex].addListener(() {
      _userAnswers[_currentIndex] = answerControllers[_currentIndex].text;
    });
  }

  ///loads in the next question and clears previous answer
  void _goToNextQuestion() {
    setState(() {
      _userAnswers[_currentIndex] =answerControllers[_currentIndex].text;
      _currentIndex++;
      answerControllers[_currentIndex].text = _userAnswers[_currentIndex];
    });
  }

  ///will be the quiz id from quiz selected in previous page


  ///loads the quiz questions and answers for use throughout page
  Future<void> getQuestionsAnswers(String x) async {

    if (_questions.isEmpty) {

      CollectionReference users = FirebaseFirestore.instance.collection(
          'Questions');

      //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
      QuerySnapshot questionsSnapshot = await users
          .where('QuizID', isEqualTo: x)
          .orderBy('Question_type', descending: true)
          .get();


      List<Map<String, dynamic>> questionsAnswersList = [];

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

      for (var i = 0; i < questionsAnswersList.length; i++) {
        _questions.add(questionsAnswersList[i]["Question"]);
        _correctAns.add(questionsAnswersList[i]["Answers"]);
      }
      _userAnswers=List.filled(questionsAnswersList.length, '');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answer Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: getQuestionsAnswers(quizSelected),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            for (int i = 0; i < _questions.length; i++) {
              answerControllers.add(TextEditingController());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///question count at top of page
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ///loads in current question
                Text(
                  _questions[_currentIndex],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ///text box for user answer
                TextFormField(
                  controller: answerControllers[_currentIndex],
                  enabled: !isSubmited,
                  decoration: InputDecoration(
                    hintText: 'Type your answer here',
                    border: OutlineInputBorder(),
                  ),

                ),
                ///shows correct answers after quiz submitted
                if (isSubmited )
                  Text(
                    'Correct answer: ${_correctAns[_currentIndex]}',
                    style: TextStyle(
                      color: _userAnswers[_currentIndex].toLowerCase() == _correctAns[_currentIndex].toLowerCase()
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///button for previous question only when not first question
                    if (_currentIndex > 0)
                      ElevatedButton(
                        onPressed: _goToPreviousQuestion,
                        child: Text('Previous'),
                      ),
                    ///button for next question. changes to submit on last question
                    ElevatedButton(
                      onPressed: isSubmited && _currentIndex == _questions.length - 1 ? () => Navigator.of(context).pop() : _currentIndex == _questions.length - 1
                          ? _submitAnswer
                          : _goToNextQuestion,
                      child: Text(
                        isSubmited && _currentIndex == _questions.length - 1 ? 'Close' :_currentIndex == _questions.length - 1 ? 'Submit' : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Future<void> _showDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}