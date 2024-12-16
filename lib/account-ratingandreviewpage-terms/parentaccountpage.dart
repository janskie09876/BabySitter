import 'package:babysitter/account-ratingandreviewpage-terms/editparentprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class ParentAccountPage extends StatelessWidget {
  const ParentAccountPage({super.key});

  // Fetch the current user's name from Firestore
  Future<String> getCurrentUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user != null) {
        // Query Firestore for the user's document using the UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('parents')
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Background and Profile Picture
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bless.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 20, // Position the profile picture to the left
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.whiteColor,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/liza.jpg'),
                    ),
                  ),
                ),
                // Name below Profile Picture
                Positioned(
                  top: 240, // Place name below the profile picture
                  left: 15, // Align name to the left
                  child: FutureBuilder<String>(
                    future: getCurrentUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loader while waiting
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          "Error loading name",
                          style: TextStyle(
                              fontSize: 22, color: AppColors.blackColor),
                        );
                      }

                      String userName = snapshot.data ?? "Guest";
                      return Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      );
                    },
                  ),
                ),
                // Location below the Name
                Positioned(
                  top: 275, // Place location below the name
                  left: 15, // Align location to the left
                  child: const Text(
                    "NY, Kellogg Rd New Hartford, 44",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grayColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Row for Edit Profile Button (aligned to the right)
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align items to the right
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to EditParentProfilePage when button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditParentProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightCoffeeBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Section

            // About Me Section
            _sectionTitle("About me"),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.cake, color: AppColors.lightCoffeeBrown),
                const SizedBox(width: 8),
                const Text(
                  "12 Sep 1992",
                  style: TextStyle(fontSize: 14, color: AppColors.grayColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.female, color: AppColors.lightCoffeeBrown),
                const SizedBox(width: 8),
                const Text(
                  "Female",
                  style: TextStyle(fontSize: 14, color: AppColors.grayColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Hi, I'm Courtney! I'm a busy full-time designer and often need extra help caring for my little one. I'm looking for a reliable babysitter who understands how important my child is to me and can bring warmth and energy to their time together.",
                style: TextStyle(fontSize: 14, color: AppColors.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Stats Section
  Widget _statCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grayColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Section Title
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
