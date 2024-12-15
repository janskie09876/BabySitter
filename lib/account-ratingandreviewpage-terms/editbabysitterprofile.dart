import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:babysitter/pages/viewmap1.dart';

class EditBabysitterProfilePage extends StatefulWidget {
  @override
  _EditBabysitterProfilePageState createState() =>
      _EditBabysitterProfilePageState();
}

class _EditBabysitterProfilePageState extends State<EditBabysitterProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bioController = TextEditingController();
  final workController = TextEditingController();
  final _dateController = TextEditingController();
  final addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? radioButtonValue;
  String? selectedCity;
  final List<String> cities = ['Panabo City', 'Tagum City', 'Davao City'];

  XFile? _profileimage;
  final ImagePicker _picker = ImagePicker();

  double? latitude;
  double? longitude;
  String? address;

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileimage = image;
    });
  }

  Future<void> updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final updatedData = {
            'name': nameController.text,
            'phone': phoneNumberController.text,
            'city': selectedCity,
            'gender': radioButtonValue,
            'birthdate': _dateController.text,
            'bio': bioController.text,
            'work': workController.text,
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
          };

          final userDoc = FirebaseFirestore.instance
              .collection('babysitters')
              .doc(user.uid);
          await userDoc.update(updatedData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile')),
        );
      }
    }
  }

  Future<void> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      setState(() {
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;
        addressController.text = address;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileimage != null
                      ? FileImage(File(_profileimage!.path))
                      : null,
                  child: _profileimage == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your phone number'
                    : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                    ),
                    value: selectedCity,
                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select your city' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Street, Building, and Brgy.',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                    ),
                    onTap: () async {
                      final tempAddressController = TextEditingController();
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Enter Your Address'),
                            content: TextField(
                              controller: tempAddressController,
                              decoration: const InputDecoration(
                                labelText:
                                    'Enter your street, building, and brgy.',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  String enteredAddress =
                                      tempAddressController.text;
                                  await getCoordinatesFromAddress(
                                      enteredAddress);

                                  // Check if latitude and longitude are valid before proceeding
                                  if (latitude != null && longitude != null) {
                                    // Delay navigation logic until context is stable and widget is mounted
                                    if (mounted) {
                                      // Use `mounted` check to ensure widget is still active before navigating
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewMap1(
                                            latitude: latitude!,
                                            longitude: longitude!,
                                            isSelectingLocation: true,
                                            address: enteredAddress,
                                          ),
                                        ),
                                      );

                                      if (result != null && result is LatLng) {
                                        // Use the mounted check before calling setState
                                        if (mounted) {
                                          setState(() {
                                            latitude = result.latitude;
                                            longitude = result.longitude;
                                            address = enteredAddress;
                                            addressController.text =
                                                '${enteredAddress}, Lat: ${result.latitude}, Long: ${result.longitude}';
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Location selected: ${result.latitude}, ${result.longitude}'),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                child: const Text('Next'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Birthdate',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _dateController.text =
                              '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: radioButtonValue,
                    hint: const Text('Gender'),
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        radioButtonValue = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter bio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: workController,
                decoration: const InputDecoration(
                  labelText: 'Work Experience',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter work experience'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateUserProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
