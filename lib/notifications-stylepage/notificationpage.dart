import 'package:babysitter/model/users_notifications.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // final newNotification = UsersNotifications(userId: 'userId', message: 'message', route: 'route', timestamp: DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Baloo', // Heading font
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // newNotification.createNotification();
            Navigator.pop(context);
          },
        ),
      ),
      // Container
      // 1x Column
      // 2x Column
      // Each Column has the following:
      // A row for each notification
      // The row must contain an image row and content column e.g message and timedate

      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Today
            Column(
              children: [
                // Date title and setting icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'Balsamiq Sans', // Subtitle font
                        fontSize: 18,
                      ),
                    ),
                    // const Icon(Icons.more_horiz),
                  ],
                ),
                // Row for each notification
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundImage: AssetImage('assets/glanda.jpg'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Glanda sent you a message, please check your message.',
                            style: TextStyle(
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Today at 08.00 AM',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundImage: AssetImage('assets/linda.jpg'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Linda sent you a message, please check your message.',
                            style: TextStyle(
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Today at 08.00 AM',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            // Yesterday
            Column(
              children: [
                // Date title and setting icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Yesterday',
                      style: TextStyle(
                        fontFamily: 'Balsamiq Sans', // Subtitle font
                        fontSize: 18,
                      ),
                    ),
                    // const Icon(Icons.more_horiz),
                  ],
                ),
                // Row for each notification
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundImage: AssetImage('assets/linda.jpg'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎉 Confirmed! Linda is booked for 10/21/24 at 7 PM. See you soon!',
                            style: TextStyle(
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Yesterday at 08.00 AM',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Balsamiq Sans', // Body font
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
