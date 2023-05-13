import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class imageBasedAnswers extends StatefulWidget {
  imageBasedAnswers({Key? key, required this.quizID, required this.bTimed, required this.iTime}) : super(key: key);
  String quizID;
  bool bTimed;
  int iTime;
  @override
  imageBasedAnswerState createState() => imageBasedAnswerState();
}

class imageBasedAnswerState extends State<imageBasedAnswers> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
