import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/Views/sign%20up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerShortAns.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerMCQ.dart';
import 'Database Services/database.dart';
import 'package:quiz_website/selectAQuiz.dart';

import 'RankingsPage.dart';
import 'Views/AnswerQuiz/answerMAQ.dart';
import 'Views/quizStats/quiz_stats.dart';

class SelectaPage extends StatefulWidget {
  const SelectaPage({Key? key}) : super(key: key);

  @override
  State<SelectaPage> createState() => _SelectaPageState();
}

class _SelectaPageState extends State<SelectaPage> {
  final List<String> _QuizName = [];
  final List<int> _TimerTime = [];
  final List<bool> _QuizTimed = []; // load in the questions
  DatabaseService service = DatabaseService();

  ///List of correct answers
  final List<String> _QuizType = [];
  final List<String> _QuizDesc = []; // load in the questions

  ///List of correct answers
  final List<String> _NumberofQuestions = [];
  final List<String> _QuizCategory = []; // load in the questions
  final List<String> _Quiz_ID = [];
  final List<String> _Quiz_Images = [];
  final List<String> _QuizPrereq = [];

  String _selectedFilter =
      'All'; // Variable to store selected filter, set initial value to 'All'

  ///method to load completed quiz's from database
  Future<void> getQuizInformation(String x) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Quizzes');
    x = _selectedFilter;
    String y = 'Finished';
    QuerySnapshot questionsSnapshot;
    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    if ((x != "All")) {
      questionsSnapshot = await users
          .where('Quiz_Category', isEqualTo: x)
          .where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true)
          .get();
    } else {
      questionsSnapshot = await users
          .where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true)
          .get();
    }

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    // String x = "2";
    List<Map<String, dynamic>> questionsAnswersList = [];

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Quiz_ID": quizDoc["Quiz_ID"],
          "QuizName": quizDoc["QuizName"],
          "Quiz_Description": quizDoc["Quiz_Description"],
          "Quiz_Category": quizDoc["Quiz_Category"],
          "Quiz_Type": quizDoc["Quiz_Type"],
          "Number_of_questions": quizDoc["Number_of_questions"].toString(),
          "Quiz_URL": quizDoc["Quiz_URL"],
          "prerequisite_quizzes": quizDoc["prerequisite_quizzes"],
        };
        if (quizDoc["QuizTimed"] != null) {
          questionAnswerMap["QuizTimed"] = quizDoc["QuizTimed"];
        } else {
          questionAnswerMap["QuizTimed"] = false;
        }
        if (quizDoc["TimerTime"] != null) {
          questionAnswerMap["TimerTime"] = quizDoc["TimerTime"];
        } else {
          questionAnswerMap["TimerTime"] = 0;
        }
        questionsAnswersList.add(questionAnswerMap);
      }
    }
    for (var i = 0; i < questionsAnswersList.length; i++) {
      _Quiz_ID.add(questionsAnswersList[i]["Quiz_ID"]);
      _QuizTimed.add(questionsAnswersList[i]["QuizTimed"]);
      _TimerTime.add(questionsAnswersList[i]["TimerTime"]);
      _QuizName.add(questionsAnswersList[i]["QuizName"]);
      _QuizDesc.add(questionsAnswersList[i]["Quiz_Description"]);
      _QuizCategory.add(questionsAnswersList[i]["Quiz_Category"]);
      _QuizType.add(questionsAnswersList[i]["Quiz_Type"]);
      _NumberofQuestions.add(questionsAnswersList[i]["Number_of_questions"]);
      _Quiz_Images.add(questionsAnswersList[i]["Quiz_URL"]);
      _QuizPrereq.add(questionsAnswersList[i]['prerequisite_quizzes']);
    }
    // _userAnswers=List.filled(questionsAnswersList.length, '');
  }

  // Function to handle the random quiz button press
  Future<void> handleRandomQuizButtonPress(BuildContext context) async {
    int randomQuizIndex = -1;

    // Generate a random index until a quiz with _QuizPrereq[randomQuizIndex] = "none" is found
    while (randomQuizIndex == -1 || _QuizPrereq[randomQuizIndex] != "none") {
      randomQuizIndex =
          _Quiz_ID.isNotEmpty ? Random().nextInt(_Quiz_ID.length) : -1;
    }

    // Create and display the quiz information pop-up dialog
    if (randomQuizIndex != -1) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('${_QuizName[randomQuizIndex]}'),
            content: Column(
              children: [
                Image.asset(
                  _Quiz_Images[randomQuizIndex],
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 10),
                Text('Category: ${_QuizCategory[randomQuizIndex]}'),
                Text('Type: ${_QuizType[randomQuizIndex]}'),
                Text(
                    'Number of Questions: ${_NumberofQuestions[randomQuizIndex]}'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Start Quiz'),
                onPressed: () {
                  if (_QuizType[randomQuizIndex] == "Short-Answer") {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShortQuizAnswer(
                          quizID: _Quiz_ID[randomQuizIndex],
                          bTimed: _QuizTimed[randomQuizIndex],
                          iTime: _TimerTime[randomQuizIndex],
                        ),
                      ),
                    );
                  }
                  if (_QuizType[randomQuizIndex] == "Multiple Choice") {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mcqQuizAnswer(
                          quizID: _Quiz_ID[randomQuizIndex],
                          bTimed: _QuizTimed[randomQuizIndex],
                          iTime: _TimerTime[randomQuizIndex],
                        ),
                      ),
                    );
                  }
                  if (_QuizType[randomQuizIndex] == 'Multiple Answer Quiz') {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerMAQ(
                          quizID: _Quiz_ID[randomQuizIndex],
                          bTimed: _QuizTimed[randomQuizIndex],
                          iTime: _TimerTime[randomQuizIndex],
                        ),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('No Quizzes Available'),
            content: Text(
                'There are no quizzes available for the selected category.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (service.userID == '') {
      return Scaffold(
        backgroundColor: ColourPallete.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: ColourPallete.backgroundColor,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/InnovaTechLogo.png',
                  width: 110,
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Text(
                    "InnovaTech Quiz Platform",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('Random'),
                    title: 'Random',
                    tapEvent: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sorry about that :('),
                            content:
                                Text("Please login in to answer a random quiz"),
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
                    },
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('Answer Quiz'),
                    title: 'Answer Quiz',
                    tapEvent: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sorry about that :('),
                            content: Text("Please login to answer a quiz"),
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
                    },
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('Create Quiz'),
                    title: 'Create Quiz',
                    tapEvent: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sorry about that :('),
                            content: Text("Please login to create a quiz"),
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
                    },
                  ),
                ),
                Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColourPallete.gradient1,
                        ColourPallete.gradient2,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(80, 35),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColourPallete.gradient2,
                        ColourPallete.gradient1,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(95, 35),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Material(
          color: ColourPallete.backgroundColor,
          child: Container(
            child: FutureBuilder(
              future: getQuizInformation("All"),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Trending Quizzes',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.5, // Adjust the value as needed
                      child: CarouselSlider.builder(
                        itemCount: _QuizName.length,
                        itemBuilder:
                            (BuildContext context, int i, int realIndex) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color:
                                    ColourPallete.borderColor.withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: ColourPallete.backgroundColor,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Image.asset(
                                          _Quiz_Images[i],
                                          width: 190,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              '${_QuizName[i].toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'CATEGORY:',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${_QuizCategory[i]}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'TYPE:',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${_QuizType[i]}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${_NumberofQuestions[i]} QUESTIONS',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Sorry about that :('),
                                                      content: Text(
                                                          "Please login in to answer a random quiz"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                backgroundColor: ColourPallete
                                                    .backgroundColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(21),
                                                  side: BorderSide(
                                                    color:
                                                        ColourPallete.gradient2,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Text('Start Quiz'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: ColourPallete.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: ColourPallete.backgroundColor,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/InnovaTechLogo.png',
                  width: 110,
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Text(
                    "InnovaTech Quiz Platform",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('Random'),
                    title: 'Random',
                    tapEvent: () {
                      handleRandomQuizButtonPress(context);
                    },
                  ),
                ),
                SizedBox(width: 3),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('View Rankings'),
                    title: 'View Rankings',
                    tapEvent: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankingsPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 3),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('View Quiz Stats'),
                    title: 'View Quiz Stats',
                    tapEvent: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizStatsPage(),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: NavItem(
                    key: ValueKey('Answer Quiz'),
                    title: 'Answer Quiz',
                    tapEvent: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 3),
                Expanded(
                  flex: 3,
                  child: NavItem(
                    key: ValueKey('Create Quiz'),
                    title: 'Create Quiz',
                    tapEvent: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateQuizPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Material(
          color: ColourPallete.backgroundColor,
          child: Container(
            child: FutureBuilder(
              future: getQuizInformation("All"),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Trending Quizzes',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.5, // Adjust the value as needed
                      child: CarouselSlider.builder(
                        itemCount: _QuizName.length,
                        itemBuilder:
                            (BuildContext context, int i, int realIndex) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color:
                                    ColourPallete.borderColor.withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: ColourPallete.backgroundColor,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Image.asset(
                                          _Quiz_Images[i],
                                          width: 190,
                                          height: 190,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              '${_QuizName[i].toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'CATEGORY:',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${_QuizCategory[i]}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'TYPE:',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${_QuizType[i]}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${_NumberofQuestions[i]} QUESTIONS',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_QuizType[i] ==
                                                    "Short-Answer") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShortQuizAnswer(
                                                        quizID: _Quiz_ID[i],
                                                        bTimed: _QuizTimed[i],
                                                        iTime: _TimerTime[i],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (_QuizType[i] ==
                                                    "Multiple Choice") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          mcqQuizAnswer(
                                                        quizID: _Quiz_ID[i],
                                                        bTimed: _QuizTimed[i],
                                                        iTime: _TimerTime[i],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (_QuizType[i] ==
                                                    'Multiple Answer Quiz') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnswerMAQ(
                                                        quizID: _Quiz_ID[i],
                                                        bTimed: _QuizTimed[i],
                                                        iTime: _TimerTime[i],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                backgroundColor: ColourPallete
                                                    .backgroundColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(21),
                                                  side: BorderSide(
                                                    color:
                                                        ColourPallete.gradient2,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Text('Start Quiz'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }
}

class NavItem extends StatelessWidget {
  const NavItem({required Key key, required this.title, required this.tapEvent})
      : super(key: key);

  final String title;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapEvent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
              color: ColourPallete.whiteColor,
              fontWeight: FontWeight.w300,
              fontSize: 18),
        ),
      ),
    );
  }
}
