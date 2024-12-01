import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/profile.jpg'), // Replace with actual image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink,
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Name Field
              _buildTextField('Maricris Dela Cerna', Icons.person),
              SizedBox(height: 16),
              // Date of Birth
              _buildTextField('October 17, 1999', Icons.calendar_today),
              SizedBox(height: 16),
              // Phone Number
              _buildTextField('+2345656787', Icons.phone),
              SizedBox(height: 16),
              // Gender Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Gender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: 'Male',
                      groupValue: 'Female', // Example, update dynamically
                      onChanged: (value) {
                        // Handle value change
                      },
                      title: Text('Male'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: 'Female',
                      groupValue: 'Female', // Example, update dynamically
                      onChanged: (value) {
                        // Handle value change
                      },
                      title: Text('Female'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // City Field
              _buildTextField('Pantoja City', Icons.location_city),
              SizedBox(height: 16),
              // Bio Field
              _buildTextField(
                'Hi! I’m Maricris, a dedicated and caring babysitter with over 4 years of experience working with children of all ages...',
                Icons.description,
                maxLines: 5,
              ),
              SizedBox(height: 16),
              // Valid ID Dropdown
              _buildDropdownField(
                'Valid ID',
                'Philippine Identification (PHID)',
              ),
              SizedBox(height: 16),
              // Upload Valid ID Button
              _buildUploadButton('Upload Valid ID', Icons.upload),
              SizedBox(height: 16),
              // Upload Certifications Button
              _buildUploadButton('Upload Certifications', Icons.upload_file),
              SizedBox(height: 16),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String selectedValue) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: 'Philippine Identification (PHID)',
              child: Text('Philippine Identification (PHID)'),
            ),
            DropdownMenuItem(
              value: 'Driver’s License',
              child: Text('Driver’s License'),
            ),
            DropdownMenuItem(
              value: 'Passport',
              child: Text('Passport'),
            ),
          ],
          onChanged: (value) {
            // Handle dropdown value change
          },
        ),
      ),
    );
  }

  Widget _buildUploadButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // Upload logic
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.black),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
