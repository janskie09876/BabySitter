import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/pages/profiledialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ViewMap1 extends StatefulWidget {
  final bool isSelectingLocation;
  final String address;
  const ViewMap1(
      {Key? key,
      this.isSelectingLocation = false,
      required this.address,
      required double latitude,
      required double longitude})
      : super(key: key);

  @override
  _ViewMap1State createState() => _ViewMap1State();
}

class _ViewMap1State extends State<ViewMap1> {
  Set<Marker> markers = Set();
  Set<Circle> circles = Set();
  GoogleMapController? mapController;
  late LatLng location;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  String locationMsg = 'Current Location of User';
  late String lat;
  late String long;
  double _radius = 500; // default radius for geofence

  final List<LatLng> markerPositions = [
    LatLng(7.3099, 125.6708),
    LatLng(7.3141, 125.6653),
    LatLng(7.3195, 125.6702),
    LatLng(7.3165, 125.6748),
    LatLng(7.3153, 125.6692)
  ];

  BitmapDescriptor? currentLocationIcon;

  // Geocode address to get latitude and longitude
  Future<void> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      setState(() {
        location = LatLng(locations[0].latitude, locations[0].longitude);
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid address')),
      );
    }
  }

  Future<void> _loadCustomIcons() async {
    currentLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/mylocation.bmp");
  }

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

  void _addGeofenceCircle(LatLng position) {
    setState(() {
      circles = {
        Circle(
          circleId: CircleId("geofence"),
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

  // Filter markers based on distance from the center
  void _filterMarkers() {
    setState(() {
      markers.clear();
      for (var position in markerPositions) {
        final distance = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance <= _radius) {
          markers.add(
            Marker(
              markerId: MarkerId(position.toString()),
              position: position,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: " ${position.toString()}"),
              onTap: () {
                _showProfileDialog();
              },
            ),
          );
        }
      }
    });
  }

  addMyMarker(LatLng myLoc) {
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
      _addGeofenceCircle(myLoc); // Add geofence circle at current location
    });

    _filterMarkers(); // Filter existing markers based on the radius
  }

  void _liveLocation() {
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
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadCustomIcons(); // Load custom icons
    getCoordinatesFromAddress(widget.address).then((_) {
      lat = '${location.latitude}';
      long = '${location.longitude}';
      setState(() {
        locationMsg = 'Lat: $lat , Long: $long';
        _addGeofenceCircle(location); // Show the circle immediately
      });
      _liveLocation();
    });
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => const ProfileDialog(),
    );
  }

  Widget loadMap() => Column(
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
                  onTap: (LatLng tappedPosition) {
                    if (widget.isSelectingLocation) {
                      Navigator.pop(
                          context, tappedPosition); // Return tapped position
                    } else {
                      _customInfoWindowController.hideInfoWindow!();
                    }
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
                Text("Adjust Geofence Radius: ${_radius.toInt()} meters"),
                Slider(
                  min: 100,
                  max: 2000,
                  value: _radius,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                      _addGeofenceCircle(location); // Update circle radius
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: loadMap(),
    );
  }
}
