import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

import 'package:quiz_website/Views/CreateQuiz/CreateShortAns.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateMCQ.dart';
import 'package:quiz_website/Views/CreateQuiz/createMAQ.dart';
import 'package:quiz_website/Views/CreateQuiz/imageBased.dart';

import '../../Database Services/database.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => CreateQuizPageState();
}

class CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService service = DatabaseService();

  ///set text controllers
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController =
      TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  String? username;
  String? quizType;
  String? quizCategory;

  ///add data of quiz to be made to database
  void addDataToFirestore(String getQuizName, getQuizType, getQuizDescription,
      getQuizCategory) async {
    service.addDataToCreateaQuizFirestore(
        getQuizName, getQuizType, getQuizDescription, getQuizCategory);
    // clearInputs();
  }

  ///gets values from text boxes

  String? getQuizType() {
    return quizType;
  }

  String? getQuizCategory() {
    return quizCategory;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      ///write to database
      service.addDataToCreateaQuizFirestore(quizNameController.text,
          getQuizType(), quizDescriptionController.text, getQuizCategory());

      ///go to welcome page
      if (getQuizType() == 'Short-Answer') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShortAnswerQuestionPage()),
        );
      } else if (getQuizType() == 'Image-Based') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => imageBased()),
        );
      } else if (getQuizType() == 'Multiple Choice') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => mCQ_Question_Page()),
        );
      } else if (getQuizType() == 'Multiple Answer Quiz') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateMAQ()),
        );
      } else {
        _showDialog("Goes to " + getQuizType()! + " page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColourPallete.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
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
              child: Center(
                child: Column(children: <Widget>[
                  SizedBox(height: 50),
                  SizedBox(width: 150),
                  Text(
                    'Create a Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 600,

                      ///sets up text boxes
                      ///quiz name box
                      child: TextFormField(
                        controller: quizNameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(27),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.borderColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.gradient2,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Quiz Name',
                        ),
                        validator: validateName,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 600,

                      ///quiz description box
                      child: TextFormField(
                        controller: quizDescriptionController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(27),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.borderColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.gradient2,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Quiz Description',
                        ),
                        validator: validateDescription,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 600,

                      /// sets up dropdown box for quiz category
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(27),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.borderColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.gradient2,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText:
                              'Select Quiz Category', // updated hint text for combo box
                        ),
                        value: quizCategory,
                        items: <String>[
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
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 17),
                            ),
                          );
                        }).toList(), // replace with items for the combo box
                        onChanged: (value) {
                          setState(() {
                            quizCategory = value;
                          });
                          ;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Select Quiz Category";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 600,

                      /// sets up dropdown box for quiz type
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(27),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.borderColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColourPallete.gradient2,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText:
                              'Select Quiz Type', // updated hint text for combo box
                        ),

                        ///choices
                        value: quizType,
                        items: <String>[
                          'Multiple Choice',
                          'Image-Based',
                          'Short-Answer',
                          'Multiple Answer Quiz'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 17),
                            ),
                          );
                        }).toList(), // replace with items for the combo box
                        onChanged: (value) {
                          // handle onChanged event for combo box
                          setState(() {
                            quizType = value;
                          });
                          ;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Select Quiz Type";
                          }
                          return null;
                        }, // replace with default value for the combo box
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(395, 55),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ))));
  }

  ///validators for input
  String? validateName(String? value) {
    if (value == null || value == "") {
      return "Enter quiz name";
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value == "") {
      return "Enter quiz description";
    }
    return null;
  }

  void _showDialog(String message) {
    showDialog(
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
