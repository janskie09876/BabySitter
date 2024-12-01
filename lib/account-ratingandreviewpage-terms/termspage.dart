import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final VoidCallback onAccept;

  const TermsAndConditionsPage({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Light pink background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                fontFamily: 'Baloo', // Used for headings and titles
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last updated on October 2024',
              style: TextStyle(
                fontFamily: 'Balsamiq Sans', // Used for body and subtitles
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Add your terms and conditions text here
                    Text(
                      'Welcome to Todd Care, the platform that connects parents with babysitters. By using this app, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Terms and Conditions:',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '1. Definitions:\n'
                      '- Babysitter: A registered individual offering babysitting services through the App.\n'
                      '- Parent/Guardian: A registered individual seeking babysitting services through the App.\n'
                      '- Services: The babysitting services arranged through the App.\n'
                      '- User: Any person who downloads, registers, or uses the App.\n',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '2. Eligibility:\n'
                      'To use the App, you must:\n'
                      '1. Be at least 18 years old.\n'
                      '2. Provide accurate and up-to-date information during registration.\n'
                      '3. Agree to comply with these Terms and all applicable laws.\n',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '3. Account Registration:\n'
                      '- Users must create an account to access the App’s features.\n'
                      '- You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.\n'
                      '- Notify us immediately of any unauthorized use or security breach of your account.\n',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'For the full Terms and Conditions, please contact us at toddcare@gmail.com.com.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    // Additional terms sections go here
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
                backgroundColor: Colors.grey[300], // Button background color
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'ACCEPT',
                style: TextStyle(
                  fontFamily: 'Baloo', // Used for headings and titles
                  color: Colors.black,
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
