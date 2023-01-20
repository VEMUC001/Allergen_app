import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/model/ProductResultV3.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/model/OcrIngredientsResult.dart';
import 'package:openfoodfacts/utils/TagType.dart';
import '../barcode_scanner.dart';
import 'allergens_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? scanResult;
  var scanName = "";
  var scanIngredients = "";
  var scanAllergens = "";
  var db;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Strona główna'),
    ),
    body: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Zalogowany jako:',
                style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            user.email!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Wybierz alergeny'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllergensPage()),
              );
            },
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              onPrimary: Colors.black,
            ),
            icon: Icon(Icons.camera_alt_outlined),
            label: Text('Start scan'),
            onPressed: () => scanBarcode(),
          ),
          SizedBox(height: 20),
          Text(
            scanResult == null
                ? 'Scan a code!'
                : 'Scan results : $scanResult',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_back, size: 32),
            label: Text(
              'Wyloguj się',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    ),
  );
}

