import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/parentaccountpage.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/welcome_back.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/pages/viewmap1.dart';
import 'package:babysitter/register-settingspage/settings.dart'
    as my_settings; // Alias for Settings
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            .collection('users')
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
            side: BorderSide(color: Colors.pink.shade200, width: 2),
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
                          fontFamily: 'Baloo',
                          fontWeight: FontWeight.bold,
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
                          builder: (context) => my_settings.Settings(
                              title: 'Settings'), // Use alias here
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
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Baloo',
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
              fontFamily: 'Baloo',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppStyles.primaryColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: AppStyles.textColor),
              onPressed: () => _showMenuDialog(context),
            ),
          ],
        ),
        body: Padding(
          padding: AppStyles.defaultPadding,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
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
          backgroundColor: AppStyles.secondaryColor,
          child: IconButton(
            icon: const Icon(Icons.public, color: AppStyles.whiteColor),
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
          color: AppStyles.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.home, size: 30),
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
                  icon: const Icon(Icons.chat_bubble_outline, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage1(),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.person_outline, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(),
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
