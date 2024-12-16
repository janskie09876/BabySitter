import 'package:babysitter/account-ratingandreviewpage-terms/editbabysitterprofile.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/privacypolicy.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/termspage.dart';
import 'package:babysitter/location-transactionhistorypage/nannytransaction.dart';
import 'package:babysitter/register-settingspage/nannychangepass.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark background
  static const Color beige = Color(0xFFE3C3A3); // Beige
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black
  static const Color grayColor = Color(0xFF7D7D7D); // Gray
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFBC02D); // Yellow
  static const Color whiteColor = Color(0xFFFFFFFF); // White
  static const Color redColor = Color(0xFFFF0000); // Red
}

class NannySettingsPage extends StatefulWidget {
  @override
  _NannySettingsPageState createState() => _NannySettingsPageState();
}

class _NannySettingsPageState extends State<NannySettingsPage> {
  String userName = "Guest"; // Default user name

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // Function to fetch the current user's name from Firestore
  Future<void> fetchUserName() async {
    String name = await getCurrentUserName();
    setState(() {
      userName = name; // Update the UI with the fetched name
    });
  }

  Future<String> getCurrentUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        // Query Firestore for the user's document using the UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('babysitters')
            .doc(user.uid) // Match document ID with the UID
            .get();

        // Return the name field or default to "Guest"
        return userDoc['name'] ?? "Guest";
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
    return "Guest"; // Default value if no user is logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with actual image URL
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName, // Display the dynamic user name
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.primaryColor),
              title: Text(
                'Edit profile',
                style: TextStyle(color: AppColors.blackColor),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditBabysitterProfilePage(), // Navigate to EditBabysitterProfilePage
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history, color: AppColors.primaryColor),
              title: Text(
                'Payments Received',
                style: TextStyle(color: AppColors.blackColor),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NannyTransactionPage(), // Navigate to NannyTransactionPage
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(Icons.password_rounded, color: AppColors.primaryColor),
              title: Text('Change Password',
                  style: TextStyle(color: AppColors.blackColor)),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFC47F42)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NannyChangePassword(), // Replace with your class
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.security, color: AppColors.primaryColor),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: AppColors.blackColor),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFC47F42)),
              onTap: () {
                // Navigate to PrivacyPolicyPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage(
                      onAccept: () {},
                    ), // Navigate to PrivacyPolicyPage
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description, color: AppColors.primaryColor),
              title: Text(
                'Terms and Condition',
                style: TextStyle(color: AppColors.blackColor),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFC47F42)),
              onTap: () {
                // Navigate to TermsAndConditionsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsPage(
                      onAccept: () {},
                    ), // Navigate to TermsAndConditionsPage
                  ),
                );
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
