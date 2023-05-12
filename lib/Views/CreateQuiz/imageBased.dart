import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../menu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

//final storage = firebase_storage.FirebaseStorage.instance;
//final firestore = FirebaseFirestore.instance;

class imageBased extends StatefulWidget {
  const imageBased({Key? key});

  @override
  _imageBasedState createState() => _imageBasedState();
}

class _imageBasedState extends State<imageBased> {
  PlatformFile? pickedFile1;
  PlatformFile? pickedFile2;
  PlatformFile? pickedFile3;
  PlatformFile? pickedFile4;
  PlatformFile? pickedFile5;
  PlatformFile? pickedFile6;

  String? _imageUrl = '';

  Future<void> uploadFile2() async {
    if (_imageFile1 == null) {
      // no image selected
      return;
    }

    // create a reference to the file in Firebase Storage
    final path = 'files/${_imageFile1!.path}';
    final ref = FirebaseStorage.instance.ref().child(path);

    // upload the file to Firebase Storage
    try {
      await ref.putFile(_imageFile1!);
      final url = await ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
    } catch (e) {
      // handle the error
      print('Error uploading file: $e');
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);
    String? abc = await _getQuizID();

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;
      String x = result.files.first.name;

      // upload file
      await FirebaseStorage.instance.ref('$abc/$fileName').putData(fileBytes!);
    }
  }

  Future uploadFile() async {
    final path = 'files/${_imageFile1!.path}';
    final file = File(_imageFile1!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    setState(() {
      _imageUrl = url;
    });
  }

  final TextEditingController questionController = TextEditingController();

  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;
  File? _imageFile5;
  File? _imageFile6;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (_imageFile1 == null) {
          _imageFile1 = File(pickedFile.path);
        } else if (_imageFile2 == null) {
          _imageFile2 = File(pickedFile.path);
        } else if (_imageFile3 == null) {
          _imageFile3 = File(pickedFile.path);
        } else if (_imageFile4 == null) {
          _imageFile4 = File(pickedFile.path);
        } else if (_imageFile5 == null) {
          _imageFile5 = File(pickedFile.path);
        } else if (_imageFile6 == null) {
          _imageFile6 = File(pickedFile.path);
        }
      });
    }
  }

  ///change this to get number of questions from database
  int numberOfQuestions = 5;
  int currentQuestionIndex = 0;

  ///list of question class
 // List<Question> questions = [];
  int? numberofQuestions = 0;

  ///controllers to get the values from the text boxes
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> correctanswerControllers = [];
  List<TextEditingController> randomAnswerControllers1 = [];
  List<TextEditingController> randomAnswerControllers2 = [];
  List<TextEditingController> randomAnswerControllers3 = [];
  List<TextEditingController> randomAnswerControllers4 = [];
  List<TextEditingController> randomAnswerControllers5 = [];

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

  Future<int> _getNumberOfQuestions() async {
    // get number of questions from databse
    int numberOfQuestions = 0;
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
        numberOfQuestions = mostRecentQuestion['Number_of_questions'];
      }
    }
    numberofQuestions = numberOfQuestions;
    return numberOfQuestions;
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
          MaterialPageRoute(builder: (context) => const MenuPage(testFlag: false,)),
        );
      }
    }).catchError((error) {
      _showDialog("Error creating quiz");
    });
  }

  void addDataToFirestore(int index, File _imageFile1) async {
    ///Create quizzes created successfully, now add data to Firestore
    ///
    CollectionReference users =
    FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Question': questionController.text,
      //'Answers': Image1url;
     // 'Option1': image2url,
      //'Option2':image3url,

      'QuestionNo': index,
      //"URL": imageUrl,
    };

    await users.doc(docRef.id).set(userData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: 500, // set the maximum width here
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    const SizedBox(width: 150),
                    Text(
                      'Image-Based Quiz',
                      style: const TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Enter quiz question here:',
                          style: const TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: questionController,
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
                            hintText: 'E.g. Select the Fairytale related image',
                          ),
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a question ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        Text(
                          'Upload images for question below\n(1st image being the correct image)',
                          style: const TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 50),
                        if (pickedFile1 != null)
                        //Expanded(
                       // child: Container(
                        //  color: Colors.blue[100],
                       // child: Center(
                       //   child: Image.file(File(pickedFile1!.path!),
                        //   width: double.infinity,
                       //   fit: BoxFit.cover))),
                      // ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          child: const Text("Select File"),
                          onPressed: selectFile,

                        ),
                        //if (pickedFile1 != null)
                        //Positioned(
                        //top: 0,
                        //bottom: 0,
                        //left: 0,
                        //right: 0,
                        //child: Image.network(
                        //pickedFile1!.path!,
                        //fit: BoxFit.cover,
                        //),
                        //),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image1",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile1 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image2",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile2 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile2!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image3",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile3 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile3!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image4",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile4 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile4!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image5",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile5 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile5!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FloatingActionButton(
                                        heroTag: "image6",
                                        onPressed: () {
                                          selectFile();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile6 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile6!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          height: 65,
                          width: 450,
                          child: DecoratedBox(
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
                                ///addDataToFirestore(currentQuestionIndex, _imageFile1);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const CreateQuizPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
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
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                )),
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