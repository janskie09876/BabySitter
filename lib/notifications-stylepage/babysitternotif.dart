import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class NannyNotificationPage extends StatelessWidget {
  const NannyNotificationPage({Key? key}) : super(key: key);

  // Static list of notifications for Asher, AJ, Jan, and Jhimboy
  final List<Map<String, dynamic>> notifications = const [
    {
      'name': 'Asher',
      'message': 'Your babysitting session has been confirmed.',
      'timestamp': '2024-06-16 10:30 AM',
      'read': false,
    },
    {
      'name': 'AJ',
      'message': 'You have a new booking request.',
      'timestamp': '2024-06-15 08:00 AM',
      'read': true,
    },
    {
      'name': 'Jan',
      'message': 'Payment has been successfully received.',
      'timestamp': '2024-06-14 04:45 PM',
      'read': false,
    },
    {
      'name': 'Jhimboy',
      'message': 'Your profile update was successful.',
      'timestamp': '2024-06-13 02:30 PM',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications available.',
                style: TextStyle(color: AppColors.blackColor),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final name = notification['name'];
                final message = notification['message'];
                final timestamp = notification['timestamp'];
                final isRead = notification['read'] == true;

                return ListTile(
                  title: Text(
                    '$name: $message',
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  subtitle: Text(
                    timestamp,
                    style: const TextStyle(color: AppColors.grayColor),
                  ),
                  tileColor:
                      isRead ? AppColors.whiteColor : AppColors.lightBackground,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      name[0], // First letter of the name
                      style: const TextStyle(
                          color: AppColors.whiteColor, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
