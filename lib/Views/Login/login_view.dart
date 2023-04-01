import 'package:flutter/material.dart';
import 'package:quiz_website/Views/sign up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('All fields entered, please check corresponding details');
    } else {
      print('All fields not entered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              )),
                          Container(
                            ///USERNAME TEXTFIELD
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                controller: usernameController,
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
                                  hintText: 'Enter Username',
                                ),
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                            ///PASSWORD TEXTFIELD
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: SizedBox(
                              width: 400,
                              child: TextFormField(
                                obscureText: passwordVisible,
                                controller: passwordController,
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
                                  hintText: 'Enter Password',
                                ),
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Row(
                            ///FORGET PASSWORD TEXT BUTTON
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  //GO TO FORGOT PASSWORD PAGE
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
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
                                      onPressed: () {
                                        validateAndSave();
                                        ///IF LOGIN DETAILS ARE SATISFACTORY WILL GO TO HOME PAGE
                                        ///Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
                                        ///IF LOGIN DETAILS ARE NOT SATISFACTORY MESSAGE WILL BE DISPLAYED
                                        /// Container(
                                            ///alignment: Alignment.center,
                                            ///child: const Text(
                                              ///'Unsuccessful?',
                                              ///style: TextStyle(
                                                ///color: Color.fromARGB(255, 183, 10, 10),
                                                ///fontSize: 10,
                                             ///),
                                           ///),
                                        ///),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(395, 55),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  ///TEXT BUTTON TO GO TO REGISTRATION PAGE
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text('Dont have account?'),
                                    TextButton(
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          ///goes to sign in screen
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup()),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ])))));
  }
}
