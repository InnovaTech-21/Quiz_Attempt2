

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingsPage extends StatefulWidget {
  @override
  _RankingsPageState createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  List<Map<String, dynamic>> rankings = [];

  @override
  void initState() {
    super.initState();
    fetchRankings();
  }
  Futue<void> fetchRankings() async {
    QuerySnapshot usersSnapshot =
    await FirebaseFirestore.instance.collection('Users').get();

    final List<Map<String, dynamic>> updatedRankings = [];

    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      DocumentSnapshot quizDoc = usersSnapshot.docs[i];
      int level = quizDoc['levels'];
      String userId = quizDoc['user_name'];
      QuerySnapshot quizResultsSnapshot = await FirebaseFirestore.instance
          .collection('QuizResults')
          .where('UserID', isEqualTo: userId)
          .get();

      final List<int> scores = [];
      int totalScore = 0;
      int highestScore = 0; // Initialize with the minimum possible value
      int lowestScore = 1000; // Initialize with the maximum possible value
      int numQuizzesCompleted = 0;
      int totalScore1 = 0;
      double lowestScorePercentage = 1000;
      double highestScorePercentage = 0;
      double average;
      int sum = 0; int count = 0;
      double avg_sum = 0;

      for (int i = 0; i < quizResultsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = quizResultsSnapshot.docs[i];
        int score = quizDoc['CorrectAns'];
        int totalScoreOutOf = quizDoc['TotalAns'];
        //String QuizID =  quizDoc['Quiz_ID'];

        totalScore1 = totalScoreOutOf;
        scores.add(score);
        totalScore += score;
        count = count +1;

        avg_sum= avg_sum +score/totalScoreOutOf;


        if (score/totalScoreOutOf *100 > highestScorePercentage) {
          highestScore = score;
          highestScorePercentage =
              (highestScore / totalScore1) * 100;
        }

        if (score/totalScoreOutOf *100  < lowestScorePercentage) {
          lowestScore = score;
          lowestScorePercentage =lowestScore / totalScore1 * 100;

        }


        numQuizzesCompleted++;
      }
      if (lowestScorePercentage == 1000) {
        lowestScorePercentage = 0;
      }
      double averageScore =0;
      if (count != 0){
        averageScore = avg_sum/count *100;
      }




      updatedRankings.add({
        'userId': userId,
        'level': level,
        'totalScore': totalScore,
        'highestScore': highestScorePercentage,
        'averageScore': averageScore,
        'lowestScore': lowestScorePercentage,
        'numQuizzesCompleted': numQuizzesCompleted,
      });
    }

    setState(() {
      rankings = updatedRankings;
    });
  }
  void sortRankings(String header, bool isAscending) {
    setState(() {
      rankings.sort((a, b) {
        if (isAscending) {
          return a[header].compareTo(b[header]);
        } else {
          return b[header].compareTo(a[header]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rankings'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: fetchRankings(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {// Sort the quiz names alphabetically
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return DataTable(
                      headingRowHeight: 60,
                      columns: [
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.1, // Adjust the width as needed
                            child: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('userId', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.05, // Adjust the width as needed
                            child: Text(
                              'Level',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('level', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.05, // Adjust the width as needed
                            child: Text(
                              'Total Score',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('totalScore', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.08, // Adjust the width as needed
                            child: Text(
                              'Highest Score',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('highestScore', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.08, // Adjust the width as needed
                            child: Text(
                              'Average Score',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('averageScore', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.08, // Adjust the width as needed
                            child: Text(
                              'Lowest Score',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('lowestScore', ascending);
                          },
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.1, // Adjust the width as needed
                            child: Text(
                              'Num Quizzes Completed',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onSort: (columnIndex, ascending) {
                            sortRankings('numQuizzesCompleted', ascending);
                          },
                        ),
                      ],
                      rows: rankings
                          .map(
                            (ranking) => DataRow(
                          cells: [
                            DataCell(Text(ranking['userId'])),
                            DataCell(Text(ranking['level'].toString())),
                            DataCell(Text(ranking['totalScore'].toString())),
                            DataCell(Text(ranking['highestScore'].toStringAsFixed(2) + '%')),
                            DataCell(Text(ranking['averageScore'].toStringAsFixed(2)+ '%')),
                            DataCell(Text(ranking['lowestScore'].toStringAsFixed(2) + '%') ),
                            DataCell(Text(ranking['numQuizzesCompleted'].toString())),
                          ],
                        ),
                      )
                          .toList(), // Add your data rows here
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}