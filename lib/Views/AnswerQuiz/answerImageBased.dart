import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class imageBasedAnswers extends StatefulWidget {
  imageBasedAnswers(
      {Key? key,
      required this.quizID,
      required this.bTimed,
      required this.iTime})
      : super(key: key);
  String quizID;
  bool bTimed;
  int iTime;

  @override
  imageBasedAnswerState createState() => imageBasedAnswerState();
}

class imageBasedAnswerState extends State<imageBasedAnswers> {
  String? selectedOption;
  bool showResult = false;

  void checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Quiz'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Quizzes')
                .doc(widget.quizID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data?.data() == null) {
                return Text('No quiz data available.');
              }

              final quizData = snapshot.data!.data()! as Map<String, dynamic>;
              final numQuestions = quizData['Number_of_questions'] as int;

              return Column(
                children: [
                  Text(
                    'Question 1 of $numQuestions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Questions')
                        .where('Quiz_ID', isEqualTo: widget.quizID)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData ||
                          snapshot.data?.docs.isEmpty == true) {
                        return Text('No questions available for this quiz.');
                      }

                      final questions = snapshot.data!.docs;
                      final currentQuestion = questions[0];
                      final questionData =
                          currentQuestion.data() as Map<String, dynamic>;
                      final questionText = questionData['Question'] as String?;
                      final option1 = questionData['Option1'] as String?;
                      final option2 = questionData['Option2'] as String?;
                      final option3 = questionData['Option3'] as String?;
                      final option4 = questionData['Option4'] as String?;
                      final option5 = questionData['Option5'] as String?;
                      final correctAnswer = questionData['Answer'] as String?;

                      return Column(
                        children: [
                          Text(
                            questionText!,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: [
                              buildOptionWidget(option1!),
                              buildOptionWidget(option2!),
                              buildOptionWidget(option3!),
                              buildOptionWidget(option4!),
                              buildOptionWidget(option5!),
                            ],
                          ),
                          SizedBox(height: 20),
                          showResult
                              ? Text(
                                  selectedOption == correctAnswer
                                      ? 'Correct!'
                                      : 'Incorrect!',
                                  style: TextStyle(fontSize: 18),
                                )
                              : Container(),
                          ElevatedButton(
                            onPressed: () {
                              checkAnswer(selectedOption!);
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildOptionWidget(String imageUrl) {
    return GestureDetector(
      onTap: () {
        if (!showResult) {
          setState(() {
            selectedOption = imageUrl;
          });
        }
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Image.network(imageUrl),
        ),
        color: selectedOption == imageUrl ? Colors.blue : Colors.white,
      ),
    );
  }
}
