import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';

class AllBarsFromApi {
  Future<List<Allbars>> getAllbars() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('https://waterockapi.wegotam.com/allbars');
      final response = await client.get(uri);
      print('OKAY');
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        //print(jsonList);

        List<Allbars> allbarslist =
            jsonList.map((jsonMap) => Allbars.fromJson(jsonMap)).toList();
        //print(AllbarsList);
        //  for (var product in AllbarsList) {
        //  print(
        //    'ProductId: ${product.id}, ProductName: ${product.productName}');
        // }
        return allbarslist;
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
