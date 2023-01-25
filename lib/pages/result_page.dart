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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (product != null) ...[
              Image.network(
                product!.imageFrontSmallUrl!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 20),
              Text(
                product!.productName!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
               Text(
                 'Kod kreskowy: ${product?.barcode}',
                style: TextStyle(fontSize: 18),
               ),
              SizedBox(height: 8),
              Text(
                'Producent: ${product!.brands}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Text(
              //   "Alergeny: Orzechy, Mleko, Gluten",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 24,
              //     color: Colors.red,
              //   ),
              // ),
              FutureBuilder(
                future: getSelectedAllergens(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  } else {
                    final selectedAllergens = snapshot.data;
                    final allergensInProduct = product!.allergens.toString().split(",");
                    final matchingAllergens = selectedAllergens.where((allergen) => allergensInProduct!.contains(allergen)).toList();
                    if (matchingAllergens.isEmpty) {
                      return Text(
                        "Produkt nie zawiera alergenów",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.yellow,
                        ),
                      );
                    } else {
                      return Text(
                          "Alergeny: " + matchingAllergens.join(", "),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.red
                          ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Skład: ${product!.ingredientsText}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
            ],
            if (product == null)
              Text('Brak informacji o produkcie ${widget.scanResult}'),
          ],
        ),
      ),
    );
  }

  Future getProductInfo() async {
    try {
      final product = await getProduct(widget.scanResult);
      final selectedAllergens = await getSelectedAllergens();
      final matchingAllergens = selectedAllergens.where((allergen) => product!.ingredientsText!.contains(allergen)).toList();
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
