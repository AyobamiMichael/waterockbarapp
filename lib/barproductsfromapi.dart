import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

class BarproductsFromApi {
  Future<List<Barproducts>> getBarproducts() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('https://waterockapi.wegotam.com/barproducts');
      final response = await client.get(uri);
      print('OKAY');
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        //print(jsonList);

        List<Barproducts> barproductslist =
            jsonList.map((jsonMap) => Barproducts.fromJson(jsonMap)).toList();
        //print(BarproductsList);
        //  for (var product in BarproductsList) {
        //  print(
        //    'ProductId: ${product.id}, ProductName: ${product.productName}');
        // }
        return barproductslist;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (erorr) {
      print(erorr);
      return [];
    }

    // print('OKAY FETCH');
  }

  void sayHello() {
    // print('HELLO');
  }
}
