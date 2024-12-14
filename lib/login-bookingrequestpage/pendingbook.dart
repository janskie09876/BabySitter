import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingBookingsList extends StatelessWidget {
  final String nannyId;

  const PendingBookingsList({Key? key, required this.nannyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('user2', isEqualTo: nannyId)
          .where('status', isEqualTo: 'Pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending bookings.'));
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final bookingDoc = bookings[index];

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
                          bookingDoc.id,
                          subBookingDoc.id,
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
    String bookingId,
    String subBookingId,
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
              Text('Start at: ${bookingDetails['startTime'] ?? 'Unknown'}'),
              Text('End at: ${bookingDetails['endTime'] ?? 'Unknown'}'),
              Text('Date: ${bookingDetails['date'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(bookingId)
                    .update({'status': 'Declined'});
                Navigator.pop(context);
              },
              child: const Text('Decline', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(bookingId)
                    .update({'status': 'Confirmed'}).then((_) {
                  // Notify the parent
                  _sendNotification(
                    parentId: bookingDetails['senderId'],
                    nannyId: bookingDetails['receiverId'],
                    nannyName: 'Your Nanny',
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  void _sendNotification({
    required String parentId,
    required String nannyId,
    required String nannyName,
  }) {
    FirebaseFirestore.instance.collection('notifications').add({
      'parentId': parentId,
      'nannyId': nannyId,
      'message': 'Your booking has been accepted by $nannyName.',
      'timestamp': FieldValue.serverTimestamp(),
      'read': false, // To track if the parent has seen the notification
    }).then((_) {
      print('Notification sent to parentId: $parentId');
    }).catchError((error) {
      print('Error sending notification: $error');
    });
  }
}
