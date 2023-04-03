import 'package:flutter/material.dart';



class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              'assets/images/InnovaTechLogo.png',
            ),
          ),
          Spacer(),
          NavItem(
            title: 'Home',
          ),
          SizedBox(
            width: 60,
          ),
          NavItem(
            title: 'Make a Quiz',
          ),
        ],
      ),
    );
  }
}


class NavItem extends StatelessWidget {
  final String title;
  const NavItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18),
    );
  }
}

