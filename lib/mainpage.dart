import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waterockbarmanagerapp/allbarsfromapi.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/barspage.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

List<String> suggestionList = [];

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
    'pepperedsnail.png',
    'freshfish2.png',
    'cowlegpeppersoup2.jpg',
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
    'Peppered Snail',
    'Fresh fish',
    'Cowleg Pepper soup'
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
              showSearch(
                  context: context, delegate: SearchDelegateWidget(this));

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
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Expanded(
                          child: Image.asset(
                              'assets/images/${imageNames[index]}',
                              width: 180,
                              height: 180),
                        ),
                        const SizedBox(
                            width:
                                10), // Adjust spacing between image and subtitle
                        Text(
                          productsDisplayNames[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])));
            }));
  }
}

class SearchDelegateWidget extends SearchDelegate {
  final MainPageWidgetState _mainPageWidgetState;

  List<String> newFilterList = [];
  // List<Bar> bars = [];
  bool isLoading = true;
  //final _storage = const FlutterSecureStorage();
  final SearchingData _searchingData = SearchingData();

  SearchDelegateWidget(this._mainPageWidgetState);
  void filtterItems(String query) {
    newFilterList = suggestionList
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print(newFilterList);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //fetchDataToSearch();

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _searchingData.fetchDataToSearch2(query);

    return ListView.builder(
        itemCount: _searchingData.bars.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                '${_searchingData.bars[index].name} NGN${_searchingData.bars[index].productPrice}',
                style: const TextStyle(color: Colors.blue),
              ),
              onTap: () {
                //close(context, searchResult[index]);
                print('okay');
              },
              subtitle: Text(_searchingData.bars[index].address),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //fetchDataToSearch();
    _searchingData.fetchDataToSearch2(query);
    /* final List<Bar> newSuggestionList = query.isEmpty
        ? []
        : _searchingData.bars
            .where((element) =>
                element.name.contains(query) || element.address.contains(query))
            .toList();*/
    final List<Bar> newSuggestionList =
        query.isEmpty ? [] : _searchingData.bars.toList();

    List<String>? newSuggestionPriceList =
        newSuggestionList.map((e) => e.productPrice).toList();

    List<int> intPriceList = [];
    for (var item in newSuggestionPriceList) {
      intPriceList.add(int.parse(item));
    }
    intPriceList.sort((a, b) => a.compareTo(b));
    //print(newSuggestionList);
    if (newSuggestionList.isEmpty) {
      return const Center(
        child: Text('No suggestions found'),
      );
    }

    newSuggestionList.sort((a, b) =>
        int.parse(a.productPrice).compareTo(int.parse(b.productPrice)));

    return ListView.builder(
        itemCount: newSuggestionList.length,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  '${newSuggestionList[index].name} NGN${newSuggestionList[index].productPrice}',
                  style: const TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  query = newSuggestionList[index].name;
                  print('okay sug');
                  /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubCategoryTypePage()));
                  listViewindexSelected = index;
                       

                  _storage.write(
                      key: 'SHOP_ADDRESS',
                      value: newSuggestionList[index].shopAddress);*/
                },
                subtitle: Text(newSuggestionList[index].name),
              ));
        });
  }
}

class SearchingData {
  List<Bar> bars = [];
  Future<void> fetchDataToSearch(String query) async {
    // print('FECTHDATATOSEARCH');
    try {
      // Fetch bar products
      List<Barproducts>? barProductsList =
          await BarproductsFromApi().getBarproducts();
      // Fetch bar details
      List<Allbars>? allBarsList = await AllBarsFromApi().getAllbars();

      //String productNameSelected = MainPageWidgetState.productNameSelected;
      // Use query to fillter bar products, user can enter productname or area
      print(query);
      List<Barproducts> filteredBarProducts = barProductsList
          .where((element) => element.catSelected == query)
          .toList();

      for (var barProduct in filteredBarProducts) {
        var correspondingBars =
            allBarsList.where((e) => e.barName == barProduct.barName);

        // Add bar addresses to bars
        correspondingBars.forEach((bar) async {
          // listOFBarAddresses.add(bar.barAddress);
          print(bar.barAddress);

          bars.add(Bar(
            name: barProduct.barName,
            address: bar.barAddress,
            productPrice: barProduct.productPrice,
            phone: bar.barPhone,
            image: bar.barImage,
          ));
        });
        // getAddress();
      }

      //isLoading = false;
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchDataToSearch2(String query) async {
    try {
      // Fetch bar products
      List<Barproducts>? barProductsList =
          await BarproductsFromApi().getBarproducts();
      // Fetch bar details
      //List<Allbars>? allBarsList = await AllBarsFromApi().getAllbars();

      print(query);
      List<Barproducts> filteredBarProducts = barProductsList
          .where((element) => element.catSelected == query)
          .toList();
      //print(filteredBarProducts);
      for (var barProduct in filteredBarProducts) {
        //var correspondingBars =
        //  allBarsList.where((e) => e.barName == barProduct.barName);

        //print(bar.barAddress);
        print(barProduct.barName);
        bars.add(Bar(
          name: barProduct.barName,
          address: '',
          productPrice: barProduct.productPrice,
          phone: '',
          image: '',
        ));

        // getAddress();
      }

      //isLoading = false;
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
    }
  }
}
