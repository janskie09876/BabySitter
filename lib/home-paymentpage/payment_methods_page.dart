import 'package:babysitter/home-paymentpage/cashpay_page.dart';
import 'package:babysitter/home-paymentpage/gpay_page.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  String selectedPaymentMethod = "Payment";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            // Payment Method Cards
            buildPaymentMethodCard(
              label: "Google Pay",
              iconPath: "assets/images/gpaylogo.png",
              isSelected: selectedPaymentMethod == "Google Pay",
              onTap: () {
                setState(() {
                  selectedPaymentMethod = "Google Pay";
                });
              },
            ),
            const SizedBox(height: 20),
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
              children: const [
                Text(
                  "Subtotal:",
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\$450",
                  style: TextStyle(
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
              children: const [
                Text(
                  "Total:",
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\$450",
                  style: TextStyle(
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
                if (selectedPaymentMethod == "Google Pay") {
                  // Navigate to GPayPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GPayPage()),
                  );
                } else if (selectedPaymentMethod == "Cash on Hand") {
                  // Navigate to CashPayPage or show relevant action for Cash on Hand
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CashPayPage()),
                  );
                } else {
                  // Handle other payment methods if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please select a valid payment method.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3838E),
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
                style: TextStyle(
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
