import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../menu.dart';
import '../../Database Services/database.dart';

class publishPage extends StatefulWidget {
  final List<String> questions;
  final List<String> answers;
  final int quizType;
  List<Map<String, String>> quiz = [];



  publishPage({required this.questions, required this.answers,required this.quizType});

  @override
  _publishPageState createState() => _publishPageState();
}

class _publishPageState extends State<publishPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _QuizDetails = [];
  final List<String> _QuizName = [];
  final List<String> _QuizID = [];


  bool isTimed = false;
  bool translate = false;
  bool hasPrerequisites = false;
  int timeLimit = 0;
  String ID="none";
  String quizID='';
  String sLang='English';
  final TextEditingController timeLimitController = TextEditingController();
  List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Arabic'];

  int type=0;
  List<String> _questions = [];
  List<String> _ans = [];

  @override
  ///sets up page to load the selected quiz
  void initState() {
    super.initState();
    type=widget.quizType;
    _questions=widget.questions;
    _ans=widget.answers;

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
  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final apikey = 'Your Api key';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
        'Accept': 'application/json', // Add this line
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 1000,
      }),
    );

    return jsonDecode(utf8.decode(response.bodyBytes)); // Decode response using utf8.decode
  }


  Future<Map<String, dynamic>> translatequizquestions(String Language) async {
    List<String> Quest = _questions;
    List<String> Answ = _ans;
    print(Quest);
    print(Answ);

    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(
        'i am going to give you a list of questions and their respective answers in the format[question 1, '
            'question 2, question n] [answer 1, answer 2, answer n]i want you to translate all of them into '
            '[$Language] and return them in the same order and layout that i gave the prompt in.these '
            'are the list:[$Quest][$Answ]')));

    print(response);
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;

        // Extract translated questions
        final questionsStartIndex = content.indexOf('[');
        final questionsEndIndex = content.indexOf(']');
        final translatedQuestions = content.substring(questionsStartIndex + 1, questionsEndIndex).split(', ');
        print(translatedQuestions);

        // Extract translated answers
        final answersStartIndex = content.lastIndexOf('[');
        final answersEndIndex = content.lastIndexOf(']');
        final translatedAnswers = content.substring(answersStartIndex + 1, answersEndIndex).split(', ');
        print(translatedAnswers);

        // Create a map of translated questions and answers
        Map<String, dynamic> translatedQuiz = {
          'questions': translatedQuestions,
          'answers': translatedAnswers,
        };

        setState(() {
          _questions = translatedQuestions;
          _ans = translatedAnswers;
        });

        return translatedQuiz;
      }
    }

    // Return an empty map if translation fails
    return {};
  }


  Future<void> getQuizInformation(String x,DatabaseService service) async {
    List<Map<String, dynamic>> questionsAnswersList = await service.getQuizInformation(x);
    for (var i = 0; i < questionsAnswersList.length; i++) {
      _QuizDetails.add("Quiz Name: "+questionsAnswersList[i]["QuizName"]);
      _QuizID.add(questionsAnswersList[i]["Quiz_ID"]);
      _QuizName.add(questionsAnswersList[i]["QuizName"]);

    }
    quizID=await service.getQuizID();
  }
  void addDataToFirestore(int index) async {
    ///Create quizzes created successfully, now add data to Firestore

    CollectionReference users =
    FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    if (type == 1) {
      Map<String, dynamic> userData = {
        'Question': _questions[index].toString(),
        'Answers': _ans[index].toString(),
        'QuizID': quizID,
        'Question_type': "Short Answer",
        'QuestionNo': index,
      };
      await users.doc(docRef.id).set(userData);
    } else if (type == 2) {
      List<String> ans = _ans[index].split('^');
      String correctAns = ans[0];
      String rand1 = ans[1];
      String rand2 = ans[2];
      String rand3 = ans[3];

      Map<String, dynamic> userData = {
        'Question': _questions[index].toString(),
        'Answers': correctAns,
        'Option1': rand1,
        'Option2': rand2,
        'Option3': rand3,
        'QuizID': quizID,
        'Question_type': "MCQ",
        'QuestionNo': index,
      };

      await users.doc(docRef.id).set(userData);
    } else if (type == 3) {
      Map<String, dynamic> userData = {
        'Answers': _ans,
        'QuizID': quizID,
        'Question': _questions,
        //'Number Expected': expected,
        'Question_type': 'Multiple Answer Quiz',
        'QuestionNo': 1,
      };
      await users.doc(docRef.id).set(userData);
    }

  }

  List<String> mcqDisplay(List<String> ans) {
    List<String> output = [];
    for (int i = 0; i < ans.length; i++) {
      List<String> splitAnswers = ans[i].split('^');
      output.add(
          'Correct option: ${splitAnswers[0]}\nRandom option: ${splitAnswers[1]}\nRandom option: ${splitAnswers[2]}\nRandom option: ${splitAnswers[3]}');
    }
    return output;
  }

  String maqDisplay(List<String> ans) {
    String output = '';
    for (int i = 0; i < ans.length; i++) {
      output = output + ('${ans[i]}\n');
    }
    return output;
  }


  void addExtraDetails(String quizID, int numQuestions,bool isTimed,int time, String ID,DatabaseService service) async {
    service.addNumberOfQuestions(quizID, numQuestions, isTimed, time,ID);
  }

  Future<void> _publish() async {
    if (_formKey.currentState!.validate()) {
      DatabaseService service = DatabaseService();
      String x = 'All';
      await getQuizInformation(x,service);


      if(isTimed) {
        List<String> timeList = timeLimitController.text.split(":");
        String hour = timeList[0];
        String minute = timeList[1];

        setState(() {
          timeLimit = 60 * int.parse(hour) + int.parse(minute);
        });
      }
      if(hasPrerequisites){
        if(ID=="none"){
          _showDialog("Please select a prerequisite quiz");
          return;
        }
      }
      addExtraDetails(
          quizID, _questions.length, isTimed, timeLimit,ID,service);

      /// write to database
      for (int i = 0; i < _questions.length; i++) {
        addDataToFirestore(i);
      }
      service.updateQuizzesStattus();
      _showDialog("Quiz Created");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage(testFlag: false,)),
      );
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
                itemCount: _questions.length,
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
                          _questions[index],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Answer:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        if (type == 1)
                          Text(
                            _ans[index],
                          )
                        else if (type == 2)
                          Text(
                            mcqDisplay(_ans)[index],
                          )
                        else if (type == 3)
                            Text(
                              maqDisplay(_ans),
                            )
                      ],
                    ),
                  );
                },
              ),
            ),
            CheckboxListTile(
              title: Text("Tranlate the quiz to another language"),
              value: translate,
              onChanged: (newValue) {
                setState(() {
                  translate = newValue!;
                });
              },
            ),
            if (translate)
              DropdownButton<String>(
                value: sLang,
                onChanged: (String? newLang) {
                  setState(() {
                    sLang = newLang!;
                  });
                  translatequizquestions(sLang);
                },
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
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
              onChanged: (newValue) async {
                DatabaseService service = DatabaseService();
                await getQuizInformation("All",service);
                setState(() {
                  hasPrerequisites = newValue!;
                });
              },
            ),
            if (hasPrerequisites)
              SizedBox(
                height: 200, // Set a fixed height
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _QuizDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(_QuizDetails[index]),
                      onTap: () {
                        ID=_QuizID[index];
                        _showDialog("Quiz prerequisite set to: "+_QuizName[index]);
                        // Handle quiz selection here
                      },
                    );
                  },
                ),
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
      return 'Enter a time limit';
    } else if(!value.contains(':')) {
      return 'Time limit in incorrect format';
    }else {
      final timeRegex = r'^([0-9]?[0-9]):[0-5][0-9]$';
      final RegExp regex = RegExp(timeRegex);
      if(!regex.hasMatch(value)){
        return 'Time limit must be digits';
      }
      return null;
    }
  }
}
