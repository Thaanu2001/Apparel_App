import 'package:Apparel_App/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff646464),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: HomeScreen(),
    );
  }
}
