import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmedBookingsList extends StatelessWidget {
  final String nannyId;

  const ConfirmedBookingsList({Key? key, required this.nannyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('user2', isEqualTo: nannyId)
          .where('status', isEqualTo: 'Confirmed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No confirmed bookings.'));
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final bookingDoc = bookings[index];
            final bookingId = bookingDoc.id; // Get the bookingId

            return StreamBuilder<QuerySnapshot>(
              stream: bookingDoc.reference.collection('booking').snapshots(),
              builder: (context, subSnapshot) {
                if (subSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (subSnapshot.hasError) {
                  return Center(child: Text('Error: ${subSnapshot.error}'));
                } else if (!subSnapshot.hasData ||
                    subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox(); // No subbooking data
                }

                final subBookings = subSnapshot.data!.docs;

                return Column(
                  children: subBookings.map((subBookingDoc) {
                    final subBooking =
                        subBookingDoc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(subBooking['name'] ?? 'Unknown'),
                      subtitle: Text('Date: ${subBooking['date']}'),
                      onTap: () {
                        _showBookingDetailsDialog(
                          context,
                          bookingId, // Pass the bookingId
                          subBooking,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showBookingDetailsDialog(
    BuildContext context,
    String bookingId, // Receive the bookingId
    Map<String, dynamic> bookingDetails,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${bookingDetails['name'] ?? 'Unknown'}'),
              Text('Phone: ${bookingDetails['phone'] ?? 'Unknown'}'),
              Text('Date: ${bookingDetails['date'] ?? 'Unknown'}'),
              Text('Start Time: ${bookingDetails['startTime'] ?? 'Unknown'}'),
              Text('End Time: ${bookingDetails['endTime'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _markAsCompleted(
                  context,
                  bookingId, // Pass the bookingId
                  bookingDetails['senderId'], // Correctly pass the parentId
                );
              },
              child: const Text('Mark as Completed'),
            ),
          ],
        );
      },
    );
  }

  void _markAsCompleted(
      BuildContext context, String bookingId, String parentId) async {
    try {
      // Update the booking status to "Completed"
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'Completed'});

      // Send a notification to the parent with bookingId
      await _sendNotification(
        parentId: parentId,
        bookingId: bookingId, // Include bookingId in the notification
        message:
            'The babysitter has marked the service as completed. Payment is now due.',
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking marked as completed.')),
      );
    } catch (e) {
      print('Error marking booking as completed: $e');
    }
  }

  Future<void> _sendNotification({
    required String parentId,
    required String bookingId, // Pass bookingId
    required String message,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'parentId': parentId,
        'bookingId': bookingId, // Save bookingId in the notification
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false, // To track unread notifications
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
