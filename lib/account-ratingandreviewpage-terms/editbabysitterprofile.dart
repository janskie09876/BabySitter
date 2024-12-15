import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

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
  final TextEditingController addressController = TextEditingController();

  String? radioButtonValue;
  String? selectedCity;
  final List<String> cities = ['Panabo City', 'Tagum City', 'Davao City'];
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  XFile? _profileimage;
  final ImagePicker _picker = ImagePicker();

  double? latitude;
  double? longitude;

  // Pick an Image
  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileimage = image;
    });
  }

  // Upload Image to Firebase Storage
  Future<String> uploadImageToStorage(XFile image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child('${FirebaseAuth.instance.currentUser?.uid}.jpg');
    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }

  // Update User Profile
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
              ? await uploadImageToStorage(_profileimage!)
              : null,
          'latitude': latitude,
          'longitude': longitude,
        };

        final userDoc =
            FirebaseFirestore.instance.collection('babysitters').doc(user.uid);
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

  // Get Current Location
  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationController.text =
            '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
      });
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching location')),
      );
    }
  }

  // Select Date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: locationController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Location (Lat, Long)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: getLocation,
                    icon: const Icon(Icons.location_on),
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Column(
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUserProfile();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
