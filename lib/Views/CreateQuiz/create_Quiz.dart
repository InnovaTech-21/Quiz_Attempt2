import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateShortAns.dart';
import 'package:quiz_website/Views/CreateQuiz/CreateMCQ.dart';
import 'package:quiz_website/Views/CreateQuiz/createMAQ.dart';
import 'package:quiz_website/Views/CreateQuiz/publishPage.dart';
import '../../Database Services/database.dart';
//import 'package:http/browser_client.dart' as http_browser;
import 'package:firebase_storage/firebase_storage.dart' as storage;

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
  final TextEditingController numberOfQuestionsController = TextEditingController();


  final TextEditingController usernameController = TextEditingController();
  String? username;
  String? quizType;
  String? quizCategory;
  bool?  createQuiz = false;
  List<Map<String, String>> quiz = [];
  List<String> questions = [];
  List<String> answers = [];

  PlatformFile? pickedFile1;
  String? _imageUrl = '';
  String selectedImagePath = '';
  //Uint8List? _imageBytes;
  //http_browser.BrowserClient _httpClient = http_browser.BrowserClient();

  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';
    final apikey = 'Your Api Key';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
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

    // print(response.body);
    return jsonDecode(response.body);
  }


  Future<Map<String, dynamic>> generateQuizQuestions(
      String quizName, String quizDescription, String quizType, String NumofQuestions) async {
    int numberOfQuestions = 5;{}
    if (quizType == "Short-ANswer"){
      final response = await sendChatGPTRequest(
          'i want you to give me questions and answers to a quiz of a topic of my choice. your response must be in the form Question: [the question] newline Answer:[the answer] newline and so on. Do not say anything else except for the questions and answers in this format. the topic of the quiz is [$quizName] and there must be [$NumofQuestions] questions');

      // Process the API response and extract the generated questions and answers
      final choices = response['choices'];
      if (choices != null && choices.isNotEmpty) {
        final completion = choices[0];
        final message = completion['message'];
        if (message != null && message['content'] != null) {
          final content = message['content'] as String;
          final questionsAndAnswers = content.split('\n\n');
          for (final qa in questionsAndAnswers) {
            final parts = qa.split('\nAnswer: ');
            if (parts.length == 2) {
              String question = parts[0].trim().replaceAll('Question: ', '').toString();
              questions.add(question);
              String answer = parts[1].trim().replaceAll('Answer: ', '').toString();
              answers.add(answer);
              quiz.add({'question': question, 'answer': answer});
            }
          }
        }
      }
    }
    else if (quizType == "Multiple Choice Questions"){
      final response = await sendChatGPTRequest('i want you to give me questions and answers to a multiple choice quiz of a topic of my choice. your response must be in the form Question: [the question] newline Answer:[the correct answer, incorrect option, incorrect option, incorrect option] newline and so on. Do not say anything else except for the questions and answers in this format. the topic of the quiz is [$quizName] and there must be [$NumofQuestions] questions');
      // Process the API response and extract the generated questions and answers
      final choices = response['choices'];
      if (choices != null && choices.isNotEmpty) {
        final completion = choices[0];
        final message = completion['message'];
        if (message != null && message['content'] != null) {
          final content = message['content'] as String;
          //print (content);
          final questionsAndAnswers = content.split('\n\n');
          for (final qa in questionsAndAnswers) {
            final parts = qa.split('\nAnswer: ');
            if (parts.length == 2) {
              String question = parts[0].trim().replaceAll('Question: ', '');
              questions.add(question);
              print(question);
              String answerString = parts[1].trim().replaceAll('Answer: ', '');
              print(answerString);
              List<String> answerOptions = answerString.split(', ');
              print(answerOptions);
              // answers.add(answerOptions[0]);
              //answers.add(answerOptions[1]);
              //answers.add(answerOptions[2]);
              //answers.add(answerOptions[3]);
              answers.add(answerOptions[0]+ '^' + answerOptions[1] + '^' + answerOptions[2] + '^' + answerOptions[3]);

              quiz.add({
                'question': question,
                'answers': answerOptions[0],
                'correctAnswer': answerOptions[0], // Assuming the first option is always the correct answer
              });
            }
          }
        }
      }
      print(answers);

// Print the extracted questions and answers


// Access the generated quiz as a list of maps
//print('Quiz: $quiz');
    }
    else {
      final response = await sendChatGPTRequest(
          'i want you to give me questions and answers to a multiple answer quiz of a topic of my choice. your response must be in the form Question: [the question] newline Answer:[the correct answer 1, correct answer 2, , correct answer 3, correct answer 4, … correct answer n] newline and so on. Do not say anything else except for the questions and answers in this format. the topic of the quiz is [$quizName] and there must be [1] questions');



// Process the API response and extract the generated questions and answers
      final choices = response['choices'];
      if (choices != null && choices.isNotEmpty) {
        final completion = choices[0];
        final message = completion['message'];
        if (message != null && message['content'] != null) {
          final content = message['content'] as String;
          final questionsAndAnswers = content.split('\n\n');
          for (final qa in questionsAndAnswers) {
            final parts = qa.split('\nAnswer: ');
            if (parts.length == 2) {
              String question = parts[0].trim().replaceAll('Question: ', '');
              questions.add(question);

              String answerString = parts[1].trim().replaceAll('Answer: ', '');
              List<String> answerOptions = answerString.split(', ');
              for (int i =0 ; i < answerOptions.length;i++){
                answers.add(answerOptions[i]);
              }

              quiz.add({
                'question': question,
                'answers': answerOptions[0],
              });
            }
          }
        }
      }

// Print the extracted questions and answers
      for (int i = 0; i < questions.length; i++) {
        print('Question: ${questions[i]}');
        print('Answers: ${answers[i]}');
      }

// Access the generated quiz as a list of maps
      print('Quiz: $quiz');

    }

    return {'quiz': quiz, 'questions': questions, 'answers': answers};
  }


  //selecting image
  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    String? abc = await service.getUser();
    String? def = quizNameController.text;

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final fileName = pickedFile.name;
      final fileBytes = pickedFile.bytes; // Use bytes property instead of path

      // Upload file
      final storageRef =
      storage.FirebaseStorage.instance.ref('$abc/$def/$fileName');
      final uploadTask = storageRef.putData(fileBytes!);
      await uploadTask.whenComplete(() {});

      // Retrieve download URL
      final downloadURL = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = downloadURL; // Assign the download URL to _imageUrl
      });
    }
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

  void showImageSelectedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Image'),
          content: Text('Image Selected.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  ///add data of quiz to be made to database
  void addDataToFirestore(String getQuizName, getQuizType, getQuizDescription,
      getQuizCategory) async {
    service.addDataToCreateaQuizFirestore(getQuizName, getQuizType,
        getQuizDescription, getQuizCategory, selectedImagePath);
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
      service.addDataToCreateaQuizFirestore(
          quizNameController.text,
          getQuizType(),
          quizDescriptionController.text,
          getQuizCategory(),
          selectedImagePath);

      ///go to welcome page
      if (createQuiz == false){
        if (getQuizType() == 'Short-Answer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShortAnswerQuestionPage()),
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
      else{
        if (getQuizType() == 'Short-Answer') {
          print ("1");

          Map<String, dynamic> quizData =  await generateQuizQuestions(quizNameController.text, quizDescriptionController.text,"Short-ANswer",numberOfQuestionsController.text);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => publishPage(questions: questions, answers: answers, quizType: 1)),
          );
        } else if (getQuizType() == 'Multiple Choice') {
          Map<String, dynamic> quizData =  await generateQuizQuestions(quizNameController.text, quizDescriptionController.text,"Multiple Choice Questions",numberOfQuestionsController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => publishPage(questions: questions, answers: answers, quizType: 2)),

          );
        } else if (getQuizType() == 'Multiple Answer Quiz') {
          Map<String, dynamic> quizData =  await generateQuizQuestions(quizNameController.text, quizDescriptionController.text,"Multiple Answer Quiz",numberOfQuestionsController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => publishPage(questions: questions, answers: answers, quizType: 3)),

          );
        } else {
          _showDialog("Goes to " + getQuizType()! + " page");
        }

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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Center(
                            child: CheckboxListTile(
                              title: Text(
                                'Make Chatgpt Create a Quiz',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: createQuiz,
                              onChanged: (value) {
                                setState(() {
                                  createQuiz = value;
                                });


                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          if (createQuiz!)

                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 600,

                                ///quiz description box
                                child: TextFormField(
                                  controller: numberOfQuestionsController,
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
                                  validator: validateDescription,
                                ),
                              ),
                            ),

                          const SizedBox(height: 30),
                          Text(
                            'Select image for quiz:',
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/InnovaTechLogo.png';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/InnovaTechLogo.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/logoin.jpg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/logoin.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/6fc2a718258c73a88c371b1de8d9c1f6.jpg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/6fc2a718258c73a88c371b1de8d9c1f6.jpg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/images.jpeg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/images.jpeg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/103205-fairy-tail-background-1920x1080-samsung.jpg';

                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/103205-fairy-tail-background-1920x1080-samsung.jpg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/971601.jpg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/971601.jpg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/wp6477079-minimal-star-wars-wallpapers.jpg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/wp6477079-minimal-star-wars-wallpapers.jpg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showImageSelectedDialog();
                                          selectedImagePath =
                                          'assets/images/Mc5aAdn.jpg';
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/Mc5aAdn.jpg',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
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
