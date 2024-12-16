import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/review.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class CashPayPage extends StatelessWidget {
  final String bookingId;

  const CashPayPage({Key? key, required this.bookingId}) : super(key: key);

  void _confirmPayment(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'paymentStatus': 'Paid'});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rate Your Nanny'),
            content: const Text('Please take a moment to rate your nanny.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Navigate to the BabysitterRatingForm
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabysitterRatingForm(),
                    ),
                  );
                },
                child: const Text('Rate Now'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error confirming payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm payment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cash Payment',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        // Makes the body scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Pay with Cash',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Choose the Cash option if you prefer to pay after the babysitting session is completed. '
                'With this method, you have the flexibility to inspect the service before making payment.',
              ),
              const SizedBox(height: 16),
              const Text(
                'How to Complete Cash Payment:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Book your babysitter as usual.\n'
                '2. Select "Cash" as your preferred payment method during booking.\n'
                '3. Once the babysitting session is complete, provide the total amount directly to the babysitter.\n'
                '4. The babysitter will confirm the payment in the app, finalizing the transaction.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                context,
                'Note: The babysitter will not receive payment until the session is completed and you confirm satisfaction with the service. '
                'Please ensure you have the correct amount available at the time of payment.',
                isItalic: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _confirmPayment(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 16, color: AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.primaryColor,
        child: IconButton(
          icon: const Icon(Icons.public, color: AppColors.whiteColor),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text,
      {bool isItalic = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.blackColor,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavBarItem(context, Icons.home, 'Home', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          }),
          _buildNavBarItem(context, Icons.chat_bubble_outline, 'Chat', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatPage1()));
          }),
          const SizedBox(width: 48), // Space for the floating button
          _buildNavBarItem(context, Icons.notifications_none, 'Notifications',
              () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationPage()));
          }),
          _buildNavBarItem(context, Icons.person_outline, 'Profile', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BabysitterAccountPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: IconButton(
        icon: Icon(icon, size: 30, color: AppColors.whiteColor),
        onPressed: onTap,
      ),
    );
  }
}
