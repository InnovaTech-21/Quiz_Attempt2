import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/publishPage.dart';

class mCQ_Question_Page extends StatefulWidget {
  const mCQ_Question_Page({Key? key}) : super(key: key);


  @override
  _MCQ_Question_Page createState() => _MCQ_Question_Page();
}

class _MCQ_Question_Page extends State<mCQ_Question_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> quests = [];
  List<String> answers = [];

  int currentQuestionIndex = 0;
  List<Question> questions = [];

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> correctanswerControllers = [];
  List<TextEditingController> randomAnswerControllers1 = [];
  List<TextEditingController> randomAnswerControllers2 = [];
  List<TextEditingController> randomAnswerControllers3 = [];

  void loadExisting(int index) {
    if (index >= 0) {
      questionControllers[index].text = questions[index].question;
      correctanswerControllers[index].text = questions[index].answer;
      randomAnswerControllers1[index].text = questions[index].randoption1;
      randomAnswerControllers2[index].text = questions[index].randoption2;
      randomAnswerControllers3[index].text = questions[index].randoption3;

      //LISTENERS TO SEE IF USER CHANGES DETAILS
      questionControllers[index].addListener(() {
        questions[index].question = questionControllers[index].text;
      });
      correctanswerControllers[index].addListener(() {
        questions[index].answer = correctanswerControllers[index].text;
      });
      randomAnswerControllers1[index].addListener(() {
        questions[index].randoption1 = randomAnswerControllers1[index].text;
      });
      randomAnswerControllers2[index].addListener(() {
        questions[index].randoption2 = randomAnswerControllers2[index].text;
      });
      randomAnswerControllers3[index].addListener(() {
        questions[index].randoption3 = randomAnswerControllers3[index].text;
      });
    }
  }

  void convertLists() {
    quests = [];
    answers = [];
    for (int i = 0; i < questions.length; i++) {
      quests.add(questions[i].question);
      answers.add(questions[i].answer + '^' + questions[i].randoption1 + '^' +
          questions[i].randoption2 + '^' + questions[i].randoption3);
    }
  }

  //FIRST CHECKS IF VALIDATION CHECKS PASSED THEN CONTINUES
  void _nextQuestion() async {
    if (_formKey.currentState!.validate()) {
      //IF MORE QUESTIONS ARE STILL TO COME


      //IF ON A QUESTION ALREADY ADDED TO THE LIST (BACKTRACKED)
      if (currentQuestionIndex < questions.length) {
        int index = currentQuestionIndex;

        if (index < questions.length) {
          //LOADS IN QUESTION AND ANSWER FROM LIST
          loadExisting(index);
        }
      }

      //IF WE'RE ON A QUESTION THAT HAS NOT YET BEEN ADDED TO THE LIST
      else {
        questions.add(Question(
          question: questionControllers[currentQuestionIndex].text,
          answer: correctanswerControllers[currentQuestionIndex].text,
          randoption1: randomAnswerControllers1[currentQuestionIndex].text,
          randoption2: randomAnswerControllers2[currentQuestionIndex].text,
          randoption3: randomAnswerControllers3[currentQuestionIndex].text,
        ));

        //CLEARS DETAILS IN ORGER TO ENTER NEXT QUESTION
        questionControllers[currentQuestionIndex].clear();
        correctanswerControllers[currentQuestionIndex].clear();
        randomAnswerControllers1[currentQuestionIndex].clear();
        randomAnswerControllers2[currentQuestionIndex].clear();
        randomAnswerControllers3[currentQuestionIndex].clear();
      }

      //INCREMENTS CURRENT QUESTION INDEX THEN LOADS NEXT QUESTION
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    questionControllers.add(TextEditingController());
    correctanswerControllers.add(TextEditingController());
    randomAnswerControllers1.add(TextEditingController());
    randomAnswerControllers2.add(TextEditingController());
    randomAnswerControllers3.add(TextEditingController());

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
                //QUESTION NUMBER AS TITLE
                Text(
                  'Question ${currentQuestionIndex + 1}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16),

                //QUESTION TEXT BOX
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: questionControllers[currentQuestionIndex],
                  decoration: const InputDecoration(
                    hintText: 'Enter your question here',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: validateQuestion,
                ),
                SizedBox(height: 16),

                //CORRECT ANSWER TEXT BOX OPTION 1
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: correctanswerControllers[currentQuestionIndex],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Option 1 (correct answer)',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: validateAnswer,
                ),
                SizedBox(height: 16),

                //RANDOM INCORRECT ANSWER TEXT BOX OPTION 2
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: randomAnswerControllers1[currentQuestionIndex],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Option 2',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: validateAnswer,
                ),
                SizedBox(height: 16),

                //RANDOM INCORRECT ANSWER TEXT BOX OPTION 3
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: randomAnswerControllers2[currentQuestionIndex],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Option 3',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: validateAnswer,
                ),
                SizedBox(height: 16),

                //RANDOM INCORRECT ANSWER TEXT BOX OPTION 4
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: randomAnswerControllers3[currentQuestionIndex],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Option 4',
                    hintStyle: TextStyle(color: Colors.white),
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
                          correctanswerControllers.add(TextEditingController());
                          randomAnswerControllers1.add(TextEditingController());
                          randomAnswerControllers2.add(TextEditingController());
                          randomAnswerControllers3.add(TextEditingController());
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
                              if (currentQuestionIndex + 1 > questions.length) {
                                questions.add(Question(
                                  question: questionControllers[currentQuestionIndex]
                                      .text,
                                  answer: correctanswerControllers[currentQuestionIndex]
                                      .text,
                                  randoption1: randomAnswerControllers1[currentQuestionIndex]
                                      .text,
                                  randoption2: randomAnswerControllers2[currentQuestionIndex]
                                      .text,
                                  randoption3: randomAnswerControllers3[currentQuestionIndex]
                                      .text,
                                ));
                                questionControllers[currentQuestionIndex]
                                    .addListener(() {
                                  questions[currentQuestionIndex].question =
                                      questionControllers[currentQuestionIndex]
                                          .text;
                                });
                                correctanswerControllers[currentQuestionIndex]
                                    .addListener(() {
                                  questions[currentQuestionIndex].answer =
                                      correctanswerControllers[currentQuestionIndex]
                                          .text;
                                });
                                randomAnswerControllers1[currentQuestionIndex]
                                    .addListener(() {
                                  questions[currentQuestionIndex].randoption1 =
                                      randomAnswerControllers1[currentQuestionIndex]
                                          .text;
                                });
                                randomAnswerControllers2[currentQuestionIndex]
                                    .addListener(() {
                                  questions[currentQuestionIndex].randoption2 =
                                      randomAnswerControllers2[currentQuestionIndex]
                                          .text;
                                });
                                randomAnswerControllers3[currentQuestionIndex]
                                    .addListener(() {
                                  questions[currentQuestionIndex].randoption3 =
                                      randomAnswerControllers3[currentQuestionIndex]
                                          .text;
                                });
                              }
                              convertLists();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        publishPage(questions: quests,
                                          answers: answers, quizType: 2,)
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

  ///VALIDATION CHECKS
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

///QUESTION CLASS
class Question {
  String question;
  String answer;
  String randoption1;
  String randoption2;
  String randoption3;

  Question(
      {required this.question,
      required this.answer,
      required this.randoption1,
      required this.randoption2,
      required this.randoption3});
}
