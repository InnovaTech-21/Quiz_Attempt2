import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/publishPage.dart';

class CreateMAQ extends StatefulWidget {
  const CreateMAQ({super.key});

  @override
  State<CreateMAQ> createState() => _CreateMAQState();
}

class _CreateMAQState extends State<CreateMAQ> {
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> listController = [TextEditingController()];
  final TextEditingController questionController = TextEditingController();

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
                const Center(
                    child: Text(
                  'Create Your Multiple Answer Quiz',
                  style: TextStyle(
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
                            child: const Text("Add Another Potential Answer",
                                style: TextStyle(color: Colors.white)),
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
                              List<String> answers = [];
                              for (int i = 0; i < listController.length; i++) {
                                answers.add(listController[i].text);
                              }
                              List<String> questions = [];
                              questions.add(questionController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => publishPage(
                                          questions: questions,
                                          answers: answers,
                                          quizType: 3,
                                        )),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 40, 148, 248),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: const Text('Done',
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
