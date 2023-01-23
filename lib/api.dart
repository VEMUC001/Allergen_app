import 'package:openfoodfacts/model/ProductResultV3.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

Future<Product?> getProduct(String barcode) async {

  final ProductQueryConfiguration configuration = ProductQueryConfiguration(
    barcode,
    language: OpenFoodFactsLanguage.POLISH,
    fields: [ProductField.ALL],
    version: ProductQueryVersion.v3,
  );
  final ProductResultV3 result =
  await OpenFoodAPIClient.getProductV3(configuration);

  if (result.status == ProductResultV3.statusSuccess) {
    return result.product;
  } else {
    throw Exception('product not found, please insert data for $barcode');
  }
}





