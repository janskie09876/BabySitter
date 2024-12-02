import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';

class BookingsList extends StatelessWidget {
  final String nannyId;
  final Function(String) fetchBookings;

  const BookingsList({
    Key? key,
    required this.nannyId,
    required this.fetchBookings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchBookings('Confirmed'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No confirmed requests.'));
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
                      'Confirmed Booking with ${booking['userName']}',
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
