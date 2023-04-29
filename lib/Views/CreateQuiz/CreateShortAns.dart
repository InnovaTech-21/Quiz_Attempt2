import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import '../../../../menu.dart';

class ShortAnswerQuestionPage extends StatefulWidget {
  const ShortAnswerQuestionPage({Key? key}) : super(key: key);

  @override
  _ShortAnswerQuestionPageState createState() =>
      _ShortAnswerQuestionPageState();
}

class _ShortAnswerQuestionPageState extends State<ShortAnswerQuestionPage> {
  final _formKey = GlobalKey<FormState>();



  ///change this to get number of questions from database

  int currentQuestionIndex = 0;

  ///list of question class
  List<Question> questions = [];


  ///controllers to get the values from the text boxes
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];

  ///code to load the question details if already inputed by the user
  void loadExisting(int index) {
    if (index >= 0) {
      questionControllers[index].text = questions[index].question;
      answerControllers[index].text = questions[index].answer;

      ///listeners to see if user changes details
      questionControllers[index].addListener(() {
        questions[index].question = questionControllers[index].text;
      });
      answerControllers[index].addListener(() {
        questions[index].answer = answerControllers[index].text;
      });
    }
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


  Future<String> _getQuizID() async {
    // get number of questions from databse
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

// Update the document
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
    ///Create quizzes created successfully, now add data to Firestore

    CollectionReference users =
    FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Question': questions[index].question.toString(),
      'Answers': questions[index].answer.toString(),
      'QuizID': await _getQuizID(),
      'Question_type': "Short Answer",
      'QuestionNo': index,
    };

    await users.doc(docRef.id).set(userData);
  }

  void addNumberOfQuestions(String quizID, int numQuestions) async {
    CollectionReference quizzesCollection =
    FirebaseFirestore.instance.collection('Quizzes');

    // Get the quiz document with the specified ID
    QuerySnapshot quizQuery =
    await quizzesCollection.where('Quiz_ID', isEqualTo: quizID).get();

    if (quizQuery.docs.length == 1) {
      // Update the number of questions for the quiz
      DocumentReference quizDocRef = quizQuery.docs[0].reference;
      await quizDocRef.update({'Number_of_questions': numQuestions});

      print('Successfully updated the number of questions for QuizID $quizID');
    } else {
      print('Error: Found ${quizQuery.docs.length} quizzes with QuizID $quizID');
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
        questions.add(Question(
          question: questionControllers[currentQuestionIndex].text,
          answer: answerControllers[currentQuestionIndex].text,
        ));

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

  Future<void> _publish() async {
    if (_formKey.currentState!.validate()) {
      questions.add(Question(
        question: questionControllers[currentQuestionIndex].text,
        answer: answerControllers[currentQuestionIndex].text,
      ));

      addNumberOfQuestions(await _getQuizID(), questions.length);
      /// write to database
      for (int i = 0; i < questions.length; i++) {
        addDataToFirestore(i);

      }
      updateQuizzesStattus();
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
                            _publish();
                          },
                          child: Text('Publish'),
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

///question class
class Question {
  String question;
  String answer;

  Question({required this.question, required this.answer});
}
