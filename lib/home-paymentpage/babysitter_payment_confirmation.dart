import 'package:flutter/material.dart';

class BabysitterPaymentConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Confirmation',
          style: TextStyle(
            fontFamily: 'Baloo', // Title font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF48FB1),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Image.asset(
              'images/bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context)
                  .size
                  .height, // Set height to fit screen
            ),
            // Semi-transparent container for content
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2)
                    .withOpacity(0.9), // Semi-transparent background
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Heading
                  const Center(
                    child: const Text(
                      'Confirm Payment',
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Explanation
                  const Text(
                    'Please confirm that you have received the payment after completing the babysitting session. '
                    'This will notify the client and update the booking status.',
                    style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 16,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Booking Details Section
                  const Text(
                    'Booking Details:',
                    style: TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '• Booking ID: 12345\n'
                    '• Date: 31st Oct 2024\n'
                    '• Duration: 3 hours\n'
                    '• Payment Method: Cash on Delivery',
                    style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 16,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Payment Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Confirmed')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48FB1),
                      ),
                      child: const Text(
                        'Confirm Payment Received',
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
    );
  }
}
