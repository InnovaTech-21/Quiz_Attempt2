import 'package:flutter/material.dart';

import 'package:quiz_website/landingpage.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'InnovaTech Quiz Platform',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColourPallete.backgroundColor,
      ),
      home:  SelectaPage()
       // builder: (context, constraints) => ConstrainedBox(
          //constraints: const BoxConstraints(minWidth: 1000, minHeight: 1000),
        //),
      //),
    );
  }
}