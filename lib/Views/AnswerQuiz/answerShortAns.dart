import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShortQuizAnswer extends StatefulWidget {
  ShortQuizAnswer({Key? key, required this.quizID, required this.bTimed, required this.iTime}) : super(key: key);
  String quizID;
  bool bTimed;
  int iTime;
  @override
  ShortQuizAnswerState createState() => ShortQuizAnswerState();
}

class ShortQuizAnswerState extends State<ShortQuizAnswer> {
  ///vars for doing and checking quiz
  int _currentIndex = 0;
  late String quizSelected;
  List<TextEditingController> answerControllers = [];
  bool isSubmited=false;
  bool isCorrect=false;
  ///vars for timed quizes
  ///needed from database
  late bool isTimed;
  late int time;

  late ValueNotifier<int> timeRemaining=ValueNotifier<int>(0);
  late Timer timer=Timer(Duration.zero, () {});

/// gets the quiz id and sets up the timer when page loads
  @override
  void initState() {
    super.initState();
    quizSelected = widget.quizID;
    isTimed=widget.bTimed;
    time=widget.iTime;
    ///sets up timer if needed
    if(isTimed) {
    timeRemaining = ValueNotifier<int>(time);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining.value == 0) {
        timer.cancel();
        _submitAnswer();
      } else {
        timeRemaining.value--;
      }
    });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }



  ///list of questions from database
  final List<String> _questions = []; // load in the questions

  ///List of correct answers
  final List <String> _correctAns=[]; // load in the answers
  ///list of user answers
  List<String> _userAnswers = [];
  int count=0;
  ///gets the users score at when they submit
  String getScore(){

    for(int i=0;i<_questions.length;i++){
      if(_userAnswers[i].toLowerCase()==_correctAns[i].toLowerCase()){
        count++;
      }
    }
    String score='$count/${_questions.length}';
    return score;
  }
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
  void addtoCompletedQuiz() async {
    CollectionReference users =
    FirebaseFirestore.instance.collection('QuizResults');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      "Quiz_ID": quizSelected,
      "CorrectAns":count,
      "TotalAns": _questions.length,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "UserID": await getUser(),

    };

    await users.doc(docRef.id).set(userData);
  }

  ///saves the users answers to a list as they answer the questions
  void _submitAnswer() async {

    setState(() {
      _userAnswers[_currentIndex] = answerControllers[_currentIndex].text;
      _showDialog("Your Score: ${getScore()}");
      addtoCompletedQuiz();
      print(1);
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
          .orderBy('QuestionNo', descending: false)
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


  ///sets up the timer widget
  Widget _buildTimerWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: timeRemaining,
      builder: (BuildContext context, int value, Widget? child) {
        int minutes = (value / 60).floor();
        int seconds = value % 60;
        String formattedTime =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        return Text('Time remaining: $formattedTime');
      },
    );
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
                Row(
                  children:[
                    Text(
                      'Question ${_currentIndex + 1} of ${_questions.length}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16),
                    ///shows the timer widget if its a timed quiz
                    if(isTimed) _buildTimerWidget(),
                  ],
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