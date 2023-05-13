import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_website/Views/CreateQuiz/publishPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../menu.dart';

class imageBased extends StatefulWidget {
  const imageBased({Key? key});

  @override
  _imageBasedState createState() => _imageBasedState();
}

class _imageBasedState extends State<imageBased> {
  String? _imageUrl = '';
  PlatformFile? pickedFile1;
  PlatformFile? pickedFile2;
  PlatformFile? pickedFile3;
  PlatformFile? pickedFile4;
  PlatformFile? pickedFile5;
  PlatformFile? pickedFile6;
  List<String> imageUrls = [];

  final TextEditingController questionController = TextEditingController();

  List<String> quests = [];
  List<String> answers = [];

  int currentQuestionIndex = 0;
  List<Question> questions = [];

  Future selectFile(int buttonIndex) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    String? abc = await _getQuizID();

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final fileBytes = pickedFile.bytes;
      final fileName = pickedFile.name;

      // Upload file
      final storageRef =
          FirebaseStorage.instance.ref('$abc/$currentQuestionIndex/$fileName');
      final uploadTask = storageRef.putData(fileBytes!);
      await uploadTask.whenComplete(() {});

      // Retrieve download URL
      final downloadURL = await storageRef.getDownloadURL();

      setState(() {
        if (buttonIndex == 1) {
          pickedFile1 = pickedFile;
        } else if (buttonIndex == 2) {
          pickedFile2 = pickedFile;
        } else if (buttonIndex == 3) {
          pickedFile3 = pickedFile;
        } else if (buttonIndex == 4) {
          pickedFile4 = pickedFile;
        } else if (buttonIndex == 5) {
          pickedFile5 = pickedFile;
        } else if (buttonIndex == 6) {
          pickedFile6 = pickedFile;
        }
        imageUrls.add(downloadURL); // Assign the download URL to _imageUrl
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

  void addDataToFirestore(int index) async {
    ///Create quizzes created successfully, now add data to Firestore
    ///
    CollectionReference users =
        FirebaseFirestore.instance.collection('Questions');
    DocumentReference docRef = users.doc();
    String docID = docRef.id;
    Map<String, dynamic> userData = {
      'Question': questionController.text,
      'Answer': imageUrls[0],
      'Option1': imageUrls[1],
      'Option2': imageUrls[2],
      'Option3': imageUrls[3],
      'Option4': imageUrls[4],
      'Option5': imageUrls[5],
      'QuizID': await _getQuizID(),
      'Question_type': "Image-Based",
      'QuestionNo': index,
    };

    await users.doc(docRef.id).set(userData);
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
                                          selectFile(1);
                                          //_pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile1 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile1!.bytes!,
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
                                          selectFile(2);
                                          //_pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile2 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile2!.bytes!,
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
                                          selectFile(3);
                                          //_pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile3 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile3!.bytes!,
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
                                          selectFile(4);
                                          //_pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile4 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile4!.bytes!,
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
                                          selectFile(5);
                                          //_pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile5 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile5!.bytes!,
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
                                          selectFile(6);
                                          //_pickImage(ImageSource.camera);
                                        },
                                        child: const Icon(
                                            Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (pickedFile6 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.memory(
                                          pickedFile6!.bytes!,
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
                                //addDataToFirestore(currentQuestionIndex);
                                //updateQuizzesStattus();
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
                                //addDataToFirestore(currentQuestionIndex);
                                //Navigator.push(
                                //  context,
                                //  MaterialPageRoute(
                                //    builder: (context) => publishPage(
                                //        questions: quests,
                                //        answers: answers,
                                //        quizType: 3),
                                //  ),
                                //);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Publish',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ),
                        ),
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

///QUESTION CLASS
class Question {
  String question;
  String answer;
  String randoption1;
  String randoption2;
  String randoption3;
  String randoption4;
  String randoption5;

  Question(
      {required this.question,
      required this.answer,
      required this.randoption1,
      required this.randoption2,
      required this.randoption3,
      required this.randoption4,
      required this.randoption5});
}
