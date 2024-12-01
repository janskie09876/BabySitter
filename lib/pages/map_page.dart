import 'package:babysitter/requirement-babysitterprofilepage/view_babysitter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

class maps extends StatefulWidget {
  const maps({super.key});

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  static const LatLng _centerLocation = LatLng(7.306460, 125.683258);
  double _currentZoom = 15.0; // Default zoom level
  late GoogleMapController _mapController;

  final List<Babysitter> _babysitters = [
    Babysitter(
      id: "1",
      name: "Maricris Dela Cerna",
      address: "Panabo City",
      rating: 4.5,
      age: 25,
      birthdate: "October 17, 1999",
      gender: "Female",
      contact: "+6390987654321",
      position: const LatLng(7.306460, 125.683258),
      profileImage: "assets/images/tin.jpg",
    ),
    Babysitter(
      id: "2",
      name: "John Doe",
      address: "Tagum City",
      rating: 4.0,
      age: 30,
      birthdate: "March 5, 1993",
      gender: "Male",
      contact: "+639123456789",
      position: const LatLng(7.308460, 125.683558),
      profileImage: "assets/images/john.webp",
    ),
    Babysitter(
      id: "3",
      name: "Jane Smith",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876543210",
      position: const LatLng(7.190700, 125.455300),
      profileImage: "assets/images/tin.jpg",
    ),
    Babysitter(
      id: "4",
      name: "Mark Johnson",
      address: "Tagum City",
      rating: 4.3,
      age: 32,
      birthdate: "May 20, 1991",
      gender: "Male",
      contact: "+639012345678",
      position: const LatLng(7.450000, 125.823000),
      profileImage: "assets/images/kingkong.jpg",
    ),
    Babysitter(
      id: "5",
      name: "Anna Lopez",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.306500, 125.684000),
      profileImage: "assets/images/anna.webp",
    ),
    Babysitter(
      id: "6",
      name: "John Lopeza",
      address: "Tagum City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.460496, 125.794653),
      profileImage: "assets/images/john.webp",
    ),
    Babysitter(
      id: "7",
      name: "Jean Garcia",
      address: "Tagum City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639563456100",
      position: const LatLng(7.424515, 125.796686),
      profileImage: "assets/images/jean.jpg",
    ),
    Babysitter(
      id: "8",
      name: "Donnalyn Bartolome",
      address: "Tagum City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+6392634671031",
      position: const LatLng(7.422995, 125.790404),
      profileImage: "assets/images/donna.jpg",
    ),
    Babysitter(
      id: "10",
      name: "Brenda Samonte",
      address: "Tagum City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639586138201",
      position: const LatLng(7.4014, 125.7680),
      profileImage: "assets/images/brenda.jpg",
    ),
    Babysitter(
      id: "11",
      name: "Bless Rodriguez",
      address: "Tagum City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.3773, 125.7598),
      profileImage: "assets/images/bless.jpg",
    ),
    Babysitter(
      id: "12",
      name: "Liza Pempino",
      address: "Davao City",
      rating: 4.8,
      age: 30,
      birthdate: "July 10, 1996",
      gender: "Female",
      contact: "+639812371234",
      position: const LatLng(7.081084, 125.575496),
      profileImage: "assets/images/liza.jpg",
    ),
    Babysitter(
      id: "13",
      name: "Mark Lloyd De Guzman",
      address: "Davao City",
      rating: 4.8,
      age: 25,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+6391347985210",
      position: const LatLng(7.061408, 125.561437),
      profileImage: "assets/images/mark.jpg",
    ),
    Babysitter(
      id: "14",
      name: "Pepito Manaloto",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Male",
      contact: "+639876543210",
      position: const LatLng(7.193516, 125.642885),
      profileImage: "assets/images/reymond.jpg",
    ),
    Babysitter(
      id: "15",
      name: "Julian",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876543210",
      position: const LatLng(7.089475, 125.621559),
      profileImage: "assets/images/bless.jpg",
    ),
    Babysitter(
      id: "16",
      name: "Kristine Hermonsa",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876543210",
      position: const LatLng(7.128595, 125.530463),
      profileImage: "assets/images/tin.jpg",
    ),
    Babysitter(
      id: "17",
      name: "Kyla Lipada",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876785410",
      position: const LatLng(7.117646, 125.351974),
      profileImage: "assets/images/kyla.webp",
    ),
    Babysitter(
      id: "18",
      name: "Liza Burakaga",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876236210",
      position: const LatLng(7.291522, 125.412300),
      profileImage: "assets/images/liza.jpg",
    ),
    Babysitter(
      id: "19",
      name: "Joyce Ching",
      address: "Davao City",
      rating: 4.8,
      age: 28,
      birthdate: "July 10, 1995",
      gender: "Female",
      contact: "+639876124510",
      position: const LatLng(7.010296, 125.491349),
      profileImage: "assets/images/tin.jpg",
    ),
    Babysitter(
      id: "20",
      name: "Bianca Mamalati",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564124291",
      position: const LatLng(7.450098, 125.653972),
      profileImage: "assets/images/kyla.webp",
    ),
    Babysitter(
      id: "21",
      name: "Apple Strawberry",
      address: "Panabo City",
      rating: 4.7,
      age: 35,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639100438291",
      position: const LatLng(7.363458, 125.652412),
      profileImage: "assets/images/joyce.jpeg",
    ),
    Babysitter(
      id: "22",
      name: "Reymondo Abugado",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "Semptember 08, 1998",
      gender: "Male",
      contact: "+639564738291",
      position: const LatLng(7.346437, 125.561922),
      profileImage: "assets/images/reymond.jpg",
    ),
    Babysitter(
      id: "23",
      name: "Marco Gumamaw",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Male",
      contact: "+639564738291",
      position: const LatLng(7.268030, 125.597286),
      profileImage: "assets/images/mark.jpg",
    ),
    Babysitter(
      id: "24",
      name: "Finaland Bulawak",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564732361",
      position: const LatLng(7.344993, 125.651248),
      profileImage: "assets/images/jean.jpg",
    ),
    Babysitter(
      id: "25",
      name: "Brenda Dotdot",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.379902, 125.575305),
      profileImage: "assets/images/brenda.jpg",
    ),
    Babysitter(
      id: "26",
      name: "Labubo Bubu",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.338223, 125.638662),
      profileImage: "assets/images/liza.jpg",
    ),
    Babysitter(
      id: "27",
      name: "Gikapoy Nako D pwede",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.341820, 125.719725),
      profileImage: "assets/images/tin.jpg",
    ),
    Babysitter(
      id: "28",
      name: "Murag Nawong",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Male",
      contact: "+639564738291",
      position: const LatLng(7.275434, 125.672999),
      profileImage: "assets/images/john.webp",
    ),
    Babysitter(
      id: "5",
      name: "Minamalas Nga",
      address: "Panabo City",
      rating: 4.7,
      age: 26,
      birthdate: "December 25, 1997",
      gender: "Female",
      contact: "+639564738291",
      position: const LatLng(7.296149, 125.707948),
      profileImage: "assets/images/kyla.webp",
    ),
  ];

  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  Babysitter? _selectedBabysitter; // Currently selected babysitter

  @override
  void initState() {
    super.initState();
    _generateCustomMarkers();
    _createGeofencingCircles(); // Add geofencing circles
  }

  Future<void> _generateCustomMarkers() async {
    for (var babysitter in _babysitters) {
      final markerIcon = await _createCustomMarker(babysitter.profileImage);
      _markers.add(
        Marker(
          markerId: MarkerId(babysitter.id),
          position: babysitter.position,
          icon: markerIcon,
          onTap: () {
            setState(() {
              _selectedBabysitter = babysitter;
            });
          },
        ),
      );
    }
    setState(() {});
  }

  Future<BitmapDescriptor> _createCustomMarker(String profileImagePath) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double size = 150; // Marker size

      final ByteData profileData =
          await DefaultAssetBundle.of(context).load(profileImagePath);
      final ui.Codec profileCodec = await ui.instantiateImageCodec(
        profileData.buffer.asUint8List(),
        targetWidth: size.toInt(),
        targetHeight: size.toInt(),
      );
      final ui.FrameInfo profileFrame = await profileCodec.getNextFrame();
      final ui.Image profileImage = profileFrame.image;

      final double radius = size / 2;
      final Rect rect = const Rect.fromLTWH(0, 0, size, size);
      final Paint paint = Paint();

      canvas.drawCircle(Offset(radius, radius), radius, paint);
      canvas.clipPath(Path()..addOval(rect));
      canvas.drawImageRect(
        profileImage,
        Rect.fromLTWH(0, 0, profileImage.width.toDouble(),
            profileImage.height.toDouble()),
        rect,
        paint,
      );

      final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
            size.toInt(),
            size.toInt(),
          );
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      throw Exception("Error creating custom marker: $e");
    }
  }

  void _createGeofencingCircles() {
    _circles.add(
      Circle(
        circleId: const CircleId("tagum"),
        center: const LatLng(7.4418, 125.8230), // Approximate location of Tagum
        radius: 20000, // 20 km radius
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
    _circles.add(
      Circle(
        circleId: const CircleId("panabo"),
        center: const LatLng(7.306460, 125.683258), // Panabo location
        radius: 20000,
        fillColor: Colors.green.withOpacity(0.2),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ),
    );
    _circles.add(
      Circle(
        circleId: const CircleId("davao"),
        center: const LatLng(7.1907, 125.4553), // Davao City location
        radius: 30000, // 30 km radius
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _centerLocation,
              zoom: _currentZoom,
            ),
            markers: _markers,
            circles: _circles,
          ),
          Positioned(
            left: 10,
            top: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: _currentZoom,
                min: 5.0,
                max: 18.0,
                divisions: 26,
                label: "Zoom: ${_currentZoom.toStringAsFixed(1)}",
                onChanged: (value) {
                  setState(() {
                    _currentZoom = value;
                    _mapController.animateCamera(
                      CameraUpdate.zoomTo(_currentZoom),
                    );
                  });
                },
              ),
            ),
          ),
          // Inside the Google Map Stack
          if (_selectedBabysitter != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage(_selectedBabysitter!.profileImage),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status
                              const Text(
                                "Available",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Babysitter Name
                              Text(
                                _selectedBabysitter!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Rating
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < _selectedBabysitter!.rating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Close Button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedBabysitter = null;
                            });
                          },
                          icon: const Icon(Icons.close, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Babysitter Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Address
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.pink),
                            const SizedBox(width: 4),
                            Text(_selectedBabysitter!.address),
                          ],
                        ),
                        // Coordinates
                        Text(
                          "${_selectedBabysitter!.position.latitude.toStringAsFixed(4)}° N, ${_selectedBabysitter!.position.longitude.toStringAsFixed(4)}° E",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Contact
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.pink),
                        const SizedBox(width: 4),
                        Text(_selectedBabysitter!.contact),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Distance
                    const Text(
                      "19 min (3.1 mi) via Your location...",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                    const Divider(height: 24),
                    // Statistics
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Number of Transactions
                        Column(
                          children: [
                            Text(
                              "No. of Transactions",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "15",
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // Number of Bookings
                        Column(
                          children: [
                            Text(
                              "No. of Bookings",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "02",
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // More Information Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewBabysitter(
                                      nanny: null,
                                    ) // Navigate to ViewBabysitter
                                ),
                          );
                        },
                        child: const Text(
                          "More Information",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Babysitter {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int age;
  final String birthdate;
  final String gender;
  final String contact;
  final LatLng position;
  final String profileImage;

  Babysitter({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.age,
    required this.birthdate,
    required this.gender,
    required this.contact,
    required this.position,
    required this.profileImage,
  });
}
