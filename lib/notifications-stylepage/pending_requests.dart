import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';

class PendingRequestsList extends StatelessWidget {
  final String nannyId;
  final Function(String) fetchBookings;

  const PendingRequestsList({
    Key? key,
    required this.nannyId,
    required this.fetchBookings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchBookings('Pending'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No pending requests.'));
        }

        final bookings = snapshot.data!;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return Padding(
              padding: AppStyles.sectionPadding,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                color: AppStyles.whiteColor,
                child: Padding(
                  padding: AppStyles.sectionPadding,
                  child: ListTile(
                    title: Text(
                      'Booking with ${booking['userName']}',
                      style: AppStyles.headingStyle,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${booking['date']}',
                            style: AppStyles.bodyStyle),
                        Text('Time: ${booking['time']}',
                            style: AppStyles.bodyStyle),
                        Text('Status: ${booking['status']}',
                            style: AppStyles.bodyStyle),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            updateBookingStatus(booking['id'], 'Confirmed');
                            sendNotification(
                                booking['userName'], 'Booking confirmed');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            updateBookingStatus(booking['id'], 'Declined');
                            sendNotification(
                                booking['userName'], 'Booking declined');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Update booking status in Firestore
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

  // Send notification to Firestore
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
}
