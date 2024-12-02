import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/editbabysitterprofile.dart';
import 'package:babysitter/availability-helpandsupport/FAQ.dart';
import 'package:babysitter/location-transactionhistorypage/transactionhistorypage.dart';
import 'package:babysitter/login-bookingrequestpage/booking_list.dart';
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/pending_requests.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/register-settingspage/babysittersettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardNanny extends StatelessWidget {
  final String nannyId; // Use the Firebase document ID of the nanny

  const DashboardNanny({Key? key, required this.nannyId}) : super(key: key);

  // Fetch all bookings (both Pending and Confirmed) for the nanny
  Stream<List<Map<String, dynamic>>> fetchBookings(String status) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('nannyId', isEqualTo: nannyId) // Filter bookings by nannyId
        .where('status',
            isEqualTo: status) // Filter by the status (Pending or Confirmed)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                ...doc.data(),
                'id': doc.id
              }; // Add document ID to the data
            }).toList());
  }

  // Update the booking status to either Accepted or Declined
  void updateBookingStatus(String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  // Send notification when booking status changes
  void sendNotification(String userName, String message) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'message': '$userName: $message',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nanny Dashboard'),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () =>
                _showMenuDialog(context), // Trigger the menu dialog
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // Two tabs: Pending and Confirmed
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
                  PendingRequestsList(
                      nannyId: nannyId, fetchBookings: fetchBookings),
                  BookingsList(nannyId: nannyId, fetchBookings: fetchBookings),
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
                      builder: (context) => DashboardNanny(nannyId: nannyId),
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
