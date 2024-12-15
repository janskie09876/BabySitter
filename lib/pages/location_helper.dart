import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  static const String apiKey = 'AIzaSyD0KmvLb2mNVZY0Y3Fzzw4ih41-12N-vyg';

  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }
}
