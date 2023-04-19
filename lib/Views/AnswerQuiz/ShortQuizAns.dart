import 'package:flutter/material.dart';

class ShortQuizAnswer extends StatefulWidget {
  const ShortQuizAnswer({Key? key}) : super(key: key);

  @override
  _ShortQuizAnswerState createState() => _ShortQuizAnswerState();
}

class _ShortQuizAnswerState extends State<ShortQuizAnswer> {
  int _currentIndex = 0;
  final _ansController = TextEditingController();

  ///list of questions from database
  final List<String> _questions = [    'Question 1',    'Question 2',    'Question 3',    'Question 4',    'Question 5'  ];

  ///List of correct answers
  List <String> _correnctAns=[];
  ///list of user answers
  List<String> _userAnswers = ['', '', '', '', ''];

  ///saves the users answers to a list as they answer the questions
  void _submitAnswer() {
    setState(() {
      _userAnswers[_currentIndex] = _ansController.text;
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _ansController.clear();
      }
    });
  }

  ///allows user to go back to a previous question and reanswer it
  void _goToPreviousQuestion() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _ansController.text = _userAnswers[_currentIndex];
      }
    });
  }

  ///loads in the next question and clears previous answer
  void _goToNextQuestion() {
    setState(() {
      _userAnswers[_currentIndex] = _ansController.text;
      _currentIndex++;
      _ansController.text = _userAnswers[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answer Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
              controller: _ansController,
              decoration: InputDecoration(
                hintText: 'Type your answer here',
                border: OutlineInputBorder(),
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
                  onPressed: _currentIndex == _questions.length - 1
                      ? _submitAnswer
                      : _goToNextQuestion,
                  child: Text(
                    _currentIndex == _questions.length - 1 ? 'Submit' : 'Next',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
