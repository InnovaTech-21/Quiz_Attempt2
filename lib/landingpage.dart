import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerShortAns.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerMCQ.dart';


import 'Database Services/database.dart';


class SelectaPage extends StatefulWidget {
  const SelectaPage({Key? key}) : super(key: key);

  @override
  State<SelectaPage> createState() => _SelectaPageState();
}

class _SelectaPageState extends State<SelectaPage> {
  final List<String> _QuizName = [];
  final List<int> _TimerTime = [];
  final List<bool> _QuizTimed = [];// load in the questions
  DatabaseService service = DatabaseService();
  ///List of correct answers
  final List <String> _QuizType=[];
  final List<String> _QuizDesc = []; // load in the questions

  ///List of correct answers
  final List <String> _NumberofQuestions=[];
  final List<String> _QuizCategory = []; // load in the questions
  final List<String> _Quiz_ID = [];


  String _selectedFilter = 'All'; // Variable to store selected filter, set initial value to 'All'
  ///method to load completed quiz's from database
  Future<void> getQuizInformation(String x) async {

    CollectionReference users = FirebaseFirestore.instance.collection(
        'Quizzes');
    x = _selectedFilter;
    String  y = 'Finished';
    QuerySnapshot questionsSnapshot;
    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    if(( x != "All")) {

      questionsSnapshot = await users
          .where('Quiz_Category', isEqualTo: x)
          .where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true)
          .get();

    }
    else{
      questionsSnapshot = await users.where('Status', isEqualTo: y)
          .orderBy('Date_Created', descending: true).get();
    }

    //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
    // String x = "2";
    List<Map<String, dynamic>> questionsAnswersList = [];

    if (questionsSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < questionsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
        Map<String, dynamic> questionAnswerMap = {
          "Quiz_ID" : quizDoc["Quiz_ID"],
          "QuizName": quizDoc["QuizName"],
          "Quiz_Description": quizDoc["Quiz_Description"],
          "Quiz_Category": quizDoc["Quiz_Category"],
          "Quiz_Type":quizDoc["Quiz_Type"],
          "Number_of_questions":quizDoc["Number_of_questions"].toString(),
        };
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


    }
    // _userAnswers=List.filled(questionsAnswersList.length, '');

  }



  @override
  Widget build(BuildContext context) {

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
                Text(
                  "InnovaTech Quiz Platform",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                Spacer(),
                Container(
                  //color: ColourPallete.backgroundColor,
                  width: 260,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: ColourPallete.gradient1, width: 2),
                    color: ColourPallete.backgroundColor,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColourPallete.backgroundColor,
                            hintText: 'Search for a quiz or by category',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                NavItem(
                  key: ValueKey('home'),
                  title: 'Home',
                  tapEvent: () {},
                ),
                NavItem(
                  key: ValueKey('Create a Quiz'),
                  title: 'Create a Quiz',
                  tapEvent: () {},
                ),
                NavItem(
                  key: ValueKey('Answer a Quiz'),
                  title: 'Answer a Quiz',
                  tapEvent: () {},
                ),
                // NavItem(
                // key: ValueKey('contactus'),
                //title: 'Contact Us',
                //tapEvent: () {},
                //),
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
                    onPressed: ()  {
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(80,35), backgroundColor: Colors.transparent,
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
                SizedBox(width: 11),
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
                    onPressed: ()  {
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(95,35), backgroundColor: Colors.transparent,
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
            ///builds widget when quiz details are retrieved
            child: FutureBuilder(
                future: getQuizInformation("Anime"),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Filter quiz data based on selected category
                  List<String> filteredQuiz_ID = [];
                  List<String> filteredQuizName = [];
                  List<String> filteredQuizDesc = [];
                  List<String> filteredQuizCategory = [];
                  List<String> filteredQuizType = [];
                  List<String> filteredNumberofQuestions = [];

                  if (_selectedFilter == 'All') {
                    // Show all quizzes
                    filteredQuiz_ID = List.from(_Quiz_ID);
                    filteredQuizName = List.from(_QuizName);
                    filteredQuizDesc = List.from(_QuizDesc);
                    filteredQuizCategory = List.from(_QuizCategory);
                    filteredQuizType = List.from(_QuizType);
                    filteredNumberofQuestions = List.from(_NumberofQuestions);
                  } else {
                    // Show quizzes with selected category
                    for (int i = 0; i < _QuizCategory.length; i++) {
                      if (_QuizCategory[i] == _selectedFilter) {
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
                          const SizedBox(height: 60),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // ComboBox filter
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // ComboBox filter
                                  for (int i = 0; i < filteredQuizName.length; i++) // Use filteredQuizName.length
                                    Container(

                                      color: ColourPallete.backgroundColor,
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        width: 700,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            ///goes to relevant answer quiz page
                                            if (_QuizType[i] == "Short-Answer" ) {
                                              print(_Quiz_ID[i]);
                                              Navigator.push(
                                                context,

                                                MaterialPageRoute(builder: (context) => ShortQuizAnswer(quizID: _Quiz_ID[i], bTimed: _QuizTimed[i], iTime: _TimerTime[i] )),
                                              );
                                            }
                                            if (_QuizType[i] == "Multiple Choice" ) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => mcqQuizAnswer(quizID: _Quiz_ID[i], bTimed: _QuizTimed[i], iTime: _TimerTime[i]   )),
                                              );
                                            }
                                            // Add your onPressed logic here
                                          },

                                          style: ElevatedButton.styleFrom(

                                            padding: const EdgeInsets.all(27), backgroundColor: ColourPallete.backgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: ColourPallete.gradient2,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/InnovaTechLogo.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                  'Quiz Name: ${_QuizName[i]}\nQuiz Category: ${_QuizCategory[i]}\nQuiz Type: ${_QuizType[i]}\nNumber of Questions: ${_NumberofQuestions[i]}'),
                                            ],
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

                    ), );

                }
            )
        )
    );


  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    required Key key,
    required this.title,
    required this.tapEvent
  }) : super(key: key);

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
              fontSize: 18

          ),
        ),
      ),
    );
  }
}