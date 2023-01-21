import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

//String? scanResult;

// Future scanBarcode() async {
//   String scanResult;
//   try {
//     scanResult = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666",
//         "Anuluj",
//         true,
//         ScanMode.BARCODE
//     );
//   } on PlatformException {
//     scanResult = 'Nieudane skanowanie!';
//   }
//   if (!mounted) return;
//
//   setState(() => this.scanResult = scanResult);
// }

// scanBarcode() async {
//   return await FlutterBarcodeScanner.scanBarcode(
//       "#000000", 'Anuluj', true, ScanMode.BARCODE)
//       .then((value) => setState(() => _barcode = value));
// }

// Future<String> scanBarcode() async {
//   // store result of scan
//   String barcodeScanResult;
//
//   barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
//       "#ff6666", "Cancel", false, ScanMode.BARCODE);
//
//   // return result
//   return barcodeScanResult;
// }