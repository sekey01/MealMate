import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationProvider extends ChangeNotifier {
  final String googleMapsApiKey = 'AIzaSyCO2v58cOsSM5IKXwyGa172U_YHrmRK9ks';
  late double Lat ;
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





  bool isFareDistance = true;
  late double Distance;

  double calculateDistance(LatLng point1, LatLng point2) {
    const double R = 6371; // Radius of the Earth in kilometers

    // Convert degrees to radians
    double lat1Rad = point1.latitude * (22/7) / 180;
    double lon1Rad = point1.longitude * (22/7)  / 180;
    double lat2Rad = point2.latitude * (22/7)  / 180;
    double lon2Rad = point2.longitude * (22/7)  / 180;

    // Differences in coordinates
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    double distance = R * c ;
    Distance = distance;
    print('Distance isssssssssss ${Distance} km');

    if( distance > 30){
      isFareDistance = false;
      print('Greater than 30km');
     // print(distance);
    }
    else {
      isFareDistance = true;
      print('Less than 30km');
//print(distance)
    }

    return distance;
  }


  }


