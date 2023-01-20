import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? scanResult;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('przykład'),
      centerTitle: true,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              onPrimary: Colors.black,
            ),
            icon: Icon(Icons.camera_alt_outlined),
            label: Text('Start scan'),
            onPressed: scanBarcode,
          ),
          SizedBox(height: 20),
          Text(
            scanResult == null
              ? 'Scan a code!'
              : 'Scan results : $scanResult',
            style: TextStyle(fontSize: 18),
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
  }
}
