import 'package:flutter/material.dart';

class BookingsList extends StatelessWidget {
  final String nannyId;
  final Stream<List<Map<String, dynamic>>> Function(String, String)
      fetchBookings;
  final String status;

  const BookingsList({
    Key? key,
    required this.nannyId,
    required this.fetchBookings,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchBookings(status, nannyId), // Pass status and nannyId
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No bookings available.'));
        }

        final bookings = snapshot.data!;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    'Booking with ${booking['name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${booking['date']}'),
                      Text('Time: ${booking['time']}'),
                      Text('Phone: ${booking['phone']}'),
                      Text('Status: ${booking['status']}'),
                    ],
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
