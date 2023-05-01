import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';

class imageBased extends StatefulWidget {
  const imageBased({Key? key, required int numQuest});

  @override
  _imageBasedState createState() => _imageBasedState();
}

class _imageBasedState extends State<imageBased> {
  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;
  File? _imageFile5;
  File? _imageFile6;
  final _picker = ImagePicker();
  String? _imageUrl1;
  String? _imageUrl2;
  String? _imageUrl3;
  String? _imageUrl4;
  String? _imageUrl5;
  String? _imageUrl6;
  final TextEditingController questionController = TextEditingController();


  Future<void> _saveQuestion(String questionText, List<String> imageUrls) async {
    // Create a new document in the Questions collection
    final DocumentReference docRef =
    FirebaseFirestore.instance.collection('Questions').doc();

    // Set the fields of the new document
    await docRef.set({
      'question': questionText,
      'images': imageUrls,
      // Add any other fields for the question data
    });
  }

  Future<String> _uploadImageAndGetUrl(File imageFile) async {
    // Upload the image to Firebase Storage
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('images');
    final UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() {});

    // Get the download URL for the image
    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String downloadUrl = await _uploadImageAndGetUrl(imageFile);

      setState(() {
        // Update the image file and URL based on which image slot is empty
        if (_imageFile1 == null) {
          _imageFile1 = imageFile;
          _imageUrl1 = downloadUrl;
        } else if (_imageFile2 == null) {
          _imageFile2 = imageFile;
         _imageUrl2 = downloadUrl;
        } else if (_imageFile3 == null) {
          _imageFile3 = imageFile;
         _imageUrl3 = downloadUrl;
        } else if (_imageFile4 == null) {
          _imageFile4 = imageFile;
          _imageUrl4 = downloadUrl;
        } else if (_imageFile5 == null) {
          _imageFile5 = imageFile;
          _imageUrl5 = downloadUrl;
        } else if (_imageFile6 == null) {
          _imageFile6 = imageFile;
           _imageUrl6 = downloadUrl;
        }
      });
    }
  }
  Future<void> _submitQuestion(String questionText, List<String?> imageUrls) async {
    try {
      // Upload the images and get their download URLs
      List<String> downloadUrls = [];
      for (String? imageUrl in imageUrls) {
        File imageFile = File(imageUrl!);
        String downloadUrl = await _uploadImageAndGetUrl(imageFile);
        downloadUrls.add(downloadUrl);
      }

      // Create a new document in the Questions collection
      final DocumentReference docRef = FirebaseFirestore.instance.collection('Questions').doc();

      // Set the fields of the new document
      await docRef.set({
        'question': questionText,
        'images': downloadUrls,
        'QuizID':"111",
        // Add any other fields for the question data
      });
      // Success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Question submitted successfully.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to submit the question.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }


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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (_imageFile1 != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          _imageFile1!.path,
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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
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
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
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
                              onPressed: () async {
                                List<String?> imageUrls = [
                                await _uploadImageAndGetUrl(_imageFile1!) ,
                                  await _uploadImageAndGetUrl(_imageFile2!),
                                  await _uploadImageAndGetUrl(_imageFile3!),
                                  await _uploadImageAndGetUrl(_imageFile4!),
                                  await _uploadImageAndGetUrl(_imageFile5!),
                                  await _uploadImageAndGetUrl(_imageFile6!),
                                ];
                                _submitQuestion(questionController.text, imageUrls);
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
}
