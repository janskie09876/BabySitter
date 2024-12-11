import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        ),
        body: const Center(
          child: Text('You need to log in to view notifications.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('parentId', isEqualTo: parentId) // Use current user's ID
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Debug: Check the query conditions and connection state
          print('Fetching notifications for parentId: $parentId');

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Connection state: waiting for data');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error fetching notifications: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No notifications found for parentId: $parentId');
            return const Center(child: Text('No notifications available.'));
          }

          final notifications = snapshot.data!.docs;
          print(
              'Fetched ${notifications.length} notifications for parentId: $parentId');

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data() as Map<String, dynamic>;

              // Debug: Log each notification document's data
              print('Notification data: $data');

              return ListTile(
                title: Text(data['message'] ?? 'Notification'),
                subtitle: Text(_formatTimestamp(data['timestamp'])),
                trailing: IconButton(
                  icon: Icon(
                    data['read'] == true ? Icons.check_circle : Icons.circle,
                    color: data['read'] == true ? Colors.green : Colors.red,
                  ),
                  onPressed: () {
                    _markAsRead(notification.id);
                  },
                ),
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
  void _markAsRead(String notificationId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true}).then((_) {
      print('Notification marked as read: $notificationId');
    }).catchError((error) {
      print('Error marking notification as read: $error');
    });
  }
}
