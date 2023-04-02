import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColourPallete.backgroundColor,
      width: 600,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'INNOVATECH QUIZ PLATFORM',
              style: TextStyle(
                  fontWeight: FontWeight.w800, height: 0.9, fontSize: 80),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
                'Welcome to our Quiz Platform, to sign up click the buttons on the top right-hand corner of the screen',
                style: TextStyle(
                  fontSize: 21,
                  height: 1.7,
                ))
          ]),
    );
  }
}
