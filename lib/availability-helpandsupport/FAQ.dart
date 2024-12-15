import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark background
  static const Color beige = Color(0xFFE3C3A3); // Beige
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black
  static const Color grayColor = Color(0xFF7D7D7D); // Gray
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFBC02D); // Yellow
  static const Color whiteColor = Color(0xFFFFFFFF); // White
  static const Color redColor = Color(0xFFFF0000); // Red
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: AppColors.lightBackground,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.blackColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Default padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive Title Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontSize: screenWidth > 600
                        ? 24
                        : 20, // Adjust font size based on screen width
                    fontWeight: FontWeight.bold,
                    color: AppColors.coffeeBrown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 20),
            // FAQ Card - Application and Requirements
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Application and Requirements",
                    style: TextStyle(
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Adjust font size for larger screens
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  FAQItem(
                    question: "Q: How do I apply?",
                    answer:
                        "A: You will need to complete the application process with all the requirements in the application form.",
                  ),
                  FAQItem(
                    question:
                        "Q: What is the application process like? Is there an application fee?",
                    answer:
                        "A: ToddCare requires personal information, including your full name, address, phone number, and a valid ID, along with your work experience and biography. The application is free of charge, provided all requirements are met and completed.",
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // FAQ Card - For Parents
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Parents",
                    style: TextStyle(
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Adjust font size for larger screens
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  FAQItem(
                    question:
                        "Q: How do I know if a babysitter is trustworthy?",
                    answer:
                        "A: All babysitters on ToddCare undergo a thorough screening process, including background checks, verification of credentials, and reviews from previous clients. You can also read ratings and testimonials from other parents.",
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

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: screenWidth > 600
                  ? 16
                  : 14, // Adjust font size for larger screens
              fontWeight: FontWeight.bold,
              color: AppColors.coffeeBrown,
            ),
          ),
          SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: screenWidth > 600
                  ? 14
                  : 12, // Adjust font size for larger screens
              color: AppColors.grayColor,
            ),
          ),
        ],
      ),
    );
  }
}
