import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'dart:math';

import 'package:quiz_website/Database%20Services/database.dart';

class QuizStatsPage extends StatefulWidget {
  const QuizStatsPage({Key? key}) : super(key: key);

  @override
  State<QuizStatsPage> createState() => QuizStatsPageState();
}

class QuizStatsPageState extends State<QuizStatsPage> {
  late List<String> _QuizID = [];
  final List<String> _QuizIDDATA = [];
  final List<String> _QuizName = [];
  final List<int> _QuizScores = [];
  final List<int> _QuizTotal = [];
  final List<String> _DateCompleted = [];
  final List<String> _Username = [];
  int? maxScore;
  int? minScore;
  double averageScore = 0.0;
  DatabaseService service = DatabaseService();


  @override
  void initState() {
    super.initState();
    getAllUniqueQuizIds();
  }

  Future<void> getAllUniqueQuizIds() async {
    if (_QuizID.isEmpty) {
      final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('QuizResults');
      final List<String> quizIds = [];
      try {
        final QuerySnapshot querySnapshot = await collectionRef.get();

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          DocumentSnapshot quizDoc = querySnapshot.docs[i];
          final String? abc = querySnapshot.docs[i]["Quiz_ID"];
          _QuizIDDATA.add(querySnapshot.docs[i]["Quiz_ID"]);
          _QuizScores.add(querySnapshot.docs[i]["CorrectAns"]);
          _QuizTotal.add(querySnapshot.docs[i]["TotalAns"]);
          // _DateCompleted.add(querySnapshot.docs[i]["Date_Created"].toString());
          if (!quizIds.contains(abc)) {
            quizIds.add(abc!);
          }
        }
      } catch (error) {
        print('Error retrieving quiz IDs: $error');
      }



        for (int i = 0; i < quizIds.length; i++) {
          _QuizID.add(quizIds[i]);
          _QuizName.add(await service.getQuizName(quizIds[i]));
        }
        print(_QuizName);

    }
  }

  int getMinScore(String QuizID) {
    int min = _QuizScores[0];

    for (int i = 0; i < _QuizScores.length; i++) {
      if (QuizID == _QuizID) {
        int temp = _QuizScores[i];
        if (temp < min) {
          min = temp;
        }
      }
    }

    return min;
  }

  int getMaxScore(String QuizID) {
    int max = _QuizScores[0];

    for (int i = 0; i < _QuizScores.length; i++) {
      if (QuizID == _QuizID) {
        int temp = _QuizScores[i];
        if (temp > max) {
          max = temp;
        }
      }
    }

    return max;
  }

  double getAverageScore(String QuizID) {
    int sum = 0;
    int sumtotal = 0;
    int count = 0;

    for (int i = 0; i < _QuizScores.length; i++) {
      if (QuizID == _QuizID) {
        sum = sum + _QuizScores[i];
        count = count + 1;
        sumtotal = sumtotal + _QuizTotal[i];
      }
    }

    double avg = sum / count;
    return avg;
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
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: getAllUniqueQuizIds(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  for (int i = 0; i < _QuizName.length; i++)
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_QuizName[i]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Average Score: ${getAverageScore(
                                    _QuizID[i])}'),
                                const SizedBox(height: 16),
                                Text('Max Score: ${getMaxScore(_QuizID[i])}'),
                                const SizedBox(height: 16),
                                Text('Min Score: ${getMinScore(_QuizID[i])}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}