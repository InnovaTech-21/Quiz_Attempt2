import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Database%20Services/database.dart';

import 'package:quiz_website/Views/CreateQuiz/CreateShortAns.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateMCQ.dart';
import 'package:quiz_website/Views/CreateQuiz/createMAQ.dart';


class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => CreateQuizPageState();
}

class CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();

  ///set text controllers
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizDescriptionController =
      TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  String? username;
  String? quizType;
  String? quizCategory;

  PlatformFile? pickedFile1;
  String? _imageUrl = '';

  //selecting image
  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);
    String? abc = await _getQuizID();

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      // Upload file
      final storageRef = FirebaseStorage.instance.ref('$abc/$fileName');
      final uploadTask = storageRef.putData(fileBytes!);
      await uploadTask.whenComplete(() {});

      // Retrieve download URL
      final downloadURL = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = downloadURL; // Assign the download URL to _imageUrl
      });
    }
  }



  Future<String> _getQuizID() async {
    // get number of questions from databse
    DatabaseService service= DatabaseService();
    String quizID = "";
    final CollectionReference quizzesCollection =
        FirebaseFirestore.instance.collection('Quizzes');

    String? username = service.userID;
    QuerySnapshot questionsSnapshot = await quizzesCollection
        .where('Username', isEqualTo: username)
        .orderBy('Date_Created', descending: true)
        .limit(1)
        .get();

    if (questionsSnapshot.docs.isNotEmpty) {
      DocumentSnapshot mostRecentQuestion = questionsSnapshot.docs.first;
      quizID = mostRecentQuestion['Quiz_ID'].toString();
    }

    return quizID;
  }

  ///add data of quiz to be made to database
  void addDataToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uID = user.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("Users").doc(uID);
      userRef.get().then((doc) {
        if (doc.exists) {
        } else {}
      }).catchError((error) => print("Failed to get User"));
    } else {
      print("User Does not exist");
    }

   DatabaseService service=DatabaseService();

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
      'Number_of_questions': 0,
      'Username': service.userID,
      "Date_Created": Timestamp.fromDate(DateTime.now()),
      "Quiz_ID": docRef.id.toString(),
    };

    await users.doc(docRef.id).set(userData);
    clearInputs();
  }

  ///clears inputs when page is left
  void clearInputs() {
    quizNameController.clear();
    quizDescriptionController.clear();

    setState(() {
      quizType = null;
      quizCategory = null;
    });
  }

  ///gets values from text boxes




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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      ///write to database
      addDataToFirestore();

      ///go to welcome page

      if (getQuizType() == 'Short-Answer') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShortAnswerQuestionPage()),
        );
      }  else if (getQuizType() == 'Multiple Choice') {
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
