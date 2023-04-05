import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: ColourPallete.backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: const Center(
                child: Text(
                  'INNOVATECH QUIZ PLATFORM',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    height: 0.9,
                    fontSize: 80,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  'Welcome to our Quiz Platform, to sign up click the buttons on the top right-hand corner of the screen',
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
