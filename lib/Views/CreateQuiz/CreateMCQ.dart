import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_website/menu.dart';

class MCQ_Question_Page extends StatefulWidget {
  const MCQ_Question_Page({Key? key}) : super(key: key);

  @override
  _MCQ_Question_Page createState() => _MCQ_Question_Page();
}

class _MCQ_Question_Page extends State<MCQ_Question_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int numberOfQuestions = 5;
  int currentQuestionIndex = 0;
  List<Question> questions = [];
  int? numberofQuestions = 0;
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> correctanswerControllers = [];
  List<TextEditingController> randomAnswerControllers1 = [];
  List<TextEditingController> randomAnswerControllers2 = [];
  List<TextEditingController> randomAnswerControllers3 = [];

  void loadExisting(int index) {
    if (index >= 0) {
      questionControllers[index].text = questions[index].question;
      correctanswerControllers[index].text = questions[index].answer;
      randomAnswerControllers1[index].text = questions[index].question;
      randomAnswerControllers2[index].text = questions[index].answer;
      randomAnswerControllers3[index].text = questions[index].answer;

      //LISTENERS TO SEE IF USER CHANGES DETAILS
      questionControllers[index].addListener(() {
        questions[index].question = questionControllers[index].text;
      });
      correctanswerControllers[index].addListener(() {
        questions[index].answer = correctanswerControllers[index].text;
      });
      randomAnswerControllers1[index].addListener(() {
        questions[index].answer = randomAnswerControllers1[index].text;
      });
      randomAnswerControllers2[index].addListener(() {
        questions[index].answer = randomAnswerControllers1[index].text;
      });
      randomAnswerControllers3[index].addListener(() {
        questions[index].answer = randomAnswerControllers1[index].text;
      });
    }
  }

  //GETS USERNAME
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
        return data['user_name'];
      } catch (e) {
        return 'Error fetching user';
      }
    }
  }

  Future<int> _getNumberOfQuestions() async {
    //GETS NUMBER OF QUESTIONS FROM DATABASE
    int numberOfQuestions = 0;
    final CollectionReference quizzesCollection =
        FirebaseFirestore.instance.collection('Quizzes');

    String? username = await getUser();
    if (username != null) {
      QuerySnapshot questionsSnapshot = await quizzesCollection
          .where('Username', isEqualTo: username)
          .orderBy('Date_Created', descending: true)
          .limit(1)
          .get();

      if (questionsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot mostRecentQuestion = questionsSnapshot.docs.first;
        numberOfQuestions = mostRecentQuestion['Number_of_questions'];
      }
    }
    numberofQuestions = numberOfQuestions;
    return numberOfQuestions;
  }

  Future<String> _getQuizID() async {
    //GET NUMBER OF QUESTIONS FROM DATABASE
    String quizID = "";
    final CollectionReference quizzesCollection =
        FirebaseFirestore.instance.collection('Quizzes');

    String? username = await getUser();
    if (username != null) {
      QuerySnapshot questionsSnapshot = await quizzesCollection
          .where('Username', isEqualTo: username)
          .orderBy('Date_Created', descending: true)
          .limit(1)
          .get();

      if (questionsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot mostRecentQuestion = questionsSnapshot.docs.first;
        quizID = mostRecentQuestion['Quiz_ID'].toString();
      }
    }

    return quizID;
  }

  void updateQuizzesStattus() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Quizzes')
        .doc(await _getQuizID());

//UPDATES THE DOCUMENT
    docRef.update({
      'Status': 'Finished',
    }).then((value) async {
      try {
        await _showDialog("Quiz Created");
      } finally {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      }
    }).catchError((error) {
      _showDialog("Error creating quiz");
    });
  }

  void addDataToFirestore(int index) async {
    //CREATE QUIZZES CREATED SUCCESSFULLY, NOW ADDS DATA TO FIRESTORE
    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Question': questions[index].question.toString(),
      'Answers': questions[index].answer.toString(),
      'Option1': questions[index].randoption1.toString(),
      'Option2': questions[index].randoption2.toString(),
      'Option3': questions[index].randoption3.toString(),
      'QuizID': await _getQuizID(),
      'Question_type': "MCQ",
      'QuestionNo': index,
    };

    await users.doc(docRef.id).set(userData);
  }

  //FIRST CHECKS IF VALIDATION CHECKS PASSED THEN CONTINUES
  void _nextQuestion() async {
    if (_formKey.currentState!.validate()) {
      //IF MORE QUESTIONS ARE STILL TO COME
      print(await (_getNumberOfQuestions()));
      if (currentQuestionIndex < (await (_getNumberOfQuestions()) - 1)) {
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

      //IF ON THE LAST QUESTION
      else {
        questions.add(Question(
          question: questionControllers[currentQuestionIndex].text,
          answer: correctanswerControllers[currentQuestionIndex].text,
          randoption1: randomAnswerControllers1[currentQuestionIndex].text,
          randoption2: randomAnswerControllers2[currentQuestionIndex].text,
          randoption3: randomAnswerControllers3[currentQuestionIndex].text,
        ));

        //WRITE TO DATABASE
        for (int i = 0; i < numberofQuestions!; i++) {
          addDataToFirestore(i);
        }
        updateQuizzesStattus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < numberOfQuestions; i++) {
      questionControllers.add(TextEditingController());
      correctanswerControllers.add(TextEditingController());
      randomAnswerControllers1.add(TextEditingController());
      randomAnswerControllers2.add(TextEditingController());
      randomAnswerControllers3.add(TextEditingController());
    }
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //BUTTON TO PREVIOUS QUESTION
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
                        ///BUTTON TO NEXT QUESTION
                        _nextQuestion();
                      },
                      child: FutureBuilder<int>(
                        future: _getNumberOfQuestions(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int numberOfQuestions = snapshot.data!;
                            return Text(

                                //CHANGES FROM NEXT QUESTION TO PUBLISH ON LAST QUESTION
                                currentQuestionIndex + 1 == numberOfQuestions
                                    ? 'Publish'
                                    : 'Next Question');
                          }
                        },
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
