import 'package:flutter/material.dart';

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

class PrivacyPolicyPage extends StatelessWidget {
  final VoidCallback onAccept;

  const PrivacyPolicyPage({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Last updated on October 2024',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'At Todd Care, we take your privacy seriously and are committed to safeguarding your personal data. This Privacy Policy explains what information we collect, how we use it, and how we protect it. By using Todd Care, you consent to the practices described in this policy.',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '1. Information We Collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'When you use Todd Care, we collect the following types of information:',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Personal Information: Including your name, email, phone number, and account details.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Device Information: Including your device type, operating system, and usage statistics.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Location Information: To help match babysitters with parents based on their location.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Payment Information: If using the app for transactions, we collect payment details processed by secure third-party services.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We use the information we collect for the following purposes:',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• To create and manage your account.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• To provide matching services between parents and babysitters.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• To process payments and handle billing inquiries.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• To ensure the security of the app and prevent fraud.',
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAccept(); // Trigger the callback when "Accept" is pressed
                Navigator.pop(context); // Go back to the previous page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'ACCEPT',
                style: TextStyle(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
