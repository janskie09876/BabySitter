import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BabysitterRatingForm extends StatefulWidget {
  @override
  _BabysitterRatingFormState createState() => _BabysitterRatingFormState();
}

class _BabysitterRatingFormState extends State<BabysitterRatingForm> {
  int _rating = 0; // Variable to store the selected rating
  File? _image; // Variable to store the selected image

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: Text("Babysitter's Rating"),
        backgroundColor: Colors.pink[200],
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Close button to dismiss the page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Babysitter profile information
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                      'assets//images/jamesboy.png'), // Replace with the image
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'James Boy Boliwag',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Reviews are public and include your account and device info. Learn more',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Star rating system (Clickable)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.pink[300],
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating =
                          index + 1; // Update rating based on the star clicked
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),

            // Text area for the experience description
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Describe your experience",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Photo upload section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey, // Outline color
                    width: 1.0, // Outline width
                  ),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_rounded,
                              color: Colors.grey[600], size: 50),
                          SizedBox(height: 8),
                          Text("Upload Photo",
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              onPressed: () {
                // You can handle the form submission here
                print('Rating: $_rating');
                print('Photo: ${_image?.path ?? "No photo selected"}');
                // Add form submission logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300], // Pinkish red color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
