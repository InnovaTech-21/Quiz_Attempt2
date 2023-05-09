import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Forgot%20Password/forgotpassword.dart';
import 'package:quiz_website/Views/sign up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import '../../menu.dart';




class LoginPage extends StatefulWidget {


  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  User? user;

  void clearInputs(){
    usernameController.clear();
    passwordController.clear();
  }
  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {

      clearInputs();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MenuPage()));
      //print('All fields entered, please check corresponding details');
    }
  }


  static Future<User?>loginUsingEmailPassword({required String email, required String password  }) async{
    User? user;
    try{

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      user =userCredential.user;

    }  on FirebaseAuthException catch(e){
      if(e.code =="user-not-found"){
        print("No user with that email");
      }
      else{

      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              ///goes to welcome page
              context,
              MaterialPageRoute(
                  builder: (context) =>  MyApp()),
            );
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
                                    // usernameController.text='shakeel@gmail.com';
                                    // passwordController.text='\$Hak3l';
                                    user = await loginUsingEmailPassword(email: usernameController.text, password: passwordController.text);
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
