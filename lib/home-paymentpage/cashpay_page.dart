import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/account-ratingandreviewpage-terms/review.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CashPayPage extends StatelessWidget {
  final String bookingId; // Accept bookingId to update the payment status

  const CashPayPage({Key? key, required this.bookingId}) : super(key: key);

  void _confirmPayment(BuildContext context) async {
    try {
      // Update the payment status in Firestore
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'paymentStatus': 'Paid'});

      // Show dialog for rating
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rate Your Nanny'),
            content: const Text('Please take a moment to rate your nanny.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Navigate to the BabysitterRatingForm
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabysitterRatingForm(),
                    ),
                  );
                },
                child: const Text('Rate Now'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error confirming payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm payment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cash Payment',
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFDEDE),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Pay with Cash',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDEDE),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Choose the Cash option if you prefer to pay after the babysitting session is completed. '
                      'With this method, you have the flexibility to inspect the service before making payment.',
                      style: TextStyle(
                        fontFamily: 'BalsamiqSans',
                        fontSize: 16,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'How to Complete Cash Payment:',
                    style: TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: const Text(
                      '1. Book your babysitter as usual.\n'
                      '2. Select "Cash" as your preferred payment method during booking.\n'
                      '3. Once the babysitting session is complete, provide the total amount directly to the babysitter.\n'
                      '4. The babysitter will confirm the payment in the app, finalizing the transaction.',
                      style: TextStyle(
                        fontFamily: 'BalsamiqSans',
                        fontSize: 16,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDEDE),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Note: The babysitter will not receive payment until the session is completed and you confirm satisfaction with the service. Please ensure you have the correct amount available at the time of payment.',
                      style: TextStyle(
                        fontFamily: 'BalsamiqSans',
                        fontSize: 14,
                        color: Color(0xFF424242),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _confirmPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48FB1),
                      ),
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          fontFamily: 'Baloo',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.pink,
        child: IconButton(
          icon: const Icon(Icons.public, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.pink.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.home, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage1()),
                  );
                },
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.notifications_none, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.person_outline, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
