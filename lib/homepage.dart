import 'package:flutter/material.dart';
import 'package:waterockbarmanagerapp/allbarsfromapi.dart';
import 'package:waterockbarmanagerapp/bardetailspage.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:waterockbarmanagerapp/mainpage.dart';
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

List<String> suggestionList = [];

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  static String barName = '';
  static String barAddress = '';
  static String barPhone = '';
  static String barImage = '';
  final List<String> imageNames = [
    'africandish2.png',
    'continentaldish1.jpg',
    'palmwine2.jpg',
  ];

  final List<String> productsDisplayNames = [
    'African',
    'Continental',
    'Palm Wine',
  ];

  late BarproductsFromApi barproductsFromApi;
  List<Barproducts>? barProductsList;
  List<Barproducts>? barProductsListFiltered;
  List<String> categorySelectedList = [];

  List<String> otherProductNameList = [];
  List<String> id = [];
  List<String> barManagerUserNameList = [];

  static var productNameSelected = '';

  @override
  void initState() {
    super.initState();
    barproductsFromApi = BarproductsFromApi();
    barproductsFromApi.getBarproducts();

    fetchData();
  }

  void fetchData() async {
    barProductsList = await BarproductsFromApi().getBarproducts();
    setState(() {
      for (var product in barProductsList!) {
        categorySelectedList.add(product.catSelected);
        // productPriceList.add(product.productPrice);
        otherProductNameList.add(product.otherProductName);
        barManagerUserNameList.add(product.barManagerUserName);
      }
    });

    print(categorySelectedList);
  }

  void filterOutFoodInfo(String productNameSelected) async {
    List<Map<String, dynamic>> allbarsFiltered = barProductsList!
        .where((element) => element.catSelected == productNameSelected)
        .map((e) {
      return {
        'productPrice': e.productPrice,
        'otherProductName': e.otherProductName,
        'barManagerUserName': e.barManagerUserName
      };
    }).toList();

    print(allbarsFiltered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WaterockBars'),
        ),
        backgroundColor: Colors.black,
        body: ListView.builder(
            itemCount: imageNames.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    print('Image $index clicked');
                    setState(() {
                      productNameSelected = productsDisplayNames[index];
                    });
                    print(productNameSelected);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPageWidget()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Image.asset(
                            'assets/images/${imageNames[index]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                            height:
                                10), // Adds some space between the image and the name
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 1), // Border for the container
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productsDisplayNames[index],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
