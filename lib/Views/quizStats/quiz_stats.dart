import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'dart:math';

class QuizStatsPage extends StatefulWidget {
  const QuizStatsPage({Key? key}) : super(key: key);

  @override
  State<QuizStatsPage> createState() => QuizStatsPageState();
}

class QuizStatsPageState extends State<QuizStatsPage> {

final List<String> _QuizName = [];
final List<int> _QuizScores = [];
final List<String> _Username = [];

int? maxScore;
int? minScore;
double averageScore = 0.0;

//method to get the highest score for the quiz
int? getMaxScore() {
    maxScore = _QuizScores.reduce(max);
    return maxScore;
}

//method to get the lowest score for the quiz
int? getMinScore() {
    minScore = _QuizScores.reduce(min);
    return minScore;
}

//method to gte the average score for the quiz
double getAverageScore() {
    double sum = _QuizScores.reduce((a, b) => a + b).toDouble();
    averageScore = sum / _QuizScores.length;
    return averageScore;
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Quiz Stats'),
      ),
       body: Column(
        children: [
          Card( 
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Average Score: ${averageScore?.toStringAsFixed(2) ?? 'N/A'}'),
                  const SizedBox(height: 16),
                  Text('Max Score: ${maxScore?.toString() ?? 'N/A'}'),
                  const SizedBox(height: 16),
                  Text('Min Score: ${minScore?.toString() ?? 'N/A'}'),
                ],
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}