import 'package:babysitter/account-ratingandreviewpage-terms/editparentprofile.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Parentaccountpage extends StatelessWidget {
  final Color secondaryColor = const Color(0xFFE3838E);

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigates back
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
        elevation: 0,
        backgroundColor: const Color(0xFFFFDEDE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            const CircleAvatar(
              radius: 50,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  'assets/images/linda.jpg',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User Name (Dynamic)
            FutureBuilder<String>(
              future: getCurrentUserName(), // Fetch the user's name dynamically
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator while waiting
                }

                if (snapshot.hasError) {
                  return Text('Error loading user name');
                }

                String userName = snapshot.data ??
                    "Guest"; // Use fetched name or default to "Guest"

                return Text(
                  userName, // Display the fetched user name
                  style: AppStyles.headingStyle,
                );
              },
            ),
            const SizedBox(height: 32),
            // List Items
            Expanded(
              child: ListView.separated(
                itemCount: 4,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final items = [
                    {'icon': Icons.person, 'title': 'Personal Information'},
                    {'icon': Icons.payment, 'title': 'Payments and Payouts'},
                    {'icon': Icons.notifications, 'title': 'Notifications'},
                    {'icon': Icons.privacy_tip, 'title': 'Privacy and Sharing'},
                  ];

                  return ListTile(
                    leading: Icon(
                      items[index]['icon'] as IconData,
                      color: secondaryColor,
                    ),
                    title: Text(
                      items[index]['title'] as String,
                      style: AppStyles.bodyStyle,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      // Handle navigation for specific items
                      switch (index) {
                        case 0: // Personal Information
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditParentProfilePage(),
                            ),
                          );
                          break;
                        case 1: // Payments and Payouts
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => NotificationPage(),
                          //   ),
                          // );
                          break;
                        case 2: // Notifications
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(),
                            ),
                          );
                          break;
                        case 3: // Privacy and Sharing
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => RequirementsPage(),
                          //   ),
                          // );
                          break;
                        default:
                          break;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppStyles.backgroundColor,
    );
  }
}
