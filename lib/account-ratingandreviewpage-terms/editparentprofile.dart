import 'dart:typed_data';
import 'package:babysitter/requirement-babysitterprofilepage/resources/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

final List<String> genderOptions = <String>[
  'Male',
  'Female',
];

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark background
  static const Color beige = Color(0xFFE3C3A3); // Beige
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black
  static const Color grayColor = Color(0xFF7D7D7D); // Gray
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFBC02D); // Yellow
  static const Color whiteColor = Color(0xFFFFFFFF); // White
  static const Color redColor = Color(0xFFFF0000); // Red
}

class EditParentProfilePage extends StatefulWidget {
  const EditParentProfilePage({super.key});

  @override
  State<EditParentProfilePage> createState() => _EditParentProfilePageState();
}

class _EditParentProfilePageState extends State<EditParentProfilePage> {
  Uint8List? _profileimage;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String dropdownValue = genderOptions.first;
  String? latitude;
  String? longitude;

  // For selecting image using the Gallery for profile pic
  void selectImageFromGallery(bool isForProfile) async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      if (isForProfile) {
        _profileimage = img;
      }
    });
    Navigator.of(context).pop();
  }

  // For selecting image using the Camera for profile pic
  void selectImageFromCamera(bool isForProfile) async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      if (isForProfile) {
        _profileimage = img;
      }
    });
    Navigator.of(context).pop();
  }

  // Option sa pagkuha ug picture kung gallery ba or camera para sa profile
  void showImagePickerOptionforProfile(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white, // Adjust as needed
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => selectImageFromGallery(true),
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => selectImageFromCamera(true),
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MMMM dd, yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  // Method to upload the image to Firebase Storage
  Future<String?> uploadImageToStorage(Uint8List image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Method to update user profile in Firestore
  Future<void> updateUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> updatedData = {
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'location': locationController.text,
          'gender': dropdownValue,
          'birthdate': _dateController.text,
          'profileImage': _profileimage != null
              ? await uploadImageToStorage(
                  _profileimage!) // upload image if selected
              : null,
          'latitude': latitude,
          'longitude': longitude,
        };

        final userDoc =
            FirebaseFirestore.instance.collection('parents').doc(user.uid);
        await userDoc.update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  // Method to get the current location
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check if location permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationController.text =
          'Lat: $latitude, Long: $longitude'; // Update text field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 15),
            // Back Button instead of the Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                  icon: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 25,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.whiteColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Content
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Profile Picture
                  Stack(
                    children: [
                      _profileimage != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(_profileimage!),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/profile.jpg'),
                            ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showImagePickerOptionforProfile(context);
                            },
                            icon: Icon(
                              Icons.add_circle,
                              size: 45,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        bottom: 0,
                        right: 0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Name TextField
                  TextFormField(
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Phone Number TextField
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your phone number'
                        : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
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
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: genderOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
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
                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.primaryColor,
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
                        color: AppColors.whiteColor,
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
