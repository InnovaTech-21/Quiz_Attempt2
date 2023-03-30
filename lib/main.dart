import 'package:flutter/material.dart';
import 'package:quiz_website/Views/sign%20up/signUpView.dart';
import 'package:quiz_website/Views/Home/homePage.dart';
import 'package:quiz_website/ColourPallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnovaTech Quiz Platform',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColourPallete.backgroundColor,
      ),
      home: HomePage(),
    );
  }
}
