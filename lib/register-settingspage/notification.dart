import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Ensures the entire screen is scrollable
        child: Column(
          children: [
            Settings5DelaCerna(title: 'Notifications'),
          ],
        ),
      ),
    );
  }
}

class Settings5DelaCerna extends StatefulWidget {
  final String title;

  const Settings5DelaCerna({super.key, required this.title});

  @override
  _Settings5DelaCernaState createState() => _Settings5DelaCernaState();
}

class _Settings5DelaCernaState extends State<Settings5DelaCerna> {
  bool emailMessages = false;
  bool pushMessages = false;
  bool emailReminders = false;
  bool pushReminders = false;
  bool emailPromotions = false;
  bool pushPromotions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color(0xFFFFDEDE)),
      child: Column(
        children: [
          // Row for arrow and title alignment
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Title aligned to the left side, beside the back arrow
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0), // Add some space between arrow and title
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 24,
                      fontFamily: 'Baloo2',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20), // Space between title and sections

          // Messages Section
          buildNotificationSection(
            title: 'Messages',
            description:
                'Receive messages from members, including booking requests.',
            emailValue: emailMessages,
            pushValue: pushMessages,
            onEmailChanged: (value) => setState(() => emailMessages = value),
            onPushChanged: (value) => setState(() => pushMessages = value),
          ),
          // Reminders Section
          buildNotificationSection(
            title: 'Reminders',
            description:
                'Receive booking reminders, requests to write a review, and other reminders.',
            emailValue: emailReminders,
            pushValue: pushReminders,
            onEmailChanged: (value) => setState(() => emailReminders = value),
            onPushChanged: (value) => setState(() => pushReminders = value),
          ),
          // Promotions and Tips Section
          buildNotificationSection(
            title: 'Promotions and Tips',
            description:
                'Receive coupons, promotions, surveys, product updates, and inspiration.',
            emailValue: emailPromotions,
            pushValue: pushPromotions,
            onEmailChanged: (value) => setState(() => emailPromotions = value),
            onPushChanged: (value) => setState(() => pushPromotions = value),
          ),
          const SizedBox(height: 40), // Bottom padding for spacing
        ],
      ),
    );
  }

  // Simplified notification section without Position and Stack
  Widget buildNotificationSection({
    required String title,
    required String description,
    required bool emailValue,
    required bool pushValue,
    required ValueChanged<bool> onEmailChanged,
    required ValueChanged<bool> onPushChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF424242),
              fontSize: 22,
              fontFamily: 'BalsamiqSans',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 377,
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
                fontFamily: 'BalsamiqSans',
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 377,
            height: 138,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: emailValue,
                  onChanged: onEmailChanged,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFF48FB1),
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                ),
                SwitchListTile(
                  title: const Text(
                    'Push notifications',
                    style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: pushValue,
                  onChanged: onPushChanged,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFF48FB1),
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
