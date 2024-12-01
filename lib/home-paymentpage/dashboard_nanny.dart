import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/editbabysitterprofile.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/register-settingspage/babysittersettings.dart';
import 'package:babysitter/register-settingspage/settings.dart';
import 'package:babysitter/requirement-babysitterprofilepage/view_babysitter.dart';
import 'package:flutter/material.dart';

class DashboardNanny extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Todd Care',
            style: TextStyle(
              fontFamily: 'Baloo', // Title font
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor:
              AppStyles.primaryColor, // Use primaryColor from style.dart
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () =>
                  _showMenuDialog(context), // Trigger the menu dialog
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2, // Two tabs: Pending and Bookings
          child: Column(
            children: [
              const TabBar(
                labelColor: AppStyles
                    .secondaryColor, // Use secondaryColor from style.dart
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppStyles
                    .secondaryColor, // Use secondaryColor from style.dart
                tabs: [
                  Tab(text: 'Booking Requests'),
                  Tab(text: 'Confirmed Requests'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PendingRequestsList(),
                    BookingsList(),
                  ],
                ),
              ),
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
              // Implement your action for FAB here
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppStyles.secondaryColor,
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
                        builder: (context) => DashboardNanny(),
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
                        builder: (context) => BabysitterChatPage(),
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
                        builder: (context) => EditProfilePage(),
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

  // Show menu dialog
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
                      fontFamily: 'Baloo', // Title font
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
                      builder: (context) => BabySettings(title: 'Settings'),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.logout, 'Logout', () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build individual menu items
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
}

// Pending and Confirmed Request Widgets (Same as before)
class PendingRequestsList extends StatelessWidget {
  final List<Map<String, String>> pendingRequests = [
    {
      'name': 'John Doe',
      'date': 'Nov 25, 2024',
      'time': '2:00 PM',
      'image': 'https://www.example.com/path_to_profile_image.jpg',
    },
    {
      'name': 'Jane Smith',
      'date': 'Nov 27, 2024',
      'time': '10:00 AM',
      'image': 'https://www.example.com/path_to_profile_image.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        final request = pendingRequests[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(request['image'] ?? ''),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['name'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Baloo', // Name font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${request['date']} at ${request['time']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    print('Viewing details for ${request['name']}');
                  },
                  style: AppStyles.primaryButtonStyle,
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Baloo', // Button font
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookingsList extends StatelessWidget {
  final List<Map<String, String>> bookings = [
    {
      'name': 'Alice Brown',
      'date': 'Dec 01, 2024',
      'time': '4:00 PM',
      'location': '123 Elm Street',
      'image': 'images/img.jpg',
    },
    {
      'name': 'Michael Scott',
      'date': 'Dec 03, 2024',
      'time': '1:00 PM',
      'location': '456 Oak Avenue',
      'image': 'images/img.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(booking['image'] ?? ''),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['name'] ?? '',
                        style: TextStyle(
                          fontFamily: 'Baloo', // Name font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking['date']} at ${booking['time']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    print('Viewing booking details for ${booking['name']}');
                  },
                  style: AppStyles.primaryButtonStyle,
                  child: const Text(
                    'View Booking',
                    style: TextStyle(
                      fontFamily: 'Baloo', // Button font
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
