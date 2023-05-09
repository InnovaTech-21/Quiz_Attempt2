import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:path/path.dart' as Path;

class imageBased extends StatefulWidget {
  const imageBased({Key? key, required int numQuest});

  @override
  _imageBasedState createState() => _imageBasedState();
}

class _imageBasedState extends State<imageBased> {
  List<File?> imageFiles = List.filled(6, null);
  List<String?> imageUrls = List.filled(6, null);
  final _picker = ImagePicker();
  final TextEditingController questionController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _pickImage(ImageSource source, int index) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        imageFiles[index] = imageFile;
        print(imageFile.toString());
      });
    }
  }

  Future<void> _uploadImages() async {
    for (int i = 0; i < imageFiles.length; i++) {
      if (imageFiles[i] != null) {
        String downloadUrl = await _uploadImageAndGetUrl(imageFiles[i]!);
        print(downloadUrl);
        imageUrls[i] = downloadUrl;
      }
    }
  }

  Future<String> _uploadImageAndGetUrl(File file) async {
    String fileName = Path.basename(file.path);
    Reference reference = storage.ref().child("images/$fileName");
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _submitQuestion(String questionText) async {
    _uploadImages();
    try {
      await _uploadImages();

      final DocumentReference docRef = FirebaseFirestore.instance.collection('Questions').doc();
      await docRef.set({
        'question': questionText,
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });

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
      print(error.toString());
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
                                          _pickImage(ImageSource.gallery,0);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[0]!= null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[0]!.path,
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
                                          _pickImage(ImageSource.gallery,1);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[1] != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[1]!.path,
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
                                          _pickImage(ImageSource.gallery,2);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[2]!= null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[2]!.path,
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
                                          _pickImage(ImageSource.gallery,3);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[3] != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[3]!.path,
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
                                          _pickImage(ImageSource.gallery,4);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[4] != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[4]!.path,
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
                                          _pickImage(ImageSource.gallery,5);
                                        },
                                        child: const Icon(Icons.add_photo_alternate),
                                      ),
                                    ),
                                    if (imageFiles[5] != null)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Image.network(
                                          imageFiles[5]!.path,
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
                                _submitQuestion(questionController.text);
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
