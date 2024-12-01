import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Automatically show the menu dialog when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMenuDialog(context);
    });

    // The actual page can remain minimal since the dialog is the focus
    return Scaffold(
      body: Container(
        color: Colors.white, // Just a blank screen while the dialog is active
      ),
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.pink.shade200, width: 2),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  title: Text('Welcome, User!'),
                ),
                Divider(),
                _buildMenuItem(context, Icons.person, 'Profile', () {
                  Navigator.pop(context);
                  // Navigate to Profile page or handle action
                }),
                _buildMenuItem(context, Icons.calendar_today, 'Bookings', () {
                  Navigator.pop(context);
                  // Navigate to Bookings page or handle action
                }),
                _buildMenuItem(context, Icons.payment, 'Payment Method', () {
                  Navigator.pop(context);
                  // Handle payment method action
                }),
                _buildMenuItem(context, Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  // Navigate to Settings page or handle action
                }),
                _buildMenuItem(context, Icons.logout, 'Logout', () {
                  Navigator.pop(context);
                  // Handle logout action
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(text),
      onTap: onTap,
    );
  }
}
