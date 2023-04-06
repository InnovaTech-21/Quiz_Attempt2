import 'package:flutter/material.dart';
import 'package:quiz_website/ColourPallete.dart';


class menu extends StatelessWidget {
  const menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColourPallete.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ColourPallete.backgroundColor,
     body: Material(
       color: ColourPallete.backgroundColor,
      child: Center(
        child: Column(
        children: const <Widget>[
          SizedBox(height: 50),
          SizedBox(width: 150),
          Text(
          'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),

          ],
        ),
      ),
    ),
    );

  }
}