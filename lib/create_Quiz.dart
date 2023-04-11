import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

class CreateQuiz extends StatelessWidget {
  const CreateQuiz({Key? key});

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
            child: Center(
              child: Column(
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
                        ///Username box
                        child: TextFormField(
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
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,

                        ///sets up text boxes
                        ///Username box
                        child: TextFormField(
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
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,
                        // sets up combo box
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
                            hintText: 'Select Quiz Category', // updated hint text for combo box
                          ),
                          items:<String>['Kdrama', 'Anime', 'Kpop']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 17),
                              ),
                            );
                          }).toList(), // replace with items for the combo box
                          onChanged: (value) {
                            // handle onChanged event for combo box
                          },
                          value: null, // replace with default value for the combo box
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,
                        // sets up combo box
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
                            hintText: 'Select Quiz Type', // updated hint text for combo box
                          ),
                          items: <String>['Multiple Choice', 'Image-Based', 'Short-Answer']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 17),
                              ),
                            );
                          }).toList(), // replace with items for the combo box
                          onChanged: (value) {
                            // handle onChanged event for combo box
                          },
                          value: null, // replace with default value for the combo box
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 600,

                        ///sets up text boxes
                        ///Username box
                        child: TextFormField(
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
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        onPressed: ()  {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //
                          //       builder: (context) => const CreateQuiz()),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(450, 65), backgroundColor: Colors.transparent,
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
        )));
  }
}
