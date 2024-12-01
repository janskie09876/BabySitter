import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/welcome_back.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/register-settingspage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/pages/map_page.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _selectedPaymentMethod;

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
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  title: Text(
                    'Echizen Ryoma',
                    style: TextStyle(
                      fontFamily: 'Baloo', // Menu title font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                _buildMenuItem(context, Icons.person, 'Profile', () {
                  Navigator.pop(context); // Close the menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountPage(), // Navigate to AccountPage
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.history, 'Transaction History',
                    () {
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
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Settings(title: 'Settings'), // Navigate to Settings
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.logout, 'Logout', () async {
                  try {
                    await FirebaseAuth.instance.signOut(); // Firebase logout
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WelcomeBack(), // Navigate to WelcomeBackPage
                      ),
                      (route) => false, // Remove all previous routes
                    );
                  } catch (e) {
                    // Handle logout errors
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
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Baloo', // Menu item font
        ),
      ),
      onTap: onTap,
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Payment Method',
            style: TextStyle(
              fontFamily: 'Baloo', // Dialog title font
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text(
                  'GPay',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Payment method font
                  ),
                ),
                trailing: _selectedPaymentMethod == 'GPay'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'GPay';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.money),
                title: Text(
                  'Cash on Hand',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Payment method font
                  ),
                ),
                trailing: _selectedPaymentMethod == 'Cash on Hand'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'Cash on Hand';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Baloo', // Button font
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
              fontFamily: 'Baloo', // AppBar title font
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppStyles.primaryColor, // Use AppStyles.primaryColor
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.menu,
                  color: AppStyles.textColor), // Use AppStyles.textColor
              onPressed: () => _showMenuDialog(context),
            ),
          ],
        ),
        body: Padding(
          padding: AppStyles.defaultPadding, // Use AppStyles.defaultPadding
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
          backgroundColor:
              AppStyles.secondaryColor, // Use AppStyles.secondaryColor
          child: IconButton(
            icon: const Icon(Icons.public,
                color: AppStyles.whiteColor), // Use AppStyles.whiteColor
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const maps(), // Navigate to the maps page
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppStyles.primaryColor, // Use AppStyles.primaryColor
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
                        builder: (context) =>
                            Dashboard(), // Navigate to Dashboard
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
                        builder: (context) =>
                            ChatPage1(), // Navigate to ChatPage1
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()), // Space for the FAB
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationPage(), // Navigate to NotificationPage
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
                        builder: (context) =>
                            AccountPage(), // Navigate to AccountPage
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
