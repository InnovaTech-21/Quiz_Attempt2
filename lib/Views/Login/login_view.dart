import 'package:flutter/material.dart';
import 'package:quiz_website/Database%20Services/auth.dart';
import 'package:quiz_website/Views/Forgot%20Password/forgotpassword.dart';
import 'package:quiz_website/Views/sign up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/landingpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../../Database Services/database.dart';

import '../../menu.dart';




class LoginPage extends StatefulWidget {


  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //AuthService service =AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  User? user;
  DatabaseService service = DatabaseService();

  void clearInputs(){
    usernameController.clear();
    passwordController.clear();
  }
  Future<void> validateAndSave() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      await service.setUserID();

      clearInputs();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SelectaPage()));
      //print('All fields entered, please check corresponding details');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ColourPallete.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: ColourPallete.backgroundColor,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/InnovaTechLogo.png',
                  width: 110,
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Text(
                    "InnovaTech Quiz Platform",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),


                Spacer(),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColourPallete.gradient2,
                        ColourPallete.gradient1,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(95,35),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              )),
                          Container(
                            ///EMAIL TEXTFIELD
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
                                  hintText: 'Enter Email',
                                ),
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (user == null){
                                    return 'Email or password incorrect';
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
                                obscureText: true,
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
                                  if (user == null){
                                    return 'Email or password incorrect';
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
                                  ///shows message
                                  clearInputs();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ForgotPasswordPage()));
                                  //_showDialog('Opens forgot password page');
                                  //GO TO FORGOT PASSWORD PAGE
                                },
                              )
                            ],
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
                                  onPressed: () async {

                                    user = await AuthService.loginUsingEmailPassword( email: usernameController.text, password: passwordController.text);
                                    validateAndSave();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(395, 55), backgroundColor: Colors.transparent,
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
                              Row(
                                ///TEXT BUTTON TO GO TO REGISTRATION PAGE

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
                                      //clearInputs();
                                      Navigator.push(
                                        ///goes to sign in screen
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Signup()),
                                      );
                                    },
                                  )
                                ],
                              ),
                              Container(
                                /// WILL GIVE BELOW MESSAGE IF LOGIN FAILED
                                //alignment: Alignment.center,
                                // child: const Text(
                                //   'Unsuccessful?',
                                //   style: TextStyle(
                                //     color: Color.fromARGB(255, 183, 10, 10),
                                //     fontSize: 10,
                                //   ),
                                // ),
                              ),
                            ],
                          )
                        ]))))));
  }


}
class NavItem extends StatelessWidget {
  const NavItem({
    required Key key,
    required this.title,
    required this.tapEvent
  }) : super(key: key);

  final String title;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapEvent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
              color: ColourPallete.whiteColor,
              fontWeight: FontWeight.w300,
              fontSize: 18

          ),
        ),
      ),
    );
  }
}