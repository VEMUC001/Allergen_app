import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';

import '../api.dart';

class ResultPage extends StatefulWidget {
  final String scanResult;
  const ResultPage({Key? key, required this.scanResult}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Product? product;
  List<String> matchingAllergens = [];
  List<String> selectedAllergens = [];

  @override
  void initState() {
    super.initState();
    getProductInfo();
    getSelectedAllergens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Karta produktu'),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(32),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       if (product != null) ...[
      //         Text(
      //           product.productName,
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(height: 8),
      //         Text(
      //           'Kod kreskowy: ${product.code}',
      //           style: TextStyle(fontSize: 18),
      //         ),
      //         SizedBox(height: 8),
      //         Text(
      //           'Producent: ${product.brands}',
      //           style: TextStyle(fontSize: 18),
      //         ),
      //         SizedBox(height: 8),
      //         Text(
      //           'Skład: ${product.ingredientsText}',
      //           style: TextStyle(fontSize: 18),
      //         ),
      //         SizedBox(height: 8),
      //         FutureBuilder(
      //           future: getSelectedAllergens(),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return Text("Loading...");
      //             } else {
      //               final selectedAllergens = snapshot.data;
      //               final allergensInProduct = product.allergens.split(",");
      //               final matchingAllergens = selectedAllergens.where((allergen) => allergensInProduct.contains(allergen)).toList();
      //               if (matchingAllergens.isEmpty) {
      //                 return Text("Produkt nie zawiera alergenów");
      //               } else {
      //                 return Text("Alergeny: " + matchingAllergens.join(", "), style: TextStyle(color: Colors.red));
      //               }
      //             }
      //           },
      //         ),
      //       ],
      //       if (product == null)
      //         Text('Brak informacji o produkcie'),
      //     ],
      //   ),
      // ),
    );
  }

  Future getProductInfo() async {
    try {
      final product = await getProduct(widget.scanResult);
      final selectedAllergens = await getSelectedAllergens();
      //final matchingAllergens = selectedAllergens.where((allergen) => product.ingredientsText.contains(allergen)).toList();
      setState(() {
        this.product = product;
        this.matchingAllergens = matchingAllergens;
      });
    } catch (e) {
      print(e);
    }
  }
}

Future getSelectedAllergens() async {
  final user = FirebaseAuth.instance.currentUser!;
  final uid = user.uid;
  final allergens = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Allergens").where("isChecked", isEqualTo: true).get();
  return allergens.docs.map((doc) => doc.data()["name"] as String).toList();
}
