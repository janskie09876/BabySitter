import 'package:babysitter/home-paymentpage/cashpay_page.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentDetailsPage extends StatefulWidget {
  final String bookingId; // Added bookingId

  const PaymentDetailsPage({Key? key, required this.bookingId})
      : super(key: key);

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  String selectedPaymentMethod = "Payment";
  double subtotal = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  // Safely parse 24-hour time strings into TimeOfDay objects
  TimeOfDay safeParseTime(String timeString) {
    try {
      final DateTime parsedTime =
          DateFormat('HH:mm').parse(timeString); // Parse 24-hour format
      return TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);
    } catch (e) {
      print('Error parsing time: $e');
      throw FormatException("Invalid time format: $timeString");
    }
  }

  // Calculate the total babysitting hours
  double calculateHours(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    // Handle overnight shifts (e.g., start 22:00, end 02:00)
    final totalMinutes = endMinutes >= startMinutes
        ? endMinutes - startMinutes
        : (1440 - startMinutes) + endMinutes;

    return totalMinutes / 60.0;
  }

  Future<void> fetchPaymentDetails() async {
    try {
      final bookingDoc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (!bookingDoc.exists) {
        throw Exception('Booking not found.');
      }

      final bookingData = bookingDoc.data();

      final subBookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .collection('booking')
          .limit(1)
          .get();

      if (subBookingSnapshot.docs.isEmpty) {
        throw Exception('Sub-booking not found.');
      }

      final subBookingData = subBookingSnapshot.docs.first.data();

      // Fetch start and end times in 24-hour format
      final String startTimeString = subBookingData['startTime'];
      final String endTimeString = subBookingData['endTime'];

      // Parse times into TimeOfDay objects
      final startTime = safeParseTime(startTimeString);
      final endTime = safeParseTime(endTimeString);

      // Calculate babysitting hours
      final totalHours = calculateHours(startTime, endTime);

      // Fetch babysitter's service fee
      final babysitterDoc = await FirebaseFirestore.instance
          .collection('babysitters')
          .doc(bookingData?['user2'])
          .get();

      if (!babysitterDoc.exists) {
        throw Exception('Babysitter not found.');
      }

      final babysitterData = babysitterDoc.data();
      final serviceFee =
          double.tryParse(babysitterData?['service'] ?? '0') ?? 0;

      setState(() {
        subtotal = totalHours * serviceFee;
        total = subtotal; // Adjust as needed
      });
    } catch (e) {
      print('Error fetching payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Details",
          style: TextStyle(
            fontFamily: 'Baloo', // Apply Baloo font
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyles.whiteColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyles.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(
                fontFamily: 'Baloo', // Apply Baloo font
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Cash Payment Method Card
            buildPaymentMethodCard(
              label: "Cash on Hand",
              iconPath: "assets/images/cashkwarta.jpg",
              isSelected: selectedPaymentMethod == "Cash on Hand",
              onTap: () {
                setState(() {
                  selectedPaymentMethod = "Cash on Hand";
                });
              },
            ),

            const Spacer(),
            // Subtotal and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subtotal:",
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\₱${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\₱${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Pay Now Button
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentMethod == "Cash on Hand") {
                  // Navigate to CashPayPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CashPayPage(
                        bookingId:
                            widget.bookingId, // Pass bookingId to CashPayPage
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select "Cash on Hand" to proceed.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3838E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Pay Now",
                style: TextStyle(
                  fontFamily: 'Baloo', // Apply Baloo font
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create Payment Method Card
  Widget buildPaymentMethodCard({
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppStyles.defaultPadding,
        decoration: BoxDecoration(
          color: AppStyles.whiteColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppStyles.secondaryColor : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Baloo', // Apply Baloo font
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios, // Arrow for selection
              color: isSelected ? AppStyles.secondaryColor : Colors.grey,
              size: 18, // Adjust the size for a neat appearance
            ),
          ],
        ),
      ),
    );
  }
}
