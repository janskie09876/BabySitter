import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/editbabysitterprofile.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/location-transactionhistorypage/nannytransaction.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/confirmbook.dart';
import 'package:babysitter/login-bookingrequestpage/pendingbook.dart';
import 'package:babysitter/login-bookingrequestpage/welcome_back.dart';
import 'package:babysitter/menu-chatpage/chatpage.dart';
import 'package:babysitter/menu-chatpage/nannychatlist.dart';
import 'package:babysitter/notifications-stylepage/babysitternotif.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/register-settingspage/babysittersettings.dart';
import 'package:babysitter/register-settingspage/nannysettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class DashboardNanny extends StatelessWidget {
  const DashboardNanny({Key? key}) : super(key: key);

  // Get the currently logged-in nanny's ID
  Future<String?> getCurrentNannyId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid; // Return the current user's UID
    } catch (e) {
      print("Error fetching nannyId: $e");
      return null;
    }
  }

  // Fetch the current user's name from Firestore
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
    return FutureBuilder<String?>(
      future: getCurrentNannyId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.blackColor),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No nanny ID found. Please log in.',
                style: TextStyle(color: AppColors.blackColor),
              ),
            ),
          );
        }

        final String nannyId = snapshot.data!;
        return Scaffold(
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
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.grayColor,
                  indicatorColor: AppColors.primaryColor,
                  tabs: [
                    Tab(text: 'Pending Requests'),
                    Tab(text: 'Confirmed Requests'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      PendingBookingsList(nannyId: nannyId),
                      ConfirmedBookingsList(nannyId: nannyId),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: AppColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.home,
                        size: 30, color: AppColors.whiteColor),
                    onPressed: () {
                      // Implement Home Navigation
                    },
                  ),
                ),
                // Chat Page
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        size: 30, color: AppColors.whiteColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NannyChatListPage(),
                        ),
                      );
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
                // Notifications
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none,
                        size: 30, color: AppColors.whiteColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NannyNotificationPage(),
                        ),
                      );
                    },
                  ),
                ),

                // Profile
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.person_outline,
                        size: 30, color: AppColors.whiteColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterAccountPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  title: FutureBuilder<String>(
                    future: getCurrentUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(color: AppColors.blackColor),
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        );
                      } else {
                        return const Text(
                          'Guest',
                          style: TextStyle(color: AppColors.blackColor),
                        );
                      }
                    },
                  ),
                ),
                const Divider(color: AppColors.grayColor),
                _buildMenuItem(context, Icons.person, 'Profile', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabysitterAccountPage(),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.history, 'Transaction History',
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NannyTransactionPage(),
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
                      builder: (context) => NannySettingsPage(),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.logout, 'Logout', () async {
                  try {
                    await FirebaseAuth.instance.signOut(); // Firebase logout
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
        style: const TextStyle(color: AppColors.blackColor),
      ),
      onTap: onTap,
    );
  }
}
