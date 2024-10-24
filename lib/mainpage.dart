import 'package:flutter/material.dart';
import 'package:waterockbarmanagerapp/allbarsfromapi.dart';
import 'package:waterockbarmanagerapp/bardetailspage.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:waterockbarmanagerapp/homepage.dart';
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

List<String> suggestionList = [];

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => MainPageWidgetState();
}

class MainPageWidgetState extends State<MainPageWidget> {
  static String barName = '';
  static String barAddress = '';
  static String barPhone = '';
  static String barImage = '';
  final List<String> foodsImagesList = [];
  final List<String> foodsDisplayNamesList = [];
  /* final List<String> imageNames = [
    'abacha.jpeg',
    'asunmeat.jpeg',
    'beefshawarma.jpeg',
    'chickenshawarma.jpg',
    'grilledchickenparts.jpeg',
    'swallow.jpeg',
    'nkwobi.jpeg',
    'okpa1.jpeg',
    'riceandstew.jpeg',
    'ukwa2.jpeg',
    'crookerfish2.jpeg',
    'pepperedsnail.jpeg',
    'freshfish2.jpeg',
    'cowlegpeppersoup2.jpeg',
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
  ];*/

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
    populateFoodsImagesAndDisplayNamesList();
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

  void populateFoodsImagesAndDisplayNamesList() {
    if (HomepageState.productNameSelected == 'African') {
      foodsImagesList.add('abacha.jpeg');
      foodsImagesList.add('swallow.jpeg');
      foodsImagesList.add('nkwobi.jpeg');
      foodsImagesList.add('okpa1.jpeg');
      foodsImagesList.add('pepperedsnail.jpeg');
      foodsImagesList.add('cowlegpeppersoup2.jpeg');
      foodsImagesList.add('asunmeat.jpeg');
      foodsImagesList.add('ukwa2.jpeg');
      foodsImagesList.add('Zobodrink.jpeg');

      foodsDisplayNamesList.add('Abacha');
      foodsDisplayNamesList.add('Swallow');
      foodsDisplayNamesList.add('Nkwobi');
      foodsDisplayNamesList.add('Okpa');
      foodsDisplayNamesList.add('Peppered Snail');
      foodsDisplayNamesList.add('Cowleg Pepper soup');
      foodsDisplayNamesList.add('Asuun(Peppered meat)');
      foodsDisplayNamesList.add('Ukwa');
      foodsDisplayNamesList.add('Zobo');
    }
    if (HomepageState.productNameSelected == 'Continental') {
      foodsImagesList.add('beefshawarma.jpeg');
      foodsImagesList.add('chickenshawarma.jpg');
      foodsImagesList.add('grilledchickenparts.jpeg');
      foodsImagesList.add('riceandstew.jpeg');
      foodsImagesList.add('crookerfish2.jpeg');
      foodsImagesList.add('freshfish2.jpeg');

      foodsDisplayNamesList.add('Beef Sharwama');
      foodsDisplayNamesList.add('Chicken Sharwama');
      foodsDisplayNamesList.add('Grilled Chickenparts');
      foodsDisplayNamesList.add('Rice and stew');
      foodsDisplayNamesList.add('Crooker fish');
      foodsDisplayNamesList.add('Fresh fish');
    }
    if (HomepageState.productNameSelected == 'Palm Wine') {
      foodsImagesList.add('palmwine2.jpg');
      // Not yet on the data base.
      foodsDisplayNamesList.add('Palm Wine');
    }
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
        backgroundColor: Colors.black,
        body: ListView.builder(
            itemCount: foodsImagesList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    print('Image $index clicked');
                    setState(() {
                      productNameSelected = foodsDisplayNamesList[index];
                    });
                    print(productNameSelected);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BarPageWidget2()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Image.asset(
                            'assets/images/${foodsImagesList[index]}',
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
                            foodsDisplayNamesList[index],
                            style: const TextStyle(
                                fontSize: 16,
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

class SearchDelegateWidget extends SearchDelegate {
  final MainPageWidgetState _mainPageWidgetState;
  List<Bar> filteredBars = []; // Updated list for filtered bars
  bool isLoading = true;
  final SearchingData _searchingData = SearchingData();

  SearchDelegateWidget(this._mainPageWidgetState);

  @override
  List<Widget> buildActions(BuildContext context) {
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
    // Now buildResults waits for the data to be loaded
    return FutureBuilder(
      future: _fetchAndFilterData(query), // Updated to use the new method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filteredBars.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return ListView.builder(
          itemCount: filteredBars.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  '${filteredBars[index].name} NGN${filteredBars[index].productPrice}',
                  style: const TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  close(context, filteredBars[index].name);
                },
                subtitle: Text(filteredBars[index].address),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Enter a search term.'));
    }

    // buildSuggestions also waits for the data to be loaded
    return FutureBuilder(
      future: _fetchAndFilterData(query), // Updated to use the new method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filteredBars.isEmpty) {
          return const Center(
            child: Text('No suggestions found'),
          );
        }

        return ListView.builder(
          itemCount: filteredBars.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  '${filteredBars[index].name} NGN${filteredBars[index].productPrice}',
                  style: const TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  query = filteredBars[index].name;

                  fetchDataForBar(filteredBars[index].name);

                  BarTile.barName = filteredBars[index].name;
                  BarTile.barAddress = MainPageWidgetState.barAddress;
                  BarTile.barImage = MainPageWidgetState.barImage;
                  BarTile.barPhone = MainPageWidgetState.barPhone;

                  print(filteredBars[index].name);
                  showResults(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BarDetailsPageWidget()));
                },
                subtitle: Text(filteredBars[index].address),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchDataForBar(String barName) async {
    try {
      // Fetch bar details
      List<Allbars>? allBarsList = await AllBarsFromApi().getAllbars();

      // Find the corresponding bars by name
      var correspondingBars = allBarsList.where((e) => e.barName == barName);

      for (var bar in correspondingBars) {
        print(bar.barAddress);
        MainPageWidgetState.barAddress = bar.barAddress;
        MainPageWidgetState.barImage = bar.barImage;
        MainPageWidgetState.barPhone = bar.barPhone;
      }
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
    }
  }

  // New method to fetch and filter data based on the query
  Future<void> _fetchAndFilterData(String query) async {
    try {
      List<Bar> bars = await _searchingData.fetchDataToSearch2(query);
      filteredBars = bars; // Update filteredBars with the fetched data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}

class SearchingData {
  // Now fetchDataToSearch2 returns a List of Bar objects
  Future<List<Bar>> fetchDataToSearch2(String query) async {
    List<Bar> bars = [];
    try {
      // Fetch bar products
      List<Barproducts>? barProductsList =
          await BarproductsFromApi().getBarproducts();

      // Filter bar products by matching query with bar name or category
      List<Barproducts> filteredBarProducts = barProductsList
          .where((element) =>
              element.catSelected.toLowerCase().contains(query.toLowerCase()))
          .toList();

      for (var barProduct in filteredBarProducts) {
        bars.add(Bar(
          name: barProduct.barName,
          address: '', // You can modify this if you need to show address
          productPrice: barProduct.productPrice,
          phone: '',
          image: '',
        ));
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    return bars; // Return the filtered list of bars
  }
}
