import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double _fontSize = 18;
  double _fontSize2 = 20;
  double _fontSize3 = 24;


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
                style: TextStyle(fontSize: _fontSize2,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Kod kreskowy: ${product?.barcode}',
                style: TextStyle(fontSize: _fontSize),
              ),
              SizedBox(height: 8),
              Text(
                'Producent: ${product!.brands}',
                style: TextStyle(fontSize: _fontSize),
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
                          fontSize: _fontSize3,
                          color: Colors.yellow,
                        ),
                      );
                    } else {
                      return Text(
                        "Alergeny: " + matchingAllergens.join(", "),
                        style: TextStyle(
                            fontSize: _fontSize3,
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
                style: TextStyle(fontSize: _fontSize),
              ),
              SizedBox(height: 8),
            ],
            if (product == null)
              Column(
                children: <Widget>[
                  Text('Brak informacji o produkcie ${widget.scanResult}',
                    style: TextStyle(fontSize: _fontSize),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Wyślij zgłoszenie brakującego produktu'),
                    onPressed: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: 'justynago61@gmail.com',
                        query: 'subject=Brakujący produkt: ${widget.scanResult}&body=Cześć, proszę o dodanie produktu o kodzie kreskowym ${widget.scanResult} na stronie OpenFoodFacts.'
                      );
                      // final email = 'justynago61@gmail.com';
                      // final subject = 'Brakujący produkt: ${widget.scanResult}';
                      // final body = 'Cześć, proszę o dodanie produktu o kodzie kreskowym ${widget.scanResult} na stronie OpenFoodFacts.';
                      // final launchUrl = 'mailto:$email?subject=$subject&body=$body';
                      var url = params.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Zgłoszenie zostało wysłane"))
                        );
                      } else {
                        throw 'Could not launch $launchUrl';
                      }
                    },
                  ),
                ],
              ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _fontSize += 2;
                          _fontSize2 += 2;
                          _fontSize3 += 2;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _fontSize -= 2;
                          _fontSize2 -= 2;
                          _fontSize3 -= 2;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
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
