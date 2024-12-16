import 'package:babysitter/home-paymentpage/cashpay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

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

  double calculateHours(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

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

      final String startTimeString = subBookingData['startTime'];
      final String endTimeString = subBookingData['endTime'];

      final startTime = safeParseTime(startTimeString);
      final endTime = safeParseTime(endTimeString);

      final totalHours = calculateHours(startTime, endTime);

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
        total = subtotal;
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
            fontFamily: 'Baloo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subtotal:",
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                ),
                Text(
                  "\₱${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
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
                    fontFamily: 'Baloo',
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                ),
                Text(
                  "\₱${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Pay Now Button
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentMethod == "Cash on Hand") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CashPayPage(
                        bookingId: widget.bookingId,
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
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Pay Now",
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 18,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard({
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
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
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
