import 'dart:typed_data';

import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'resources/utils.dart';

final List<String> idOptions = <String>[
  'Philippine Identification (PhilID)',
  'UMID',
  'SSS ID',
  'COMELEC / Voter’s ID',
  'BIR (TIN)',
  'Pag-ibig ID',
];

final List<String> genderOptions = <String>[
  'Male',
  'Female',
];

class RequirementsPage extends StatefulWidget {
  const RequirementsPage({super.key});

  @override
  State<RequirementsPage> createState() => _RequirementsPageState();
}

class _RequirementsPageState extends State<RequirementsPage> {
  Uint8List? _profileimage;
  Uint8List? _validIDimage;

  final _formKey = GlobalKey<FormState>();

  // Text Controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController workExperienceController =
      TextEditingController();

  String dropdownValue = idOptions.first;
  String radioButtonValue = genderOptions.first;

  // For selecting image using the Gallery for profile pic
  void selectImageFromGallery(bool isForProfile) async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      if (isForProfile) {
        _profileimage = img;
      } else {
        _validIDimage = img;
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
      } else {
        _validIDimage = img;
      }
    });
    Navigator.of(context).pop();
  }

  // Option sa pagkuha ug picture kung gallery ba or camera para sa profile
  void showImagePickerOptionforProfile(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:
          AppStyles.primaryColor, //can be change depending on the theme
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
                            color: AppStyles.secondaryColor,
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                color: AppStyles.secondaryColor, fontSize: 20),
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
                            color: AppStyles.secondaryColor,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                color: AppStyles.secondaryColor, fontSize: 20),
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

// Option sa pagkuha ug picture kung gallery ba or camera para sa valid ID
  void showImagePickerOptionforValidID(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:
          AppStyles.primaryColor, //can be change depending on the theme
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
                    onTap: () => selectImageFromGallery(false),
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                            color: AppStyles.secondaryColor,
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                color: AppStyles.secondaryColor, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => selectImageFromCamera(false),
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                            color: AppStyles.secondaryColor,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                color: AppStyles.secondaryColor, fontSize: 20),
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
      setState(
        () {
          _dateController.text = formattedDate;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: [
              SizedBox(height: 15),
              // Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      backgroundColor: AppStyles.primaryColor,
                      radius: 25,
                      child: Icon(
                        Icons.close_rounded,
                        color: AppStyles.secondaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Heading sa Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Update Profile',
                    style: TextStyle(
                        color: AppStyles.secondaryColor,
                        fontFamily: 'Baloo',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 10),
              // Content
              Container(
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                                  backgroundImage:
                                      AssetImage('assets/profile.jpg'),
                                ),
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppStyles.backgroundColor,
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
                                  color: AppStyles.secondaryColor,
                                ),
                              ),
                            ),
                            bottom: -3,
                            left: 53,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Name
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Name',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Email
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Email',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Phone Number
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Phone Number',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Birthdate - Date Picker
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _dateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter birthdate!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Birthdate',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            suffixIcon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppStyles.textColor,
                              size: 25,
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Gender - Radio Button
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              'Select Gender',
                              style: TextStyle(
                                  color: AppStyles.textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Balsamiq Sans'),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: genderOptions.map((option) {
                            return Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                    activeColor: AppStyles.primaryColor,
                                    value: option,
                                    groupValue: radioButtonValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        radioButtonValue = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    option,
                                    style: TextStyle(
                                        fontFamily: 'Balsamiq Sans',
                                        color: AppStyles.textColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Location
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: locationController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Location',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Biography
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          minLines: 2,
                          maxLines: 5,
                          controller: bioController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter biography!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Biography',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Work Experience/s
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          minLines: 3,
                          maxLines: 8,
                          controller: workExperienceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter work experience!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Work Experience/s',
                            labelStyle: TextStyle(
                                color: AppStyles.textColor,
                                fontFamily: 'Balsamiq Sans'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Upload Valid ID
                      _validIDimage != null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 115, vertical: 25),
                              decoration: BoxDecoration(
                                color: AppStyles.backgroundColor,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showImagePickerOptionforValidID(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 50,
                                    ),
                                    // Image.asset(
                                    //   'assets/id.png',
                                    //   width: 40,
                                    //   height: 40,
                                    // ),
                                    const Text(
                                      'Upload Valid ID',
                                      style: TextStyle(
                                          color: AppStyles.textColor,
                                          fontFamily: 'Balsamiq Sans'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 115, vertical: 25),
                              decoration: BoxDecoration(
                                color: AppStyles.backgroundColor,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showImagePickerOptionforValidID(context);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 50,
                                    ),
                                    // Image.asset(
                                    //   'assets/id.png',
                                    //   width: 40,
                                    //   height: 40,
                                    // ),
                                    const Text(
                                      'Upload Valid ID',
                                      style: TextStyle(
                                          color: AppStyles.textColor,
                                          fontFamily: 'Balsamiq Sans'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      // Button for Add Availability
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Curvy edges
                            ),
                            backgroundColor: AppStyles.secondaryColor,
                            minimumSize: Size.fromHeight(45),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Add Availability',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Balsamiq Sans'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Button to Submit
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Curvy edges
                            ),
                            backgroundColor: AppStyles.secondaryColor,
                            minimumSize: Size.fromHeight(45),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('You entered'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Balsamiq Sans'),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
