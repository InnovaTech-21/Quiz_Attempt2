import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerMAQ.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerShortAns.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerMCQ.dart';
import 'package:quiz_website/menu.dart';
import 'Database Services/database.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final List<String> _QuizName = [];
  final List<int> _TimerTime = [];
  final List<bool> _QuizTimed = [];
  DatabaseService service = DatabaseService();
  final List<String> _QuizType = [];
  final List<String> _QuizDesc = [];
  final List<String> _QuizPrereq = [];
  late List<String> _QuizzesDone = [];
  final List<String> _NumberofQuestions = [];
  final List<String> _QuizCategory = [];
  final List<String> _Quiz_ID = [];

  void _showDialog(String quizName, int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prerequisite not done'),
          content: Text('This quiz requires you to have done: $quizName. Would you like to do it now?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                return; // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to a new page
                goToQuiz(_QuizPrereq, i);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getAllUniqueQuizIds(String userId) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('QuizResults');

    try {
      final QuerySnapshot querySnapshot = await collectionRef.where('UserID', isEqualTo: userId).get();
      final List<String> quizIds = [];

      for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
        final String? abc = doc['Quiz_ID'];

        if (!quizIds.contains(abc)) {
          quizIds.add(abc!);
        }
      }
      for (int i = 0; i < quizIds.length; i++) {
        _QuizzesDone.add(quizIds[i]);
      }
    } catch (error) {
      print('Error retrieving quiz IDs: $error');
    }
  }

  String x = 'All';

  Future<void> getQuizInformation(String x) async {
    if (_QuizName.isEmpty) {
      List<Map<String, dynamic>> questionsAnswersList = await service.getQuizInformation(x);

      for (var i = 0; i < questionsAnswersList.length; i++) {
        _QuizPrereq.add(questionsAnswersList[i]['prerequisite_quizzes']);
        _Quiz_ID.add(questionsAnswersList[i]['Quiz_ID']);
        _QuizTimed.add(questionsAnswersList[i]['QuizTimed']);
        _TimerTime.add(questionsAnswersList[i]['TimerTime']);
        _QuizName.add(questionsAnswersList[i]['QuizName']);
        _QuizDesc.add(questionsAnswersList[i]['Quiz_Description']);
        _QuizCategory.add(questionsAnswersList[i]['Quiz_Category']);
        _QuizType.add(questionsAnswersList[i]['Quiz_Type']);
        _NumberofQuestions.add(questionsAnswersList[i]['Number_of_questions']);
      }
    }
    getAllUniqueQuizIds(service.userID);
  }

  void goToQuiz(List<String> quiz, int i) {
    if (_QuizType[i] == 'Short-Answer') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShortQuizAnswer(
            quizID: quiz[i],
            bTimed: _QuizTimed[i],
            iTime: _TimerTime[i],
          ),
        ),
      );
    } else if (_QuizType[i] == 'Multiple Choice') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mcqQuizAnswer(
            quizID: quiz[i],
            bTimed: _QuizTimed[i],
            iTime: _TimerTime[i],
          ),
        ),
      );
    } else if (_QuizType[i] == 'Multiple Answer Quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerMAQ(
            quizID: quiz[i],
            bTimed: _QuizTimed[i],
            iTime: _TimerTime[i],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPage(
                  testFlag: false,
                ),
              ),
            );
          },
        ),
      ),
      body: Material(
        child: FutureBuilder(
          future: getQuizInformation(x),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<String> filteredQuiz_ID = [];
            List<String> filteredQuizName = [];
            List<String> filteredQuizDesc = [];
            List<String> filteredQuizCategory = [];
            List<String> filteredQuizType = [];
            List<String> filteredNumberofQuestions = [];

            if (x == 'All') {
              filteredQuiz_ID = List.from(_Quiz_ID);
              filteredQuizName = List.from(_QuizName);
              filteredQuizDesc = List.from(_QuizDesc);
              filteredQuizCategory = List.from(_QuizCategory);
              filteredQuizType = List.from(_QuizType);
              filteredNumberofQuestions = List.from(_NumberofQuestions);
            } else {
              for (int i = 0; i < _QuizCategory.length; i++) {
                if (_QuizCategory[i] == x) {
                  filteredQuiz_ID.add(_Quiz_ID[i]);
                  filteredQuizName.add(_QuizName[i]);
                  filteredQuizDesc.add(_QuizDesc[i]);
                  filteredQuizCategory.add(_QuizCategory[i]);
                  filteredQuizType.add(_QuizType[i]);
                  filteredNumberofQuestions.add(_NumberofQuestions[i]);
                }
              }
            }

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    FutureBuilder<String?>(
                      future: service.getUser(),
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data! + ' completed ' + _QuizzesDone.length.toString() + ' Unique Quizzes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text('Loading...');
                        }
                      },
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Select a Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(height: 60),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 400,
                                child: DropdownButton<String>(
                                  value: x,
                                  onChanged: (String? value) {
                                    setState(() {
                                      x = value!;
                                    });
                                    _Quiz_ID.clear();
                                    _QuizName.clear();
                                    _QuizDesc.clear();
                                    _QuizCategory.clear();
                                    _QuizType.clear();
                                    _NumberofQuestions.clear();
                                  },
                                  items: <String>[
                                    'All',
                                    'Movies',
                                    'Sports',
                                    'Celeb',
                                    'Music',
                                    'Books',
                                    'TV Shows',
                                    'Word Games',
                                    'General Knowledge',
                                    'Food',
                                    'Kdrama',
                                    'Anime',
                                    'Kpop'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            for (int i = 0; i < filteredQuizName.length; i++)
                              Container(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  width: 400,
                                  child: ElevatedButton(
                                    onPressed: () async {


                                      if (_QuizPrereq[i] != 'none') {
                                        if (_QuizzesDone.isEmpty ||
                                            !_QuizzesDone.contains(_QuizPrereq[i])) {
                                          String quizName = await service.getQuizName(_QuizPrereq[i]);
                                          _showDialog(quizName, i);
                                        } else {
                                          goToQuiz(_Quiz_ID, i);
                                        }
                                      } else {
                                        goToQuiz(_Quiz_ID, i);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(27),
                                      backgroundColor: ColourPallete.borderColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: ColourPallete.gradient2,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Quiz Name: ${filteredQuizName[i]}\nQuiz Category: ${filteredQuizCategory[i]}\nQuiz Type: ${filteredQuizType[i]}\nNumber of Questions: ${filteredNumberofQuestions[i]}',
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}