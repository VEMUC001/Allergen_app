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

  @override
  void initState() {
    super.initState();
    getProductInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      //         Text(
      //           'Alergeny: ${product.allergens}',
      //           style: TextStyle(fontSize: 18),
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
      setState(() => this.product = product);
    } catch (e) {
      print(e);
    }
  }
}
