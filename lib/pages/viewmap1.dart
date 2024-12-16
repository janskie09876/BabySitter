import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/pages/profiledialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ViewMap1 extends StatefulWidget {
  const ViewMap1({super.key});

  @override
  State<ViewMap1> createState() => _ViewMap1State();
}

class _ViewMap1State extends State<ViewMap1> {
  Set<Marker> markers = Set();
  Set<Circle> circles = Set();
  GoogleMapController? mapController;
  LatLng location = const LatLng(7.313675416878131, 125.67034083922026);
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  String locationMsg = 'Current Location of User';
  late String lat;
  late String long;
  double _radius = 500; // Default radius for geofence
  BitmapDescriptor? currentLocationIcon;

  // Load custom location icon
  Future<void> _loadCustomIcons() async {
    currentLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/mylocation.bmp");
  }

  // Get user's current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Add a geofence circle
  void _addGeofenceCircle(LatLng position) {
    setState(() {
      circles = {
        Circle(
          circleId: const CircleId("geofence"),
          center: position,
          radius: _radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        )
      };
    });
    _filterMarkers();
  }

  // Filter markers based on geofence radius and Firestore data
  void _filterMarkers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('babysitters').get();

      setState(() {
        markers.clear();
        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final double latitude = data['latitude'] ?? 0.0;
          final double longitude = data['longitude'] ?? 0.0;

          final distance = Geolocator.distanceBetween(
            location.latitude,
            location.longitude,
            latitude,
            longitude,
          );

          if (distance <= _radius) {
            markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(latitude, longitude),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(title: data['name'] ?? 'Babysitter'),
                onTap: () => _showProfileDialog(doc.id),
              ),
            );
          }
        }
      });
    } catch (e) {
      print('Error fetching babysitters: $e');
    }
  }

  // Add user's current location marker
  void addMyMarker(LatLng myLoc) {
    setState(() {
      markers.add(
        Marker(
          icon: currentLocationIcon ?? BitmapDescriptor.defaultMarker,
          markerId: const MarkerId('current_location'),
          position: myLoc,
          draggable: false,
          visible: true,
          infoWindow: const InfoWindow(title: "Your Current Location"),
        ),
      );
      _addGeofenceCircle(myLoc);
    });

    _filterMarkers();
  }

  // Live location updates
  void _liveLocation() {
    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
        lat = position.latitude.toString();
        long = position.longitude.toString();
        setState(() {
          location = LatLng(position.latitude, position.longitude);
          locationMsg = 'Lat: $lat , Long: $long';
          _customInfoWindowController.googleMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: location, zoom: 15.0)));

          addMyMarker(location);
        });
      });
    } catch (e) {
      print('Error in live location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating live location: $e')),
      );
    }
  }

  // Show babysitter profile dialog
  void _showProfileDialog(String babysitterId) {
    showDialog(
      context: context,
      builder: (context) => ProfileDialog(
        babysitterId: babysitterId, // Pass the babysitterId dynamically
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadCustomIcons();

    _getCurrentLocation().then((value) {
      lat = '${value.latitude}';
      long = '${value.longitude}';
      setState(() {
        location = LatLng(value.latitude, value.longitude);
        locationMsg = 'Lat: $lat , Long: $long';
        _addGeofenceCircle(location);
      });
      _liveLocation();
    }).catchError((error) {
      print('Error getting initial location: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 180.0,
                width: double.infinity,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                  markers: markers,
                  circles: circles,
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 15.0,
                  ),
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    setState(() {
                      _customInfoWindowController.googleMapController =
                          controller;
                    });
                  },
                ),
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 150,
                width: 250,
                offset: 50,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Adjust Geofence Radius: \${_radius.toInt()} meters"),
                Slider(
                  min: 100,
                  max: 2000,
                  value: _radius,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                      _addGeofenceCircle(location);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
