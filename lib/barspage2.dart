import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waterockbarmanagerapp/allbarsfromapi.dart';
import 'package:waterockbarmanagerapp/bardetailspage.dart';
import 'package:waterockbarmanagerapp/barproductsfromapi.dart';
import 'package:waterockbarmanagerapp/mainpage.dart';
import 'package:waterockbarmanagerapp/models/allbarsmodel.dart';
import 'package:waterockbarmanagerapp/models/barproductsmodel.dart';
import 'package:waterockbarmanagerapp/models/locationdistancemodel.dart';
import 'package:http/http.dart' as http;

class Bar {
  final String name;
  final String address;
  final String productPrice;
  final String phone;
  final String image;

  Bar({
    required this.name,
    required this.address,
    required this.productPrice,
    required this.phone,
    required this.image,
  });
}

class BarTile extends StatelessWidget {
  final Bar bar;

  static String barName = '';
  static String barAddress = '';
  static String barPhone = '';
  static String barImage = '';

  BarTile({required this.bar});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color.fromARGB(213, 173, 211, 7), width: 2.0),
      ),
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/choplife.png'),
      ),
      title: Text(
        '${bar.name} ${'NGN'}${bar.productPrice}',
        style: const TextStyle(
            fontSize: 20, color: Color.fromARGB(255, 243, 33, 156)),
      ),
      subtitle: Text(bar.address,
          style: const TextStyle(
              color: Color.fromARGB(218, 15, 14, 15),
              fontSize: 13,
              fontWeight: FontWeight.bold)),
      onTap: () {
        // print('NAME SELECTED' + bar.name);
        barName = bar.name;
        barAddress = bar.address;
        barImage = bar.image;
        barPhone = bar.phone;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BarDetailsPageWidget()));
      },
    );
  }
}

class BarPageWidget2 extends StatefulWidget {
  const BarPageWidget2({Key? key}) : super(key: key);

  @override
  State<BarPageWidget2> createState() => _BarsPageWidgetState();
}

class _BarsPageWidgetState extends State<BarPageWidget2> {
  List<Bar> bars = [];
  bool isLoading = true;
  String distanceResult = '';
  late Position _currentPosition;
  String currentAddress = '';
  List<String> listOFBarAddresses = [''];

  @override
  void initState() {
    super.initState();
    fetchData();
    //getAddress();
  }

  Future<void> fetchData() async {
    try {
      // Fetch bar products
      List<Barproducts>? barProductsList =
          await BarproductsFromApi().getBarproducts();

      String productNameSelected = MainPageWidgetState.productNameSelected;

      List<Barproducts> filteredBarProducts = barProductsList
          .where((element) => element.catSelected == productNameSelected)
          .toList();

      await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
      });

      try {
        List<Placemark> p = await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);

        Placemark place = p[0];
        // print('Placemarks: $place');

        currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        print('CURRENT ADDRESS ' + currentAddress);
      } catch (e) {
        print(e);
      }

      for (var fb in filteredBarProducts) {
        print(fb.catSelected);
      }

      // Fetch bar details
      List<Allbars>? allBarsList = await AllBarsFromApi().getAllbars();

      // Map bar details to Bar objects
      /*for (var barProduct in filteredBarProducts) {
        Allbars? correspondingBar = allBarsList?.firstWhere(
            (e) => e.barName == barProduct.barName);

        if (correspondingBar != null) {
          bars.add(Bar(
            name: barProduct.barName,
            address: correspondingBar.barAddress,
            productPrice: barProduct.productPrice,
          ));
        }
      }*/

      for (var barProduct in filteredBarProducts) {
        var correspondingBars =
            allBarsList?.where((e) => e.barName == barProduct.barName);

        // Add bar addresses to bars
        correspondingBars?.forEach((bar) async {
          // listOFBarAddresses.add(bar.barAddress);
          print(bar.barAddress);
          /* String destinationWithoutSpace = bar.barAddress.replaceAll(' ', '');

          var client = http.Client();
          var uri = Uri.parse(
              'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationWithoutSpace&origins=$currentAddress&units=metric&key=AIzaSyC4UDVcK8A0aORjJSYUqC7byLkeYEzlYJE');

          var response = await client.get(uri);

          if (response.statusCode == 200) {
            var json = response.body;
            final mapdata = addressFromJson(json);
            distanceResult = mapdata.rows[0]['elements'][0]['distance']['text'];
          }

          print('DISTANCES ' + distanceResult);
           */
          // print(bar.barAddress);
          setState(() {
            bars.add(Bar(
              name: barProduct.barName,
              address: bar.barAddress,
              productPrice: barProduct.productPrice,
              phone: bar.barPhone,
              image: bar.barImage,
            ));
          });
        });
        // getAddress();
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching data: $error');
    }
  }

  Future<void> getAddress() async {
    print(listOFBarAddresses);
    try {
      for (var barAddress in listOFBarAddresses) {
        String destinationWithoutSpace = barAddress.replaceAll(' ', '');

        var client = http.Client();
        var uri = Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationWithoutSpace&origins=$currentAddress&units=metric&key=AIzaSyC4UDVcK8A0aORjJSYUqC7byLkeYEzlYJE');

        var response = await client.get(uri);

        if (response.statusCode == 200) {
          var json = response.body;
          final mapdata = addressFromJson(json);
          distanceResult = mapdata.rows[0]['elements'][0]['distance']['text'];
        }

        print('DISTANCES ' + distanceResult);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waterock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: bars.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BarTile(bar: bars[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
