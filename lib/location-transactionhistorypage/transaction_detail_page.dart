import 'package:flutter/material.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';

class TransactionDetailPage extends StatelessWidget {
  final Map<String, String> details;
  final IconData icon;

  const TransactionDetailPage(
      {required this.details, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            fontFamily: 'Baloo', // Apply Baloo font
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            AppStyles.primaryColor, // Use primaryColor from AppStyles
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: AppStyles.primaryColor, // Use primaryColor from AppStyles
        padding: AppStyles.defaultPadding, // Use defaultPadding from AppStyles
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add the icon above the card as the logo
              Center(
                child: CircleAvatar(
                  backgroundColor: AppStyles
                      .secondaryColor, // Use secondaryColor from AppStyles
                  radius: 40, // Adjust size of the icon
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40, // Adjust icon size
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between the logo and the card
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: AppStyles
                      .defaultPadding, // Use defaultPadding from AppStyles
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details.entries.map((entry) {
                      return Padding(
                        padding: AppStyles
                            .fieldPadding, // Use fieldPadding from AppStyles
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                fontFamily: 'Baloo', // Apply Baloo font
                                fontSize: 16,
                                color: const Color(
                                    0xFFEA7A6D), // Override color for label
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontFamily: 'Baloo', // Apply Baloo font
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
