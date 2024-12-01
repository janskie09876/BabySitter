import 'package:flutter/material.dart';

import 'babysitter_section.dart';
import 'chat_page.dart';
import 'top_rated_section.dart';

class BabysitterHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'ToddCare',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => _showMenuDialog(context),
          ),
        ],
      ),
      backgroundColor: Colors.pink.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find Babysitter',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Find a trusted babysitter near you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),
              SearchBar(),
              SizedBox(height: 20),
              BabysitterSection(),
              SizedBox(height: 20),
              TopRatedSection(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.pink,
        child: IconButton(
          icon: Icon(Icons.public, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.pink.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage1()),
                  );
                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.notifications_none, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
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
                  _showPaymentDialog(context);
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
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

//Navigation drawer
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Credit Card'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle Credit Card selection
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Wallet'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle Wallet selection
                },
              ),
              ListTile(
                leading: Icon(Icons.paypal),
                title: Text('PayPal'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle PayPal selection
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
