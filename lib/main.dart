import 'package:flutter/material.dart';
import 'package:contact_buddy/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'Contact Buddy',
      home: HomeScreen(),
    );
  }
}
