import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/Views/sign%20up/signUpView.dart';
import 'package:quiz_website/widgets/NavigationBar/navigation_bar.dart' as nb;
import 'package:quiz_website/ColourPallete.dart';

import 'package:quiz_website/widgets/centeredView/centeredView.dart';

import 'package:quiz_website/widgets/welcome/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nb.NavigationBar(),
            CenteredView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Welcome(),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: ColourPallete.backgroundColor,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final buttonWidth = screenWidth > 600 ? 395.0 : constraints.maxWidth;
                          final buttonHeight = 55.0;

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 90),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(buttonWidth, buttonHeight),
                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(buttonWidth, buttonHeight),
                                      backgroundColor: Colors.transparent,
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


