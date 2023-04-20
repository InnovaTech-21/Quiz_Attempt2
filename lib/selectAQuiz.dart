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
  String _selectedFilter = 'All'; // Variable to store selected filter, set initial value to 'All'

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
        color: ColourPallete.backgroundColor,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                SizedBox(width: 150),
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
                                });
                              },
                              items: <String>['All', 'Anime', 'Kpop', 'Kdrama'] // Add 'All' as an option
                                  .map<DropdownMenuItem<String>>((String value) {
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
                                    )),
                              ),
                              child: Text(
                                'Quiz Name:\nQuiz Category:\nQuiz Type:\nNumber of Questions:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                ),
    ])])))));
  }
}