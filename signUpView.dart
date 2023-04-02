import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  ///sets up form state watcher
  final _formKey = GlobalKey<FormState>();

  ///values to populate date dropdown
  final List<int> _years =
      List<int>.generate(100, (int index) => DateTime.now().year - index);
  final List<int> _months = List<int>.generate(12, (int index) => index + 1);
  final List<int> _days = List<int>.generate(31, (int index) => index + 1);

  ///vars that save date selection
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  ///flag for date validation
  bool check = true;

  ///sets up textbox controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ///runs when signup button pressed
  void _submit() {
    if (_formKey.currentState!.validate() && check) {
      ///write to database
      ///
      ///
      _showDialog("Account created");
      print(getDate());

      ///go to welcome page
      ///
      ///
    } else {
      print('Validation failed');
    }
  }

  ///code to get values from input boxes
  String getUsername() {
    return usernameController.text;
  }

  String getName() {
    return nameController.text;
  }

  String getEmail() {
    return emailController.text;
  }

  String getPassword() {
    return passwordController.text;
  }

  String getConfirmPassword() {
    return confirmPasswordController.text;
  }

  String getDate() {
    String date;
    date = "${_selectedDay!}/${_selectedMonth!}/${_selectedYear!}";
    return date;
  }

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

                        ///sets up text boxes
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

                    ///date selector
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
                                  child: DropdownButton<int>(
                                    value: _selectedDay,
                                    onChanged: (int? day) {
                                      setState(() {
                                        _selectedDay = day;
                                      });
                                    },
                                    hint: const Text('Day'),
                                    items: _days
                                        .map<DropdownMenuItem<int>>((int day) {
                                      return DropdownMenuItem<int>(
                                        value: day,
                                        child: Text(day.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: _selectedMonth,
                                    onChanged: (int? month) {
                                      setState(() {
                                        _selectedMonth = month;
                                      });
                                    },
                                    hint: const Text('Month'),
                                    items: _months.map<DropdownMenuItem<int>>(
                                        (int month) {
                                      return DropdownMenuItem<int>(
                                        value: month,
                                        child: Text(month.toString()),
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

                    ///creates sign up button

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
                            // Signup button callback

                            // Check that date is valid
                            if (_validateDay(_selectedDay) != null ||
                                _validateMonth(_selectedMonth) != null ||
                                _validateYear(_selectedYear) != null) {
                              _showDialog("Enter valid date of birth");

                              setState(() {
                                check = false;
                                // Flag that works with rest of verification checks
                              });
                            } else {
                              check = true;
                            }

                            _submit();
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(395, 55),
                            primary: Colors.transparent,
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
                            Navigator.pop(context);

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

  void _showDialog(String message) {
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
      if (value != getPassword()) {
        return 'Passwords do not match';
      }
    }
    return null;
  }

  String? _validateMonth(int? value) {
    if (value == null) {
      return 'Please select a month';
    }
    return null;
  }

  String? _validateDay(int? value) {
    if (value == null) {
      return 'Please select a day';
    }
    return null;
  }

  String? _validateYear(int? value) {
    if (value == null) {
      return 'Please select a year';
    }
    return null;
  }

  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
