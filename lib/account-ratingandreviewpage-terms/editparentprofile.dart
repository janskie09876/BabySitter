import 'package:flutter/material.dart';

class EditParentProfilePage extends StatefulWidget {
  @override
  _EditParentProfilePageState createState() => _EditParentProfilePageState();
}

class _EditParentProfilePageState extends State<EditParentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> addresses = [
    'Davao City-Panabo City Road, Bulungan, Panabo City, Davao del Sur, Philippines',
    'Panabo - Tagum Circumferential Road, City of Panabo, Davao del Norte, Philippines',
    'Panabo Bypass Road, City of Panabo, Davao del Norte, Philippines',
  ];

  String? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4E6), // Soft pink background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back button functionality
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Baloo', // Heading font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // First Name Text Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Surname Text Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Surname',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Phone Text Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Date of Birth Text Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // About Me Text Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'About Me',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),

              // Address Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Search your address',
                  labelStyle:
                      TextStyle(fontFamily: 'Balsamiq Sans'), // Body font
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                isExpanded: true,
                value: selectedAddress,
                items: addresses.map((address) {
                  return DropdownMenuItem<String>(
                    value: address,
                    child: Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAddress = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Profile saved successfully! Address: $selectedAddress'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Save button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins', // Number font
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
