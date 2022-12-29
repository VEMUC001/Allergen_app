import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_allergen_app/screens/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Food Allergen App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserAccount(),
    );
  }
}


