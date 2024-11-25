import 'package:flutter/material.dart';
import 'package:melembra/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: HomeScreen(),
    );
  }
}