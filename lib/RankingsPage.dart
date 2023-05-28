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

  void fetchRankings() async {
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
      int highestScore = 0;
      int lowestScore = 0;
      int numQuizzesCompleted = 0;

      for (int i = 0; i < quizResultsSnapshot.docs.length; i++) {
        DocumentSnapshot quizDoc = quizResultsSnapshot.docs[i];
        int score = quizDoc['CorrectAns'];
        scores.add(score);
        totalScore += score;

        if (score > highestScore) {
          highestScore = score;
        }

        if (score < lowestScore || lowestScore == 0) {
          lowestScore = score;
        }

        numQuizzesCompleted++;
      }

      final double averageScore =
      numQuizzesCompleted > 0 ? totalScore / numQuizzesCompleted : 0;

      updatedRankings.add({
        'userId': userId,
        'level': level,
        'totalScore': totalScore,
        'highestScore': highestScore,
        'averageScore': averageScore,
        'lowestScore': lowestScore,
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
        child: Padding(
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
                      DataCell(Text(ranking['highestScore'].toString())),
                      DataCell(Text(ranking['averageScore'].toStringAsFixed(2))),
                      DataCell(Text(ranking['lowestScore'].toString())),
                      DataCell(Text(ranking['numQuizzesCompleted'].toString())),
                    ],
                  ),
                )
                    .toList(), // Add your data rows here
              );
            },
          ),
        ),
      ),
    );
  }
}

