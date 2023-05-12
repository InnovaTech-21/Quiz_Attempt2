import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import '../../Database Services/database.dart';
import '../../main.dart';
import '../../menu.dart';
import '../Login/login_view.dart';



class Signup extends StatefulWidget {

  const Signup({super.key});

  @override
  State<Signup> createState() => SignupState();

}

class SignupState extends State<Signup> {
  ///sets up form state watcher
  DatabaseService service = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  ///values to populate date dropdown
  final List<int> _years =
  List<int>.generate(100, (int index) => DateTime.now().year - index);
  final List<String> _months = List<String>.generate(12, (int index) => (index + 1).toString().padLeft(2, '0'));

  final List<String> _days = List<String>.generate(31, (int index) => (index + 1).toString().padLeft(2, '0'));

  ///vars that save date selection
  int? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;

  ///flag for date validation
  bool check = true;

  ///sets up textbox controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  ///adds users to database


  void clearInputs(){
    usernameController.clear();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      _selectedDay=null;
      _selectedMonth=null;
      _selectedYear=null;
    });

  }
  ///runs when signup button pressed
  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && check) {
      ///write to database
      service.addSignupToFirestore(emailController.text, passwordController.text,usernameController.text,nameController.text,getDate());
      clearInputs();
      showDialog1("Account created");

      ///go to welcome page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MenuPage(testFlag: false,)));

    }
    // else {
    //   print('Validation failed');
    // }
  }

  ///code to get values from input boxes








  String getConfirmPassword() {
    return confirmPasswordController.text;
  }

  DateTime getDate() {
    String sdate = "${_selectedYear!}-${_selectedMonth!}-${_selectedDay!}";
    //String sdate = "${_selectedDay!}-${_selectedMonth!}-${_selectedYear!}";
    DateTime date =DateTime.parse(sdate);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColourPallete.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                ///goes to sign in screen
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
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(width: 150),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 400,

                            ///sets up text boxes
                            ///Username box
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
                              validator: validateUsername,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 400,

                            ///Name box
                            child: TextFormField(
                              controller: nameController,
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
                                hintText: 'Enter Name',
                              ),
                              keyboardType: TextInputType.text,
                              validator: validateName,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 400,
                            ///Email box
                            child: TextFormField(
                              controller: emailController,
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
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          //elevation: 3,
                          child: SizedBox(
                            width: 400,
                            ///Password box
                            child: TextFormField(
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
                              obscureText: true,
                              validator: validatePassword,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: 400,
                            child: SizedBox(
                              width: 400,
                              ///Confirm password box
                              child: TextFormField(
                                controller: confirmPasswordController,
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
                                  hintText: 'Confirm Password',
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                validator: validateConfirm,
                              ),
                            ),
                          ),
                        ),

                        ///Date selector
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter your date of birth',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 400,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: _selectedDay,
                                        onChanged: (String? day) {
                                          setState(() {
                                            _selectedDay = day;
                                          });
                                        },
                                        hint: const Text('Day'),
                                        items: _days
                                            .map<DropdownMenuItem<String>>((String day) {
                                          return DropdownMenuItem<String>(
                                            value: day,
                                            child: Text(day),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: _selectedMonth,
                                        onChanged: (String? month) {
                                          setState(() {
                                            _selectedMonth = month;
                                          });
                                        },
                                        hint: const Text('Month'),
                                        items: _months.map<DropdownMenuItem<String>>(
                                                (String month) {
                                              return DropdownMenuItem<String>(
                                                value: month,
                                                child: Text(month),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: DropdownButton<int>(
                                        value: _selectedYear,
                                        onChanged: (int? year) {
                                          setState(() {
                                            _selectedYear = year;
                                          });
                                        },
                                        hint: const Text('Year'),
                                        items: _years
                                            .map<DropdownMenuItem<int>>((int year) {
                                          return DropdownMenuItem<int>(
                                            value: year,
                                            child: Text(year.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///Creates sign up button
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
                          ///Signup button
                          child: ElevatedButton(
                            onPressed: () {

                              /// Check that date is valid
                              if (validateDay(_selectedDay) != null ||
                                  validateMonth(_selectedMonth) != null ||
                                  validateYear(_selectedYear) != null) {
                                showDialog1("Enter valid date of birth");

                                setState(() {
                                  check = false;
                                  // Flag that works with rest of verification checks
                                });
                              } else {
                                check = true;
                              }

                              ///Goes to _submit if date is  valid
                              ///Rest of validation happens in submit

                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(395, 55), backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),

                        ///text under button and button back to login screen
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Already have an account?'),
                            TextButton(
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 17, color: ColourPallete.gradient2),
                              ),
                              onPressed: () {
                                clearInputs();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(

                                      builder: (context) => const LoginPage()),
                                );

                                /// back to login screen
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  void showDialog1(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ///verification checks
  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validateUsername(String? value) {
    if (value == null) {
      return 'Enter username';
    } else if (value.length < 4) {
      return 'Username must be longer than 3 characters';
    } else

      ///check if username exists
    {
      return null;
    }
  }

  String? validateName(String? value) {
    if (value == null) {
      return 'Enter name';
    } else if (value.length < 2) {
      return 'Username must be at least 2 characters';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    RegExp passwordFormat = RegExp(
      r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&*+=!])(?=\S+$).{4,}$',
    );
    if (value == null) {
      return 'Enter password';
    } else {
      if (value.length < 6) {
        return 'Must be longer than 5 characters';
      } else if (!passwordFormat.hasMatch(value)) {
        return 'Must contain mix of lowercase, uppercase, digits, symbols.';
      }
    }
    return null;
  }

  String? validateConfirm(String? value) {
    if (value == null) {
      return 'Enter password';
    } else {
      if (value != passwordController.text) {
        return 'Passwords do not match';
      }
    }
    return null;
  }

  String? validateMonth(String? value) {
    if (value == null) {
      return 'Please select a month';
    }
    return null;
  }

  String? validateDay(String? value) {
    if (value == null) {
      return 'Please select a day';
    }
    return null;
  }

  String? validateYear(int? value) {
    if (value == null) {
      return 'Please select a year';
    }
    return null;
  }

}