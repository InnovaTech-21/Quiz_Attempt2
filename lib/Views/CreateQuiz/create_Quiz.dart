import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

import 'package:quiz_website/Views/CreateQuiz/CreateShortAns.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateMCQ.dart';
import 'package:quiz_website/Views/CreateQuiz/imageBased.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();

  ///set text controllers
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController =
      TextEditingController();
  final TextEditingController numQuestionsController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String? username;
  String? quizType;
  String? quizCategory;

  ///add data to database
  void addDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uID = user.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("Users").doc(uID);
      userRef.get().then((doc) {
        if (doc.exists) {
          String username = "username";
          Object? y = doc.data();
          //     nameuser = y["username"]?.toString();
        } else {
          print('User Not Found');
        }
      }).catchError((error) => print("Failed to get User"));
    } else {
      print("User Does not exsist");
    }

    ///create a user with email and password
    String? nameuser = await getUser();
    print(nameuser);
    String? str;

    getUser().then((result) {
      str = result;
    });

    ///Create quizzes created successfully, now add data to Firestore
    CollectionReference users =
        FirebaseFirestore.instance.collection('Quizzes');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Status': 'Pending',
      'QuizName': getQuizName(),
      'Quiz_Type': getQuizType(),
      'Quiz_Description': getQuizDescription(),
      'Quiz_Category': getQuizCategory(),
      'Number_of_questions': getNumberofQuestions(),
      'Username': nameuser,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "Quiz_ID": docRef.id.toString(),
    };

    await users.doc(docRef.id).set(userData);
    clearInputs();
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

  ///clears inputs when page is left
  void clearInputs() {
    quizNameController.clear();
    quizDescriptionController.clear();
    numQuestionsController.clear();
    setState(() {
      quizType = null;
      quizCategory = null;
    });
  }

  ///gets values from text boxes
  Future<String?> getUsername() async {
    return await getUser();
  }

  void setUsername(String username1) {
    username = username1;
  }

  String? getQuizType() {
    return quizType;
  }

  String? getQuizCategory() {
    return quizCategory;
  }

  String getQuizName() {
    return quizNameController.text;
  }

  String getQuizDescription() {
    return quizDescriptionController.text;
  }

  int getNumberofQuestions() {
    return int.parse(numQuestionsController.text);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      ///write to database
      addDataToFirestore();

      ///go to welcome page
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Menu())); chnage page once next page is created
      //Navigator.of(context).pushReplacement(MaterialPageRoute(
      //builder: (context) =>
      //ImageBased())); //chnage page once next page is created
      if (getQuizType() == 'Short-Answer') {
        int num= int.parse(numQuestionsController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  ShortAnswerQuestionPage(numQuest: num)),
        );
      } else if (getQuizType() == 'Image-Based') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const imageBased()),
        );
      } else if (getQuizType() == 'Multiple Choice') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const mCQ_Question_Page()),
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
                        items: <String>['Kdrama', 'Anime', 'Kpop']
                            .map<DropdownMenuItem<String>>((String value) {
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
                          'Short-Answer'
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 600,

                      ///text box for number of questions
                      child: TextFormField(
                        controller: numQuestionsController,
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
                          hintText: 'Enter Number of Questions',
                        ),
                        validator: validateNumber,
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

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter number of questions";
    } else {
      if (double.tryParse(value) == null) {
        return "Number must be a digit";
      } else {
        int numValue = int.parse(value);
        if (numValue < 2 || numValue > 20) {
          return "Number of questions should be between 2 and 20";
        }
      }
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
