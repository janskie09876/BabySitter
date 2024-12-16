import 'dart:typed_data';
import 'package:babysitter/requirement-babysitterprofilepage/resources/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

final List<String> genderOptions = <String>[
  'Male',
  'Female',
];

class EditBabysitterProfilePage extends StatefulWidget {
  const EditBabysitterProfilePage({super.key});
  @override
  State<EditBabysitterProfilePage> createState() =>
      _EditBabysitterProfilePageState();
}

class _EditBabysitterProfilePageState extends State<EditBabysitterProfilePage> {
  Uint8List? _profileimage;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();

  String radioButtonValue = genderOptions.first;
  String? latitude;
  String? longitude;

  // Image Picker Methods
  void selectImageFromGallery(bool isForProfile) async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      if (isForProfile) {
        _profileimage = img;
      }
    });
    Navigator.of(context).pop();
  }

  void selectImageFromCamera(bool isForProfile) async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      if (isForProfile) {
        _profileimage = img;
      }
    });
    Navigator.of(context).pop();
  }

  void showImagePickerOptionforProfile(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => selectImageFromGallery(true),
                  child: Column(
                    children: const [
                      Icon(Icons.image, size: 70, color: AppColors.blackColor),
                      Text('Gallery',
                          style: TextStyle(
                              color: AppColors.blackColor, fontSize: 20)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => selectImageFromCamera(true),
                  child: Column(
                    children: const [
                      Icon(Icons.camera_alt,
                          size: 70, color: AppColors.blackColor),
                      Text('Camera',
                          style: TextStyle(
                              color: AppColors.blackColor, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ],
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

  // Firebase Storage Upload
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

  // Update Profile Data
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
          'address': addressController.text,
          'service': serviceController.text,
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationController.text = 'Lat: $latitude, Long: $longitude';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.blackColor),
                ),
              ],
            ),
            const Center(
              child: Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileimage != null
                      ? MemoryImage(_profileimage!)
                      : const AssetImage('assets/profile.jpg') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () => showImagePickerOptionforProfile(context),
                    icon: const Icon(Icons.add_circle,
                        size: 30, color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name Field
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: serviceController,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your service fee' : null,
              decoration: const InputDecoration(
                labelText: 'Service Fee',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  TextInputType.number, // Set the keyboard type to number
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
            ),
            const SizedBox(height: 20),
            // Phone Number TextField
            TextFormField(
              controller: phoneNumberController,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your phone number' : null,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              // Address
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: addressController,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your Complete Address' : null,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Address',
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
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your Work Experience' : null,
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
    );
  }
}
