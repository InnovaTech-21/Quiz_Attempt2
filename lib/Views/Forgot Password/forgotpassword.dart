import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/Views/sign up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../../menu.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColourPallete.backgroundColor,
          title: Text('Reset Password'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),

            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Material(
            color: ColourPallete.backgroundColor,
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(

                              ///PAGE NAME
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Receive an email to reset your password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                )
                            ),
                            Container(

                              ///EMAIL TEXTFIELD
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 400,
                                child: TextFormField(
                                  controller: _emailController,
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
                                    hintText: 'Enter Email',
                                  ),
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    final bool isValid = EmailValidator
                                        .validate(value, true);
                                    if (isValid == false) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            Container(
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
                                    resetPassword(context);

                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(395, 55),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ]
                      ),

                    )

                )
            )
        )
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      _showSuccessDialog(context, "Password reset email sent!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginPage()));
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message.toString());
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
