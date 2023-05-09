import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

import 'package:quiz_website/Views/CreateQuiz/publishPage.dart';


class ShortAnswerQuestionPage extends StatefulWidget {
  const ShortAnswerQuestionPage({Key? key}) : super(key: key);

  @override
  _ShortAnswerQuestionPageState createState() =>
      _ShortAnswerQuestionPageState();
}

class _ShortAnswerQuestionPageState extends State<ShortAnswerQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  int currentQuestionIndex = 0;

  ///list of question class
  List<String> questions = [];
  List<String> answers = [];


  ///controllers to get the values from the text boxes
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];

  ///code to load the question details if already inputed by the user
  void loadExisting(int index) {
    if (index >= 0) {
      questionControllers[index].text = questions[index];
      answerControllers[index].text = answers[index];

      ///listeners to see if user changes details
      questionControllers[index].addListener(() {
        questions[index] = questionControllers[index].text;
      });
      answerControllers[index].addListener(() {
        answers[index] = answerControllers[index].text;
      });
    }
  }

  ///checks if validations passed then continues
  void _nextQuestion() async {
    if (_formKey.currentState!.validate()) {
      ///if more question still are still to come


      ///if we are on a question already added to the list( we backtracked)
      if (currentQuestionIndex < questions.length) {
        int index = currentQuestionIndex;

        if (index < questions.length) {
          ///loads in question and answer from list
          loadExisting(index);
        }
      }

      ///if we are on a question that has no yet been added to the list
      else {
        questions.add( questionControllers[currentQuestionIndex].text);
        answers.add(answerControllers[currentQuestionIndex].text);

        ///clears details for next question to be entered
        questionControllers[currentQuestionIndex].clear();
        answerControllers[currentQuestionIndex].clear();
      }

      ///increments our current question index then loads next question from loop
      setState(() {
        currentQuestionIndex++;
      });


    }
  }



  @override
  Widget build(BuildContext context) {
    questionControllers.add(TextEditingController());
    answerControllers.add(TextEditingController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            questions = [];
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ColourPallete.backgroundColor,
      body: Material(
        color: ColourPallete.backgroundColor,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ///title that contains question number
                Text(
                  'Question ${currentQuestionIndex + 1}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                ///question text box
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: questionControllers[currentQuestionIndex],
                  decoration: const InputDecoration(
                    hintText: 'Enter your question here',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: validateQuestion,
                ),
                SizedBox(height: 16),

                ///answer text box
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: answerControllers[currentQuestionIndex],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter the correct answer here',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: validateAnswer,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///previous question button only appears when not on first question
                    if (currentQuestionIndex > 0)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentQuestionIndex--;
                            });
                            loadExisting(currentQuestionIndex);
                          },
                          child: Text('Previous Question'),
                        ),
                      ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          ///runs the code to go to the next question
                          questionControllers.add(TextEditingController());
                          answerControllers.add(TextEditingController());
                          _nextQuestion();
                        },
                        child: Text('Next Question'),
                      ),
                    ),
                    if (currentQuestionIndex > 1)
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              questions.add(
                                  questionControllers[currentQuestionIndex]
                                      .text);
                              answers.add(
                                  answerControllers[currentQuestionIndex].text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        publishPage(questions: questions,
                                            answers: answers,quizType: 1,)
                                ),
                              );
                            }
                          },
                          child: Text('Done'),
                        ),
                      ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  ///validation checks
  String? validateQuestion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a question';
    } else {
      return null;
    }
  }

  String? validateAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an answer';
    } else {
      return null;
    }
  }


}

///question class
// class Question {
//   String question;
//   String answer;
//
//   Question({required this.question, required this.answer});
// }
