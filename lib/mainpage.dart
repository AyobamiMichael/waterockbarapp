import 'package:flutter/material.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/barspage.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => MainPageWidgetState();
}

class MainPageWidgetState extends State<MainPageWidget> {
  final List<String> imageNames = [
    'abacha.png',
    'asunmeat.jpg',
    'beefshawarma.jpg',
    'chickenshawarma.jpg',
    'grilledchickenparts.jpg',
    'swallow.png',
    'nkwobi.png',
    'okpa1.png',
    'riceandstew.png',
    'ukwa2.png',
    'crookerfish2.png',
    'pepperedsnail.png'
  ];

  final List<String> productsDisplayNames = [
    'Abacha',
    'Asuun(Peppered meat)',
    'Beef Sharwama',
    'Chicken Sharwama',
    'Grilled Chickenparts',
    'Swallow',
    'Nkwobi',
    'Okpa',
    'Rice and stew',
    'Ukwa',
    'Crooker fish',
    'Peppered Snail'
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
        appBar: AppBar(title: const Text('WaterockBars'), actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('OKAY SEARCH');
            },
          )
        ]),
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
                            builder: (context) => const BarPageWidget2()));
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(children: [
                        Expanded(
                          child: Image.asset(
                              'assets/images/${imageNames[index]}',
                              width: 180,
                              height: 180),
                        ),
                        SizedBox(
                            width:
                                10), // Adjust spacing between image and subtitle
                        Text(
                          productsDisplayNames[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])));
            }));
  }
}
