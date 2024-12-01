import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final VoidCallback onAccept;

  const PrivacyPolicyPage({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Light pink background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E1),
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontFamily: 'Baloo', // Used for headings and titles
            color: Colors.black,
          ),
        ),
        centerTitle: true,
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
                  children: [
                    const Text(
                      'At Todd Care, we take your privacy seriously and are committed to safeguarding your personal data. This Privacy Policy explains what information we collect, how we use it, and how we protect it. By using Todd Care, you consent to the practices described in this policy.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '1. Information We Collect',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'When you use Todd Care, we collect the following types of information:',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Personal Information: Including your name, email, phone number, and account details.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Device Information: Including your device type, operating system, and usage statistics.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Location Information: To help match babysitters with parents based on their location.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Payment Information: If using the app for transactions, we collect payment details processed by secure third-party services.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We use the information we collect for the following purposes:',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• To create and manage your account.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• To provide matching services between parents and babysitters.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• To process payments and handle billing inquiries.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• To send updates, notifications, and promotional materials (with your consent).',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• To ensure the security of the app and prevent fraud.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '3. Sharing Your Information',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We do not sell or rent your personal information. We may share your data in the following situations:',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• With service providers who assist in operating the app.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• For legal purposes, if required by law or to comply with legal obligations.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• With other users for the purpose of matching babysitters and parents.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '4. Data Retention',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We retain your personal information as long as necessary to provide our services and fulfill the purposes outlined in this policy. If you request account deletion, we will delete your data, except as required by law.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '5. Your Rights',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You have the following rights regarding your personal information:',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Access your data and request a copy.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Request correction of any inaccurate data.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Request the deletion of your account and data.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Opt-out of promotional emails and notifications.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '6. Data Security',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We implement industry-standard security measures to protect your personal information. However, no method of transmission or storage is 100% secure, and we cannot guarantee the absolute security of your data.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '7. Children’s Privacy',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Todd Care is not intended for use by children under the age of 18. We do not knowingly collect personal data from children. If we become aware that we have collected information from a child under 18, we will take steps to delete such information.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '8. Changes to This Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We may update this Privacy Policy from time to time. If we make significant changes, we will notify you through the app or via email.',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '9. Contact Us',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Used for headings and titles
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'If you have any questions about this Privacy Policy or how we handle your data, please contact us at:',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Email: toddcare@gmail.com',
                      style: TextStyle(
                        fontFamily:
                            'Balsamiq Sans', // Used for body and subtitles
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          onAccept(); // Call the callback to accept privacy policy
                          Navigator.pop(context); // Go back to RegistrationPage
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey[300], // Button background color
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'ACCEPT',
                          style: TextStyle(
                            fontFamily: 'Poppins', // Used for numbers
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
