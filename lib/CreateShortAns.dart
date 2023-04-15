import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';


class ShortAnswerQuestionPage extends StatefulWidget {
  const ShortAnswerQuestionPage({Key? key}) : super(key: key);

  @override
  _ShortAnswerQuestionPageState createState() =>
      _ShortAnswerQuestionPageState();
}

class _ShortAnswerQuestionPageState extends State<ShortAnswerQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  ///change this to get number of questions from database
  int numberOfQuestions =5;
  int currentQuestionIndex = 0;
  ///list of question class
  List<Question> questions = [];

  ///controllers to get the values from the text boxes
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];





  void loadExisting(int index) {
    if (index >= 0) {
      questionControllers[index].text = questions[index].question;
      answerControllers[index].text = questions[index].answer;
      questionControllers[index].addListener(() {
        questions[index].question = questionControllers[index].text;
      });
      answerControllers[index].addListener(() {
        questions[index].answer = answerControllers[index].text;
      });

    }
  }

  ///checks if validations passed then continues
  void _submit()  {
    if (_formKey.currentState!.validate()) {
      ///if more question still are still to come
      if (currentQuestionIndex < numberOfQuestions - 1) {

        ///if we are on a question already added to the list( we backtracked)
        if (currentQuestionIndex < questions.length) {

          int index = currentQuestionIndex ;

          if (index < questions.length ) {
            ///loads in question and answer from list
            loadExisting(index);
          }


        }
        ///if we are on a question that has no yet been added to the list
        else {
          questions.add(Question(
            question: questionControllers[currentQuestionIndex].text,
            answer: answerControllers[currentQuestionIndex].text,
          ));

          questionControllers[currentQuestionIndex].clear();
          answerControllers[currentQuestionIndex].clear();


        }
        ///increments our current question index then loads next question from loop
        setState(() {
          currentQuestionIndex++;
        });
      }
      ///if on the last question
      else {
        questions.add(Question(
          question: questionControllers[currentQuestionIndex].text,
          answer: answerControllers[currentQuestionIndex].text,
        ));

        /// write to database
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < numberOfQuestions; i++) {
      questionControllers.add(TextEditingController());
      answerControllers.add(TextEditingController());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            questions =[];
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestionIndex--;
                          });
                          loadExisting(currentQuestionIndex);

                        },
                        child: Text('Previous Question'),
                      ),
                    ElevatedButton(
                      onPressed: () {

                        _submit();

                      },
                      child: Text(currentQuestionIndex == numberOfQuestions - 1
                          ? 'Publish'
                          : 'Next Question'),
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
  String? validateQuestion(String? value){
    if (value == null || value.isEmpty) {
      return 'Enter a question';
    }else{
      return null;
    }
  }

  String? validateAnswer(String? value){
    if (value == null || value.isEmpty) {
      return 'Enter an answer';
    }
    else{
      return null;
    }
  }
}

class Question {
  String question;
  String answer;

  Question({required this.question, required this.answer});
}
