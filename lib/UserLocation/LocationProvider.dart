import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationProvider extends ChangeNotifier {
  final String googleMapsApiKey = 'AIzaSyCO2v58cOsSM5IKXwyGa172U_YHrmRK9ks';
  late double Lat;
  late double Long;

  Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    /* print(position.longitude);
    print(position.latitude);*/

    // Get the address from the coordinates using Google Maps API
    String location = await getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    //print(location);

    return location;
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    Lat = lat;
    Long = lng;
    /* print(Lat);
    print(Long);*/

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final String address = data['results'][0]['formatted_address'] +
            '  ' +
            data['results'][0]['address_components'][1]['long_name'];
        return address;
      } else {
        return 'No address available';
      }
    } else {
      return 'Failed to get address';
    }
  }

  ///ADDING MAKERS HERE
}
