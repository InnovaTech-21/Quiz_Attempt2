import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> listController = [TextEditingController()];
  final TextEditingController questionController = TextEditingController();
  final TextEditingController NumberExpectedController =
      TextEditingController();

  ///validation checks
  String? validateQuestion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a question';
    } else {
      return null;
    }
  }

  String? validateAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an answer';
    } else {
      return null;
    }
  }

  String? validateExpected(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter the number of expected answers';
    }
    if (int.parse(value) > listController.length) {
      return 'Number of expected answers must be less than or equal to number of answers entered';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
      ),
      backgroundColor: ColourPallete.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  'Create Your Multiple Answer Quiz',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),

                SizedBox(height: 15),

                ///question text box
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: questionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your question here',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 40, 148, 248))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 216, 206, 206)),
                  ),
                  maxLines: 5,
                  validator: validateQuestion,
                ),
                //possible answers text box
                SizedBox(height: 5),
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
                              height: 60,
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                autocorrect: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: listController[index],
                                autofocus: false,
                                decoration: const InputDecoration(
                                  hintText:
                                      "Enter correct possible answer here",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 40, 148, 248))),
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 216, 206, 206)),
                                ),
                                validator: validateAnswer,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          index != 0
                              //Remove textbox on press of icon
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listController[index].clear();
                                      listController[index].dispose();
                                      listController.removeAt(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 40, 148, 248),
                                    size: 35,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    );
                  },
                ),
                //Textbox for number of answers expected when answering quiz
                SizedBox(height: 50),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: NumberExpectedController,
                  decoration: const InputDecoration(
                    hintText: 'Number of answers expected',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 40, 148, 248))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 216, 206, 206)),
                  ),
                  validator: validateExpected,
                ),

                const SizedBox(
                  height: 10,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listController.add(TextEditingController());
                          });
                        },
                        child: Center(
                          child: Container(
                            //button adds more possible answers text box
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 40, 148, 248),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text("Add More Potential Answers",
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                            print(questionController);
                            print(listController);
                            print(listController.length);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 40, 148, 248),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text('Submit',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
