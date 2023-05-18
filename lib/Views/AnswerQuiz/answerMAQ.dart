import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Database%20Services/database.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_website/menu.dart';

class AnswerMAQ extends StatefulWidget {
  AnswerMAQ(
      {Key? key,
      required this.quizID,
      required this.bTimed,
      required this.iTime})
      : super(key: key);
  String quizID;
  bool bTimed;
  int iTime;

  @override
  State<AnswerMAQ> createState() => _AnswerMAQState();
}

class _AnswerMAQState extends State<AnswerMAQ> {
  final _formKey = GlobalKey<FormState>();

  bool isSubmited = false;
  late String quizSelected;

  late bool isTimed;
  late int time;

  late ValueNotifier<int> timeRemaining = ValueNotifier<int>(0);
  late Timer timer = Timer(Duration.zero, () {});
  DatabaseService service = DatabaseService();

  void initState() {
    super.initState();
    quizSelected = widget.quizID;
    isTimed = widget.bTimed;
    time = widget.iTime;

    ///sets up timer if needed
    if (isTimed) {
      timeRemaining = ValueNotifier<int>(time);
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timeRemaining.value == 0) {
          timer.cancel();
          _submitAnswer();
        } else {
          timeRemaining.value--;
        }
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  final List<String> _question = [];
  final List<String> _potentialAnswers = [];

  //String question = "List the coms subjects";
  //List potentialAnswers = ["ML", "SD", "PC", "AAA"];
  //int expectedNo = 10;
  final TextEditingController answerController = TextEditingController();
  List<TextEditingController> listController = [TextEditingController()];

  String getScore() {
    String score = (listController.length - 1).toString();
    return score;
  }

  void _submitAnswer() {
    setState(() {
      _showDialog("Your Score: ${getScore()}");
      isSubmited = true;
      timer.cancel();
    });
  }

  ///loads the quiz question and answers for use throughout page
  Future<void> getQuestionsAnswers(String x) async {
    if (_question.isEmpty) {
      List<Map<String, dynamic>> questionsAnswersList =
          await service.getMAQQuestionsAnswers(x);
      _question.add(questionsAnswersList[0]["Question"][0]);
      for (int i = 0; i < questionsAnswersList[0]["Answers"].length; i++) {
        _potentialAnswers.add(questionsAnswersList[0]["Answers"][i]);
      }
      //print(questionsAnswersList[0]["Question"]);
      //print(_potentialAnswers);
    }
  }

  ///sets up the timer widget
  Widget _buildTimerWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: timeRemaining,
      builder: (BuildContext context, int value, Widget? child) {
        int minutes = (value / 60).floor();
        int seconds = value % 60;
        String formattedTime =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        return Text('Time remaining: $formattedTime');
      },
    );
  }

  ///validation checks
  String? validateAnswer(String? value) {
    //checks for no input
    if (isSubmited) {
      return 'Already submitted';
    }
    if (value == null || value.isEmpty) {
      return 'Please enter an answer';
    }
    //checks if answer was already added
    List<String> answers = [];
    for (int i = 0; i < listController.length; i++) {
      answers.add(listController[i].text);
      if (value.toLowerCase() == answers[i].toString().toLowerCase()) {
        return 'Answer already added';
      }
    }
    //checks if is part of potential answers
    bool x = false;
    for (int i = 0; i < _potentialAnswers.length; i++) {
      if (value.toLowerCase() ==
          _potentialAnswers[i].toString().toLowerCase()) {
        x = true;
        break;
      }
    }
    if (x == false) {
      return 'Incorrect answer. Please try again';
    } else {
      return null;
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Quiz Not Complete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to submit your quiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitAnswer();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answer Page'),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: FutureBuilder(
              future: getQuestionsAnswers(quizSelected),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      _question[0],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                    Center(
                        child: Text(
                      //"(Give ${expectedNo} possible answers)",
                      " ",
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Color.fromARGB(255, 198, 195, 195)),
                    )),
                    SizedBox(width: 16),

                    ///shows the timer widget if its a timed quiz
                    if (isTimed) _buildTimerWidget(),

                    SizedBox(height: 20),

                    ///question text box

                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              controller: answerController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: 'Enter your answer here',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 40, 148, 248))),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 216, 206, 206)),
                              ),
                              maxLines: 1,
                              validator: validateAnswer,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  listController.add(TextEditingController(
                                      text:
                                          ' ${listController.length}. ${answerController.text}'));
                                  answerController.clear();
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                //button adds more possible answers text box
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 40, 148, 248),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("Add Answer",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ]),
                    //possible answers text box
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listController.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(color: Colors.white),
                                    autocorrect: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: listController[index],
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      disabledBorder: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 40, 148, 248))),
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 216, 206, 206)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    //Textbox for number of answers expected when answering quiz

                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //if ((listController.length - 1) < expectedNo) {
                        //_showAlertDialog();
                        //} else {
                        _submitAnswer();
                        //}
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 40, 148, 248),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text('Submit Quiz',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 50),

                    if (isSubmited)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Table(
                                  border: TableBorder.all(color: Colors.green),
                                  columnWidths: {
                                    0: FixedColumnWidth(200.0)
                                  },
                                  children: [
                                    TableRow(children: [
                                      Text("Possible Answers:",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                    for (var item in _potentialAnswers)
                                      TableRow(children: [
                                        Text(" ${item}",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                            )),
                                      ])
                                  ]),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MenuPage(
                                            testFlag: false,
                                          )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 40, 148, 248),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text('Close',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ])
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

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
}