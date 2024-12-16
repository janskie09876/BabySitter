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

class TermsAndConditionsPage extends StatelessWidget {
  final VoidCallback onAccept;

  const TermsAndConditionsPage({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
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
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last updated on October 2024',
              style: TextStyle(
                fontFamily: '', // Used for body and subtitles
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
                      'Welcome to Todd Care, the platform that connects parents with babysitters. By using this app, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully.',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Terms and Conditions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Definitions:\n'
                      '- Babysitter: A registered individual offering babysitting services through the App.\n'
                      '- Parent/Guardian: A registered individual seeking babysitting services through the App.\n'
                      '- Services: The babysitting services arranged through the App.\n'
                      '- User: Any person who downloads, registers, or uses the App.\n',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '2. Eligibility:\n'
                      'To use the App, you must:\n'
                      '1. Be at least 18 years old.\n'
                      '2. Provide accurate and up-to-date information during registration.\n'
                      '3. Agree to comply with these Terms and all applicable laws.\n',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '3. Account Registration:\n'
                      '- Users must create an account to access the App’s features.\n'
                      '- You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.\n'
                      '- Notify us immediately of any unauthorized use or security breach of your account.\n',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'For the full Terms and Conditions, please contact us at toddcare@gmail.com.',
                      style: TextStyle(
                        fontFamily: '', // Used for body and subtitles
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
