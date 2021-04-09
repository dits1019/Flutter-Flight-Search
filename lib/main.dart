import 'package:flight_search_ex/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flight Search',
      theme: new ThemeData(
          //기본 테마 red
          primaryColor: Colors.red),
      home: new HomePage(),
    );
  }
}
