import 'package:babysitter/home-paymentpage/payment_methods_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class ParentNotifications extends StatelessWidget {
  const ParentNotifications({Key? key, required String parentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch current user's ID
    final String? parentId = FirebaseAuth.instance.currentUser?.uid;

    if (parentId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor:
              AppColors.primaryColor, // Set AppBar color to primaryColor
        ),
        body: const Center(
          child: Text('You need to log in to view notifications.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor:
            AppColors.primaryColor, // Set AppBar color to primaryColor
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('parentId', isEqualTo: parentId) // Use current user's ID
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data() as Map<String, dynamic>;

              final isRead = data['read'] == true;

              return ListTile(
                title: Text(
                  data['message'] ?? 'Notification',
                  style: TextStyle(
                    fontWeight: isRead
                        ? FontWeight.normal
                        : FontWeight.bold, // Bold for unread notifications
                    color: AppColors
                        .blackColor, // Text color for notification message
                  ),
                ),
                subtitle: Text(
                  _formatTimestamp(data['timestamp']),
                  style: TextStyle(
                      color: AppColors.grayColor), // Gray color for timestamp
                ),
                tileColor: isRead
                    ? AppColors.whiteColor
                    : AppColors
                        .lightBackground, // Light background for unread notifications
                onTap: () async {
                  // Mark the notification as read when clicked
                  await _markAsRead(notification.id);

                  // Navigate to the payment page only if the message matches
                  if (data['message'] ==
                      'The babysitter has marked the service as completed. Payment is now due.') {
                    final bookingId = data['bookingId'];
                    if (bookingId != null && bookingId is String) {
                      // Check the payment status before navigating
                      final paymentStatus =
                          await _checkPaymentStatus(bookingId);

                      if (paymentStatus == 'Paid') {
                        // Show AlertDialog for already paid
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Payment Completed'),
                              content: const Text(
                                  'This nanny has already been paid.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Navigate to the PaymentDetailsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentDetailsPage(bookingId: bookingId),
                          ),
                        );
                      }
                    } else {
                      // Handle the case where bookingId is null
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Missing booking details.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // Format timestamp to a readable string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown time';
    final date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd hh:mm a').format(date);
  }

  // Mark notification as read in Firestore
  Future<void> _markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      print('Notification marked as read: $notificationId');
    } catch (error) {
      print('Error marking notification as read: $error');
    }
  }

  // Check the payment status of a booking
  Future<String> _checkPaymentStatus(String bookingId) async {
    try {
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (bookingSnapshot.exists) {
        final bookingData = bookingSnapshot.data() as Map<String, dynamic>;
        return bookingData['paymentStatus'] ?? 'unpaid'; // Default to 'unpaid'
      } else {
        print('Booking not found: $bookingId');
        return 'unpaid'; // Default to 'unpaid' if booking not found
      }
    } catch (e) {
      print('Error checking payment status: $e');
      return 'unpaid'; // Default to 'unpaid' in case of error
    }
  }
}
