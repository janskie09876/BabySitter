import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: AppStyles.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppStyles.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontFamily: 'Baloo', // Used for headings and titles
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppStyles.secondaryColor,
                  ),
                  textAlign: TextAlign.center, // Centering the text
                ),
              ],
            ),
            SizedBox(height: 20),
            // FAQ Card - Application and Requirements
            Container(
              padding: AppStyles.defaultPadding,
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Application and Requirements",
                    style: TextStyle(
                      fontFamily: 'Baloo', // Used for headings and titles
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textColor,
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
              padding: AppStyles.defaultPadding,
              decoration: AppStyles.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Parents",
                    style: TextStyle(
                      fontFamily: 'Baloo', // Used for headings and titles
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textColor,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontFamily: 'Baloo', // Used for headings and titles
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontFamily: 'Balsamiq Sans', // Used for body and subtitles
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
