import 'package:flutter/material.dart';
import 'package:waterockbarmanagerapp/allbarsfromapi.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/mainpage.dart';
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';

class BarsPageWidget extends StatefulWidget {
  const BarsPageWidget({super.key});

  @override
  State<BarsPageWidget> createState() => _BarsPageWidgetState();
}

class _BarsPageWidgetState extends State<BarsPageWidget> {
  List<Barproducts>? barProductsList;
  List<Map<String, dynamic>> allbarsFiltered = [];
  late BarproductsFromApi barproductsFromApi;

  late AllBarsFromApi allBarsFromApi;
  List<Allbars>? allBarsList;
  List<String> barNameList = [];
  List<String> barAddressList = [];
  List<String> barStateList = [];
  List<String> barPhoneList = [];
  List<String> barImageList = [];
  List<String> allBarsbarManagerUserNameList = [];

  List<Map<String, dynamic>> extractedBarsDetails = [];
  List<String> productPriceList = [];

  @override
  void initState() {
    super.initState();
    barproductsFromApi = BarproductsFromApi();
    barproductsFromApi.getBarproducts();
    allBarsFromApi = AllBarsFromApi();
    allBarsFromApi.getAllbars();
    filterOutFoodInfo(MainPageWidgetState.productNameSelected);
    filterOutBarInfo();
  }

  void filterOutFoodInfo(String productNameSelected) async {
    barProductsList = await BarproductsFromApi().getBarproducts();
    setState(() {
      allbarsFiltered = barProductsList!
          .where((element) => element.catSelected == productNameSelected)
          .map((e) {
        return {
          'productPrice': e.productPrice,
          'otherProductName': e.otherProductName,
          'barManagerUserName': e.barManagerUserName
        };
      }).toList();

      for (var barsfiltered in allbarsFiltered) {
        productPriceList.add(barsfiltered['productPrice']);
      }
    });

    print(allbarsFiltered.length);
  }

  void filterOutBarInfo() async {
    allBarsList = await AllBarsFromApi().getAllbars();
    setState(() {
      for (var bar in allbarsFiltered) {
        String barManagerUserName = bar['barManagerUserName'];
        var correspondingEntry = allBarsList!
            .firstWhere((e) => e.barManagerUserName == barManagerUserName);
        barNameList.add(correspondingEntry.barName);
        barAddressList.add(correspondingEntry.barAddress);
      }

      print(barNameList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WaterockBars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allbarsFiltered.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      tileColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      leading: const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/images/freshfish1.jpg'),
                      ),

                      title: Text(
                        '${barNameList[index]} ${productPriceList[index]}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(barAddressList[index],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 206, 45, 125),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)), // list of items
                      onTap: () => {},
                    );
                  }))
        ],
      ),
    );
  }
}
