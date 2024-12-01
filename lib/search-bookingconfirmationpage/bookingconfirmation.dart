import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:babysitter/home-paymentpage/payment_methods_page.dart';
import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String babysitterName;
  final String startDate;
  final String endDate;
  final String address;
  final double totalAmount;

  const BookingConfirmationPage({
    super.key,
    required this.babysitterName,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        centerTitle: true,
        backgroundColor: AppStyles.primaryColor,
        iconTheme: IconThemeData(color: AppStyles.textColor),
        elevation: 0,
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('Date & Time', '$startDate to $endDate'),
            _buildInfoTile('Babysitter Name', babysitterName),
            _buildInfoTile('Address', address),
            const SizedBox(height: 16),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: AppStyles.headingStyle,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: AppStyles.primaryButtonStyle,
                onPressed: () {
                  // Navigate to Payment Methods Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailsPage(),
                    ),
                  );
                },
                child: const Text('Proceed to Pay', style: AppStyles.bodyStyle),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppStyles.backgroundColor,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: AppStyles.fieldPadding,
      child: Container(
        decoration: AppStyles.cardDecoration,
        padding: AppStyles.defaultPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppStyles.subheadingStyle),
            Text(value, style: AppStyles.bodyStyle),
          ],
        ),
      ),
    );
  }
}
