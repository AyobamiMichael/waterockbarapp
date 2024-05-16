import 'package:flutter/material.dart';
import 'package:waterockbarmanagerapp/barmaps.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';
import 'package:permission_handler/permission_handler.dart';

class BarDetailsPageWidget extends StatefulWidget {
  const BarDetailsPageWidget({super.key});

  @override
  State<BarDetailsPageWidget> createState() => _BarDetailsPageWidgetState();
}

class _BarDetailsPageWidgetState extends State<BarDetailsPageWidget> {
  @override
  void initState() {
    super.initState();

    print(BarTile.barPhone);
    print(BarTile.barImage);
    requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WATEROCK'),
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
                    'BAR NAME ${BarTile.barName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ADDRESS ${BarTile.barAddress}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PHONE ${BarTile.barPhone}',
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart functionality here
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BarMap()));
                      print('map');
                    },
                    child: const Text('Google Map'),
                  ),
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
}
