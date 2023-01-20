
import 'package:openfoodfacts/openfoodfacts.dart';

// gets product name based on barcode
Future<Product> getProduct(var barcode) async {
  ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
  ProductResult result = await OpenFoodAPIClient.getProduct(configuration);
  return result.product!;
}