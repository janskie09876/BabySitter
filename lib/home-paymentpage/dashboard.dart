import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/parentaccountpage.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/welcome_back.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/menu-chatpage/chatpage1.dart';
import 'package:babysitter/notifications-stylepage/notif.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/pages/viewmap1.dart';
import 'package:babysitter/register-settingspage/settings.dart'
    as my_settings; // Alias for Settings
import 'package:babysitter/register-settingspage/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define a custom color palette
class AppColors {
  // Updated color palette
  static const Color primaryColor =
      Color(0xFFC47F42); // Orange for Buttons and accents
  static const Color lightBackground =
      Color(0xFFF5F5F5); // Light Background color
  static const Color darkBackground =
      Color(0xFF1E1E1E); // Dark Background for emphasis
  static const Color beige = Color(0xFFE3C3A3); // Beige for soft highlights
  static const Color coffeeBrown =
      Color(0xFF51331A); // Coffee Brown for headlines
  static const Color lightCoffeeBrown =
      Color(0xFF7B5B42); // Light Coffee Brown for borders
  static const Color blackColor = Color(0xFF000000); // Black for primary text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color successColor =
      Color(0xFF4CAF50); // Green for success messages
  static const Color warningColor = Color(0xFFFBC02D); // Yellow for warnings
  static const Color whiteColor =
      Color(0xFFFFFFFF); // White for background and text highlights
  static const Color redColor = Color(0xFFFF0000); // Red for notifications
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _selectedPaymentMethod;

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

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.lightCoffeeBrown, width: 2),
          ),
          child: FutureBuilder<String>(
            future: getCurrentUserName(), // Fetch the user's name dynamically
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading user name'));
              }

              String userName = snapshot.data ?? "User"; // Use fetched name

              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                      title: Text(
                        userName, // Display the fetched user name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000), // Coffee Brown for name
                        ),
                      ),
                    ),
                    Divider(),
                    _buildMenuItem(context, Icons.person, 'Profile', () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Parentaccountpage(),
                        ),
                      );
                    }),
                    _buildMenuItem(
                        context, Icons.history, 'Transaction History', () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionHistoryPage(),
                        ),
                      );
                    }),
                    _buildMenuItem(context, Icons.help_outline, 'FAQ', () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FAQPage(),
                        ),
                      );
                    }),
                    _buildMenuItem(context, Icons.settings, 'Settings', () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SettingsPage(), // Use alias here
                        ),
                      );
                    }),
                    _buildMenuItem(context, Icons.logout, 'Logout', () async {
                      try {
                        await FirebaseAuth.instance
                            .signOut(); // Firebase logout
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeBack(),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed: $e')),
                        );
                      }
                    }),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF000000),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Todd Care',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor, // White text for header
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.whiteColor),
              onPressed: () => _showMenuDialog(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.lightCoffeeBrown),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Logic here
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primaryColor, // Orange search icon
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: NannyList()),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primaryColor,
          child: IconButton(
            icon: const Icon(Icons.public, color: AppColors.whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewMap1(),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.home,
                      size: 30, color: AppColors.whiteColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      size: 30, color: AppColors.whiteColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentChatListPage(),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('parentId',
                          isEqualTo: FirebaseAuth.instance.currentUser
                              ?.uid) // Filter by current user's ID
                      .where('read',
                          isEqualTo: false) // Only unread notifications
                      .snapshots(),
                  builder: (context, snapshot) {
                    int unreadCount = 0;

                    if (snapshot.hasData && snapshot.data != null) {
                      unreadCount = snapshot.data!.docs.length;
                    }

                    return Stack(
                      clipBehavior:
                          Clip.none, // Allows the badge to overflow the bounds
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              size: 30, color: AppColors.whiteColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentNotifications(
                                  parentId:
                                      FirebaseAuth.instance.currentUser?.uid ??
                                          '',
                                ),
                              ),
                            );
                          },
                        ),
                        if (unreadCount >
                            0) // Show badge only if there are unread notifications
                          Positioned(
                            right: 55, // Adjusted position for proper alignment
                            top: 4, // Adjusted position for proper alignment
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.person_outline,
                      size: 30, color: AppColors.whiteColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Parentaccountpage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
