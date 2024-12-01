import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class GPay2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Methods",
          style: AppStyles.headingStyle.copyWith(
            color: AppStyles.textColor,
            fontFamily: 'Baloo', // Apply Baloo font to AppBar title
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyles.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyles.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "montalbaaj@gmail.com",
              style: AppStyles.bodyStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: 'Baloo', // Apply Baloo font
              ),
            ),
            const SizedBox(height: 20),
            // VISA Payment Method
            buildPaymentMethodRow(
              title: "Visa-8466",
              isSelected: true,
            ),
            const SizedBox(height: 20),
            // Globe Telecom
            buildPaymentMethodRow(
              title: "Globe Telecom +639757801757",
              isSelected: false,
              isUnavailable: true,
            ),
            const SizedBox(height: 20),
            // Add Payment Methods
            Text(
              "Add payment method to your Google Account",
              style: AppStyles.bodyStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: 'Baloo', // Apply Baloo font
              ),
            ),
            const SizedBox(height: 16),
            buildAddPaymentOption(
                Icons.sim_card, "Add Smart Communications billing"),
            const SizedBox(height: 10),
            buildAddPaymentOption(Icons.payments_outlined, "Add ShopeePay"),
            const SizedBox(height: 10),
            buildAddPaymentOption(Icons.account_balance_wallet, "Add GCash"),
            const SizedBox(height: 10),
            buildAddPaymentOption(
                Icons.credit_card, "Add credit or debit card"),
            const SizedBox(height: 10),
            buildAddPaymentOption(Icons.store, "Pay at convenience store"),
            const SizedBox(height: 10),
            buildAddPaymentOption(Icons.account_balance, "Add Maya"),
            const SizedBox(height: 10),
            buildAddPaymentOption(Icons.paypal, "Add PayPal"),
          ],
        ),
      ),
    );
  }

  // Helper method to build the payment methods UI
  Widget buildPaymentMethodRow({
    required String title,
    bool isSelected = false,
    bool isUnavailable = false,
  }) {
    return Row(
      children: [
        isSelected
            ? Icon(Icons.radio_button_checked, color: AppStyles.secondaryColor)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.bodyStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isUnavailable ? Colors.grey : AppStyles.textColor,
                  fontFamily: 'Baloo', // Apply Baloo font
                ),
              ),
              if (isUnavailable)
                Text(
                  "Unavailable",
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                    fontFamily: 'Baloo', // Apply Baloo font
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build add payment options
  Widget buildAddPaymentOption(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 24, color: AppStyles.secondaryColor),
        const SizedBox(width: 16),
        Text(
          label,
          style: AppStyles.bodyStyle.copyWith(
            fontFamily: 'Baloo', // Apply Baloo font
          ),
        ),
      ],
    );
  }
}
