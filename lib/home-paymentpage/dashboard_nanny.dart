import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/editbabysitterprofile.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/confirmbook.dart';
import 'package:babysitter/login-bookingrequestpage/pendingbook.dart';
import 'package:babysitter/menu-chatpage/chatpage.dart';
import 'package:babysitter/menu-chatpage/nannychatlist.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/register-settingspage/babysittersettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No nanny ID found. Please log in.')),
          );
        }

        final String nannyId = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nanny Dashboard'),
            backgroundColor: AppStyles.primaryColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _showMenuDialog(context),
              ),
            ],
          ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: AppStyles.secondaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppStyles.secondaryColor,
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
            color: AppStyles.secondaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.home, size: 30),
                    onPressed: () {
                      // Implement Home Navigation
                    },
                  ),
                ),
                // Chat Page
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, size: 30),
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
                // Profile
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.person_outline, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBabysitterProfilePage(),
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
            side: BorderSide(color: Colors.pink.shade200, width: 2),
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
                  title: FutureBuilder<String?>(
                    future: getCurrentNannyId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontFamily: 'Baloo',
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const Text('Unknown');
                      }
                    },
                  ),
                ),
                const Divider(),
                _buildMenuItem(context, Icons.person, 'Profile', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.history, 'Transaction History',
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionHistoryPage(),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BabySettings(title: 'Settings'),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.logout, 'Logout', () {
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
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
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: onTap,
    );
  }
}
