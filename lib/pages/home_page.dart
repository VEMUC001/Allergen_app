import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_allergen_app/pages/result_page.dart';
import 'allergens_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? scanResult;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('Allergen Scanner'),
    ),
    body: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Zalogowany jako:',
                style: TextStyle(fontSize: 10),
          ),
          SizedBox(height: 6),
          Text(
            user.email!,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 30),
          Image.asset('assets/images/barcode-scanner.png'),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(45),
              primary: Colors.amber,
              onPrimary: Colors.black,
            ),
            child: const Text('Wybierz alergeny',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllergensPage()),
              );
            },
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(45),
              primary: Colors.amber,
              onPrimary: Colors.black,
            ),
            icon: Icon(Icons.photo_camera_outlined, size: 32),
            label: Text('Zeskanuj kod',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () => scanBarcode(),
          ),
          SizedBox(height: 20),
          // Text(
          //   scanResult == null
          //       ? 'Scan a code!'
          //       : 'Scan results : $scanResult',
          //   style: TextStyle(fontSize: 18),
          // ),
          SizedBox(height: 30),
          FloatingActionButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            backgroundColor: Colors.green,
            child: const Icon(Icons.login_outlined, size: 32),
          ),
        ],
      ),
    ),
  );

  Future scanBarcode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          "Anuluj",
          true,
          ScanMode.BARCODE
      );
    } on PlatformException {
      scanResult = 'Nieudane skanowanie!';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);

    Navigator.of(context).push(
      //context,
      MaterialPageRoute(builder: (context) => ResultPage(scanResult: scanResult)),
    );
  }
}

