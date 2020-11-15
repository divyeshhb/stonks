import 'package:flutter/material.dart';
import 'package:stonks/widgets/portfolio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stonks/widgets/welcome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    WelcomeHome(),
    Portfolio(),
  ];

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (mounted) {
            setState(() {
              _currentIndex = value;
            });
          }
        },
        fixedColor: Colors.indigo,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: 'My Portfolio',
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
