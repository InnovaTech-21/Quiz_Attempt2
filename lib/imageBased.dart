import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';

class imageBased extends StatefulWidget {
  const imageBased({Key? key});

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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                                        onPressed: () {
                                          _pickImage(ImageSource.camera);
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
                              onPressed: () {
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
