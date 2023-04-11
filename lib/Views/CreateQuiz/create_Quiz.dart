
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController quiznamecontroller = TextEditingController();
  final TextEditingController quizcategorycontroller = TextEditingController();
  final TextEditingController quizdescriptioncontroller = TextEditingController();
  final TextEditingController quizquestiontypecontroller= TextEditingController();
  final TextEditingController numquestionscontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  String? username;
  String? quiztype;
  String? quizDescription;

  void addDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String nameuser ='';
    if(user != null){
      String uID = user.uid;
      DocumentReference userRef = FirebaseFirestore.instance.collection("Users").doc(uID);
     // userRef.get().then((doc) => null)
      userRef.get().then((doc) {
        if (doc.exists) {
     //     String y = doc.data()!['username'] as String ;
        }
        else {
          print('User Not Found');
        }
      }).catchError((error) => print("Failed to get User"));

      }
    else{
      print("User Does not exsist");
    }
    ///create a user with email and password

    ///Create quizzes created successfully, now add data to Firestore
    CollectionReference users = FirebaseFirestore.instance.collection('Quizzes');
    DocumentReference docRef = users.doc();
    String docID =docRef.id;
    Map<String, dynamic> userData = {
      'Status': 'Pending',
    'QuizName': getQuizName(),
    'Quiz_Type':getQuizType(),
    'Quiz_Description':getQuizDescription(),
    'Quiz_Category': getQuizCategory(),
    'Number_of_questions':getNumberofQuestions(), 
      'Username': nameuser,
    };

    await users.doc(docRef.id).set(userData);
    clearInputs();

  }
  void clearInputs() {
    quiznamecontroller.clear();
    quizcategorycontroller.clear();
    quizdescriptioncontroller.clear();
    numquestionscontroller.clear();
    quizquestiontypecontroller.clear();
  }
  void setUsername(String username1) {
   username = username1;
  }
  void setQuizType(String QuizType){
    quiztype =QuizType;
  }
  void setQuizDes(String QuizDescr){
    quizDescription =QuizDescr;
  }

  String? getUsername() {
    return username;
  }
  String getQuizName() {
    return quiznamecontroller.text;
  }

  String? getQuizType() {
    return quiztype;
  }

  String getQuizDescription() {
    return quizdescriptioncontroller.text;
  }

  String? getQuizCategory() {
    return quizDescription ;

  }

  int getNumberofQuestions() {
     return int.parse(numquestionscontroller.text);
  }
  Future<void> _submit() async {
   // if (_formKey.currentState!.validate() && check) { KImmentha u need to add validation
      ///write to database
      addDataToFirestore();

      _showDialog("Account created");

      ///go to welcome page
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Menu())); chnage page once next page is created

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
            child: Center(
              child: Column(
                  children: <Widget>[
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
                        ///Username box
                        child: TextFormField(
                          controller: quiznamecontroller,
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
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,

                        ///sets up text boxes
                        ///Username box
                        child: TextFormField(
                          controller: quizdescriptioncontroller,
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
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,
                        // sets up combo box
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
                            hintText: 'Select Quiz Category', // updated hint text for combo box
                          ),
                          items:<String>['Kdrama', 'Anime', 'Kpop']
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
                            // handle onChanged event for combo box
                            setQuizType(value.toString());
                          },
                          value: null, // replace with default value for the combo box
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,
                        // sets up combo box
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
                            hintText: 'Select Quiz Type', // updated hint text for combo box
                          ),
                          items: <String>['Multiple Choice', 'Image-Based', 'Short-Answer']
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
                            // handle onChanged event for combo box
                          setQuizDes(value.toString());
                          },
                          value: null, // replace with default value for the combo box
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,

                        ///sets up text boxes
                        ///Username box
                        child: TextFormField(
                          controller: numquestionscontroller,
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
                        onPressed: ()  {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //
                          //       builder: (context) => const CreateQuiz()),
                          // );
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
        )));
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
