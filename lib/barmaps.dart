import 'package:flutter/material.dart';
//import 'package:flutter_maps/secrets.dart'; // Stores the Google Maps API Key
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waterockbarmanagerapp/barspage2.dart';

class BarMap extends StatefulWidget {
  const BarMap({Key? key}) : super(key: key);

  @override
  BarMapState createState() => BarMapState();
}

class BarMapState extends State<BarMap> {
  LatLng initialLocation = const LatLng(0, 0);
  LatLng destinationLocation = const LatLng(0, 0); // Default initialization
  //final _storage = const FlutterSecureStorage();
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getCoordinates();
  }

  getCoordinates() async {
    try {
      //String address = await _storage.read(key: 'SHOP_ADDRESS') ?? '';
      print('LOCATIONADDRESS${BarTile.barAddress}');
      List<Location> locations = await locationFromAddress(BarTile.barAddress);
      setState(() {
        initialLocation =
            LatLng(locations.first.latitude, locations.first.longitude);
      });

      // Fetch and set the current location
      Position currentPosition = await getCurrentLocation();
      setState(() {
        destinationLocation =
            LatLng(currentPosition.latitude, currentPosition.longitude);
      });

      // Draw polyline
      drawPolyline();
    } catch (e) {
      print("Error fetching coordinates: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void drawPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();

    // Create a PolylineRequest object with the required parameters
    PolylineRequest polylineRequest = PolylineRequest(
      origin: PointLatLng(initialLocation.latitude, initialLocation.longitude),
      destination: PointLatLng(
          destinationLocation.latitude, destinationLocation.longitude),
      mode: TravelMode.driving,
    );

    // Pass the polylineRequest object to the method
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: polylineRequest,
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        polylines.add(Polyline(
          polylineId: const PolylineId("poly"),
          color: Colors.blue,
          width: 3,
          points: polylineCoordinates,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error: Unable to fetch route. Please try again.')));
    }
  }

  /*void drawPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyC4UDVcK8A0aORjJSYUqC7byLkeYEzlYJE',
      PointLatLng(initialLocation.latitude, initialLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        polylines.add(Polyline(
          polylineId: const PolylineId("poly"),
          color: Colors.blue,
          width: 3,
          points: polylineCoordinates,
        ));
      });
    } else {
      print("Error: Unable to fetch polyline coordinates");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('bar'),
            position: initialLocation,
            draggable: true,
            onDragEnd: (value) {},
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destinationLocation,
            draggable: true,
            onDragEnd: (value) {},
          ),
        },
        polylines: polylines,
        myLocationEnabled: true, // Show current location button
        myLocationButtonEnabled: true, // Enable current location
        onMapCreated: (GoogleMapController controller) async {
          // Fetch and set the current location
          Position currentPosition = await getCurrentLocation();
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 14,
              ),
            ),
          );
        },
      ),
    );
  }
}
