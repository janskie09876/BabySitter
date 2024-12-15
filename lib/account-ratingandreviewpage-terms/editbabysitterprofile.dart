import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

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
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> updatedData = {
          'name': nameController.text,
          'phone': phoneNumberController.text,
          'location': locationController.text,
          'gender': radioButtonValue,
          'birthdate': _dateController.text,
          'bio': bioController.text,
          'work': workController.text,
          'profileImage': _profileimage != null
              ? await uploadImageToStorage(
                  _profileimage!) // upload image if selected
              : null,
          'latitude': latitude,
          'longitude': longitude,
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Phone Number TextField
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Street, Building, and Brgy.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Location TextField with "Get Exact Location" button
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location (Lat, Long)',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: getLocation,
                        icon: Icon(Icons.location_on),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Birthdate Picker
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Bio
                  TextFormField(
                    controller: bioController,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your Bio' : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: workController,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your Work Experience'
                        : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Work Experience',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Gender Radio Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: genderOptions.map((String option) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: option,
                            groupValue: radioButtonValue,
                            onChanged: (value) {
                              setState(() {
                                radioButtonValue = value!;
                              });
                            },
                          ),
                          Text(option),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                      minimumSize: Size.fromHeight(45),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUserProfile();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
