import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../menu.dart';

class publishPage extends StatefulWidget {
  final List<String> questions;
  final List<String> answers;
  final int quizType;

  publishPage({required this.questions, required this.answers,required this.quizType});

  @override
  _publishPageState createState() => _publishPageState();
}

class _publishPageState extends State<publishPage> {
  final _formKey = GlobalKey<FormState>();
  bool isTimed = false;
  bool hasPrerequisites = false;
  int timeLimit = 0;
  final TextEditingController timeLimitController = TextEditingController();

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
    if(widget.quizType==1) {
      Map<String, dynamic> userData = {
        'Question': widget.questions[index].toString(),
        'Answers': widget.answers[index].toString(),
        'QuizID': await _getQuizID(),
        'Question_type': "Short Answer",
        'QuestionNo': index,
      };
      await users.doc(docRef.id).set(userData);
    }else if(widget.quizType==2){
      List <String> ans=widget.answers[index].split('^');
      String correctAns=ans[0];
      String rand1=ans[1];
      String rand2=ans[2];
      String rand3=ans[3];

      Map<String, dynamic> userData = {
        'Question': widget.questions[index].toString(),
        'Answers': correctAns,
        'Option1': rand1,
        'Option2': rand2,
        'Option3': rand3,
        'QuizID': await _getQuizID(),
        'Question_type': "MCQ",
        'QuestionNo': index,
      };

      await users.doc(docRef.id).set(userData);
    }

  }

  List<String> mcqDisplay(List<String> ans){

    List <String> output=[];
    for(int i=0;i<ans.length;i++){
      List <String> splitAnswers=ans[i].split('^');
      output.add('Correct option: ${splitAnswers[0]}\nRandom option: ${splitAnswers[1]}\nRandom option: ${splitAnswers[2]}\nRandom option: ${splitAnswers[3]}');
    }
    return output;
  }


  void addNumberOfQuestions(String quizID, int numQuestions,bool isTimed,int time) async {
    CollectionReference quizzesCollection =
    FirebaseFirestore.instance.collection('Quizzes');

    // Get the quiz document with the specified ID
    QuerySnapshot quizQuery =
    await quizzesCollection.where('Quiz_ID', isEqualTo: quizID).get();

    if (quizQuery.docs.length == 1) {
      // Update the number of questions for the quiz
      DocumentReference quizDocRef = quizQuery.docs[0].reference;
      await quizDocRef.update({'Number_of_questions': numQuestions,'QuizTimed':isTimed,'TimerTime':time});

      print('Successfully updated the number of questions for QuizID $quizID');
    } else {
      print('Error: Found ${quizQuery.docs.length} quizzes with QuizID $quizID');
    }
  }

  Future<void> _publish() async {

    if (_formKey.currentState!.validate()) {
      if(isTimed) {
        List<String> timeList = timeLimitController.text.split(":");
        String hour = timeList[0];
        String minute = timeList[1];

        setState(() {
          timeLimit = 60 * int.parse(hour) + int.parse(minute);
        });
      }
      addNumberOfQuestions(
          await _getQuizID(), widget.questions.length, isTimed, timeLimit);

      /// write to database
      for (int i = 0; i < widget.questions.length; i++) {
        addDataToFirestore(i);
      }
      updateQuizzesStattus();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz review"),
      ),
      body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.builder(
              itemCount: widget.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  color: index % 2 == 0 ? Colors.black54 : Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question ${index + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.questions[index],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Answer:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      if(widget.quizType==1)
                      Text(
                        widget.answers[index],
                      )
                      else if(widget.quizType==2)
                        Text(
                          mcqDisplay(widget.answers)[index],
                        )


                    ],

                  ),
                );
              },
            ),

          ),
          CheckboxListTile(
            title: Text("Timed quiz"),
            value: isTimed,
            onChanged: (newValue) {
              setState(() {
                isTimed = newValue!;
              });
            },
          ),

          if (isTimed)
            TextFormField(
              controller: timeLimitController,
              keyboardType: TextInputType.number,
              validator: validateTime,
              decoration: InputDecoration(
                labelText: "Time limit (in format min:sec)",
              ),

            ),
          CheckboxListTile(
            title: Text("Quiz has prerequisites"),
            value: hasPrerequisites,
            onChanged: (newValue) {
              setState(() {
                hasPrerequisites = newValue!;
              });
            },
          ),
          SizedBox(height: 16.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add your code to submit the quiz
                  },
                  child: Text("Edit questions"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _publish();

                  },
                  child: Text("Publish quiz"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
      ),

    );
  }
  String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an time limit';
    } else if(!value.contains(':')) {
      return 'Time limit in incorrect format';
    }else {
      List<String> timeList = value.split(":");
      String hour = timeList[0];
      String minute = timeList[1];
      if(hour.isEmpty||minute.isEmpty || hour.length>2 || minute.length>2) {
        return 'Time limit in incorrect format';
      }
      RegExp digitRegex = RegExp(r'^\d+$');
      if(!digitRegex.hasMatch(hour) && !digitRegex.hasMatch(minute)){
        return 'Time limit needs to be digits';
      }
      return null;
    }
  }
}
