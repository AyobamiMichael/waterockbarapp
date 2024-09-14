import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waterockbarmanagerapp/barmaps.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waterockbarmanagerapp/models/locationdistancemodel.dart'
    hide Row;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BarDetailsPageWidget extends StatefulWidget {
  const BarDetailsPageWidget({super.key});

  @override
  State<BarDetailsPageWidget> createState() => _BarDetailsPageWidgetState();
}

class _BarDetailsPageWidgetState extends State<BarDetailsPageWidget> {
  String distanceResult = '';
  late Position _currentPosition;
  String currentAddress = '';
  @override
  void initState() {
    super.initState();

    print(BarTile.barPhone);
    print(BarTile.barImage);
    requestLocationPermission();
    getBarDistance(BarTile.barAddress);
  }

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WATEROCK'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BarTile.barImage.isNotEmpty
                ? Image.network(
                    'https://waterockapi.wegotam.com/uploads/${BarTile.barImage.substring(8)}',
                    height: 200,
                    width: 20,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '            ${BarTile.barName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                    color: Colors.grey[300],
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'ADDRESS: ${BarTile.barAddress}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    height: 15,
                    thickness: 2,
                    color: Colors.grey[300],
                    indent: 20,
                    endIndent: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'PHONE: ${BarTile.barPhone}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.blue),
                        onPressed: () {
                          // Launch the phone dialer with the phone number
                          _launchDialer(BarTile.barPhone);
                        },
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey[300],
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(
                    'Distance: $distanceResult',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey[300],
                    indent: 20,
                    endIndent: 20,
                  ),
                  /* SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      icon: const Icon(Icons.location_searching,
                          size: 40, color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: () {
                        // Add to cart functionality here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BarMap()));
                        print('map');
                      },
                    ),
                  ),*/
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor:
                                const Color.fromARGB(255, 228, 234, 238)),
                        onPressed: () {
                          // Add to cart functionality here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BarMap()));
                          print('map');
                        },
                        child: const Text('Google Map',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    final locationStatus = await Permission.location.request();
    print('LOCATION PROCESSING');
    if (locationStatus == PermissionStatus.granted) {
      // Proceed with accessing location data
      print('Location permission granted');
    } else if (locationStatus == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied permission
      openAppSettings(); // Open app settings to allow permission manually
    } else {
      // Handle other permission status (denied, etc.)
    }
  }

  Future<void> getBarDistance(String barAddress) async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
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
      print('CURRENT ADDRESS $currentAddress');
    } catch (e) {
      print(e);
    }

    String destinationWithoutSpace = barAddress.replaceAll(' ', '');

    var client = http.Client();
    var uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationWithoutSpace&origins=$currentAddress&units=metric&key=AIzaSyC4UDVcK8A0aORjJSYUqC7byLkeYEzlYJE');

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      final mapdata = addressFromJson(json);
      setState(() {
        distanceResult = mapdata.rows[0]['elements'][0]['distance']['text'];
      });
    }

    print('DISTANCES $distanceResult');
  }
}
