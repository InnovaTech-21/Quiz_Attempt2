import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/Views/sign%20up/signUpView.dart';
import 'package:quiz_website/widgets/NavigationBar/navigation_bar.dart' as nb;
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/widgets/call-to-action/call_to_action.dart';
import 'package:quiz_website/widgets/centeredView/centered.dart';
import 'package:quiz_website/widgets/login.dart';
import 'package:quiz_website/widgets/welcome/welcome.dart';

class menu extends StatelessWidget {
  const menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourPallete.backgroundColor,
    );
  }
}
