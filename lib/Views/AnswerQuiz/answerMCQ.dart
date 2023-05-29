import 'dart:async';

import 'package:flutter/material.dart';

import '../../Database Services/database.dart';

class mcqQuizAnswer extends StatefulWidget {
  mcqQuizAnswer({Key? key, required this.quizID, required this.bTimed, required this.iTime}) : super(key: key);
  String quizID;
  bool bTimed;
  int iTime;
  @override
  mcqQuizAnswerState createState() => mcqQuizAnswerState();
}

class mcqQuizAnswerState extends State<mcqQuizAnswer> {
  List<TextEditingController> answerControllers = [];
  bool isSubmited = false;
  bool isCorrect = false;
  int _currentIndex = 0;
  late String quizSelected;
  ///vars for timed quizes
  ///needed from database
  late bool isTimed;
  late int time;

  late ValueNotifier<int> timeRemaining=ValueNotifier<int>(0);
  late Timer timer=Timer(Duration.zero, () {});
  DatabaseService service = DatabaseService();

  @override
  ///sets up page to load the selected quiz
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

  ///List of mcq options
  final List<String> _correctAns = [];
  final List<String> _randoption1 = [];
  final List<String> _randoption2 = [];
  final List<String> _randoption3 = [];
  List<List> optionsShuffled = [];
  ///list of user answers
  List<String> _userAnswers = [];
  int count = 0;
  ///gets the users score at when they submit
  String getScore() {

    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _correctAns[i]) {
        count++;
      }
    }
    String score = '$count/${_questions.length}';
    return score;
  }



  ///saves the users answers to a list as they answer the questions
  void _submitAnswer() async {

    setState(()  {
      answerControllers[_currentIndex].text = _userAnswers[_currentIndex];
      try {
        _showDialog("Your Score: ${getScore()}");

      }finally {
        service.updateLevels( service.userID ,1);
        service.addUpdatedScore(widget.quizID, count, _questions.length);
        service.updateTotalScore(service.userID,count );
        isSubmited = true;
      }
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
      //_userAnswers[_currentIndex] = answerControllers[_currentIndex].text;
      _currentIndex++;
      answerControllers[_currentIndex].text = _userAnswers[_currentIndex];
    });
  }
  bool isShuffled=false;
  ///loads the quiz questions and answers for use throughout page
  Future<void> getQuestionsAnswers(String x) async {
    if (_questions.isEmpty) {
      List<Map<String, dynamic>> questionsAnswersList = await  service.getMCQQuestionsAnswers(x);
      for (var i = 0; i < questionsAnswersList.length; i++) {
        _questions.add(questionsAnswersList[i]["Question"]);
        _correctAns.add(questionsAnswersList[i]["Answers"]);
        _randoption1.add(questionsAnswersList[i]["Option1"]);
        _randoption2.add(questionsAnswersList[i]["Option2"]);
        _randoption3.add(questionsAnswersList[i]["Option3"]);
      }
      _userAnswers = List.filled(questionsAnswersList.length, '');
      //x=11
    }

    if(isShuffled==false) {
      optionsShuffled = shuffleOptions();
    }

  }



  List<List> shuffleOptions() {
    List<List> Shuffled = [];

    for (var i = 0; i < _questions.length; i++) {
      List<String> options = [];
      options.add(_correctAns[i]);
      options.add(_randoption1[i]);
      options.add(_randoption2[i]);
      options.add(_randoption3[i]);

      options.shuffle();
      Shuffled.add(options);

    }
    isShuffled=true;
    return Shuffled;
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

                RadioListTile(
                  title: Text(optionsShuffled[_currentIndex][0]),
                  value: optionsShuffled[_currentIndex][0],
                  groupValue: _userAnswers[_currentIndex],
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[_currentIndex] = value.toString();
                    });
                  },
                ),

                RadioListTile(
                  title: Text(optionsShuffled[_currentIndex][1]),
                  value: optionsShuffled[_currentIndex][1],
                  groupValue: _userAnswers[_currentIndex],
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[_currentIndex] = value.toString();
                    });
                  },
                ),

                RadioListTile(
                  title: Text(optionsShuffled[_currentIndex][2]),
                  value: optionsShuffled[_currentIndex][2],
                  groupValue: _userAnswers[_currentIndex],
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[_currentIndex] = value.toString();
                    });
                  },
                ),

                RadioListTile(
                  title: Text(optionsShuffled[_currentIndex][3]),
                  value: optionsShuffled[_currentIndex][3],
                  groupValue: _userAnswers[_currentIndex],
                  onChanged: (value) {
                    setState(() {
                      _userAnswers[_currentIndex] = value.toString();
                    });
                  },
                ),

                ///shows correct answers after quiz submitted
                if (isSubmited)
                  Text(
                    'Correct answer: ${_correctAns[_currentIndex]}',
                    style: TextStyle(
                      color: _userAnswers[_currentIndex] ==
                          _correctAns[_currentIndex]
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
                      onPressed:
                      isSubmited && _currentIndex == _questions.length - 1
                          ? () => Navigator.of(context).pop()
                          : _currentIndex == _questions.length - 1
                          ? _submitAnswer
                          : _goToNextQuestion,
                      child: Text(
                        isSubmited && _currentIndex == _questions.length - 1
                            ? 'Close'
                            : _currentIndex == _questions.length - 1
                            ? 'Submit'
                            : 'Next',
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