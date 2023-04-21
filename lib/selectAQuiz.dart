import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:quiz_website/Views/AnswerQuiz/ShortQuizAns.dart';
import '../../main.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final List<String> _QuizName = []; // load in the questions

  ///List of correct answers
  final List <String> _QuizType=[];
  final List<String> _QuizDesc = []; // load in the questions

  ///List of correct answers
  final List <String> _NomberofQuestions=[];
  final List<String> _QuizCategory = []; // load in the questions

  String _selectedFilter = 'All'; // Variable to store selected filter, set initial value to 'All'
  Future<void> getQuizINformation(String x) async {

      CollectionReference users = FirebaseFirestore.instance.collection(
          'Quizzes');

      //QuerySnapshot recentQuizzesSnapshot = await users.where("QuizID", isEqualTo: x).get();
      x = "Anime";
      QuerySnapshot questionsSnapshot = await users
          .where('Quiz_Category', isEqualTo: x)
          .orderBy('Date_Created', descending: true)
          .get();

      String x = "2";
      List<Map<String, dynamic>> questionsAnswersList = [];

      if (questionsSnapshot.docs.isNotEmpty) {
        for (int i = 0; i < questionsSnapshot.docs.length; i++) {
          DocumentSnapshot quizDoc = questionsSnapshot.docs[i];
          Map<String, dynamic> questionAnswerMap = {
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
        _QuizName.add(questionsAnswersList[i]["QuizName"]);
        _QuizDesc.add(questionsAnswersList[i]["Quiz_Description"]);
        _QuizCategory.add(questionsAnswersList[i]["Quiz_Category"]);
        _QuizType.add(questionsAnswersList[i]["Quiz_Type"]);
        _NomberofQuestions.add(questionsAnswersList[i]["Number_of_questions"]);

      }
     // _userAnswers=List.filled(questionsAnswersList.length, '');
    }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              ///goes to welcome page
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      backgroundColor: ColourPallete.backgroundColor,
      body: Material(
          child: FutureBuilder(
              future: getQuizINformation("Anime"),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return SingleChildScrollView(
                    child: Center(
                        child: Column(
                            children: <Widget>[
                              SizedBox(height: 50),
                              Text(
                                "Select a Quiz",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                              const SizedBox(height: 60),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // ComboBox filter
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        // ComboBox filter
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: SizedBox(
                                            width: 200,
                                            child: DropdownButton<String>(
                                              value: _selectedFilter,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _selectedFilter = value!;
                                                  getQuizINformation(value.toString());
                                                });
                                              },
                                              items: <String>[
                                                'All',
                                                'Anime',
                                                'Kpop',
                                                'Kdrama'
                                              ] // Add 'All' as an option
                                                  .map<DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30), // Add some spacing
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: SizedBox(
                                            width: 400,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Add your onPressed logic here
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.all(27),
                                                primary: ColourPallete.borderColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: ColourPallete.gradient2,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                'Quiz Name: ${_QuizName[0]}\nQuiz Category: ${_QuizCategory[0]}\nQuiz Type: ${_QuizType[0]}\nNumber of Questions: ${_NomberofQuestions[0]}'
                              ),

                              ),
                            ),
                          ),

                      ],
                ),


    ]
    )
          ]

      )
    )
    );
  }
  )
      )
  );

  }
}