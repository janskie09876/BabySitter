import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the ImagePicker package

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
  static const Color secondaryColor =
      Color(0xFF7D7D7D); // Gray for secondary elements
}

class ImagePickerHelper {
  final BuildContext context;

  ImagePickerHelper({required this.context});

  // Method to show image picker options (Gallery/Camera)
  void showImagePickerOptions() {
    showModalBottomSheet(
      backgroundColor: Color(0xFFF5F5F5),
      context: context,
      builder: (builder) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.2, // Use percentage-based height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOption(
                      icon: Icons.image,
                      label: 'Gallery',
                      onTap: () => pickImage(ImageSource.gallery),
                      screenWidth: screenWidth,
                    ),
                    _buildOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () => pickImage(ImageSource.camera),
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to create an option button for Gallery or Camera
  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: screenWidth * 0.15, // Dynamic size for icon
              color: AppColors.secondaryColor,
            ),
            SizedBox(height: screenWidth * 0.02), // Adjust spacing dynamically
            Text(
              label,
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: screenWidth * 0.05, // Dynamic font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      print('Image selected: ${_file.path}');
      // You can process the selected image here, e.g., uploading or displaying it
      // For now, let's return the bytes of the selected image
      await _file.readAsBytes();
    } else {
      print('No image selected');
    }
  }

  // Placeholder function for file picking (not implemented)
  void pickFile() {
    // Implement file picking logic here if needed
    print('File picking not yet implemented.');
  }
}
