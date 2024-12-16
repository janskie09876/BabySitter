import 'package:babysitter/account-ratingandreviewpage-terms/accountpage.dart';
import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:babysitter/home-paymentpage/gpay2_page.dart';
import 'package:babysitter/menu-chatpage/chat_page.dart';
import 'package:babysitter/notifications-stylepage/notificationpage.dart';
import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class GPayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Google Pay',
          style: TextStyle(
            fontFamily: 'Baloo', // Apply Baloo font to AppBar title
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            AppStyles.primaryColor, // Use primary color from AppStyles
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              AppStyles.defaultPadding, // Use default padding from AppStyles
          child: Container(
            padding:
                AppStyles.defaultPadding, // Use default padding from AppStyles
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Pay with Google Pay',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Using Google Pay allows you to complete your payment securely and instantly. '
                  'Follow the steps below to pay using your GPay account:',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Steps to Pay:',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Ensure you have Google Pay installed and linked to a valid payment method.\n'
                  '2. Tap the "Proceed" button below.\n'
                  '3. You will be prompted to authenticate using your GPay account.\n'
                  '4. Once authenticated, your payment will be processed and confirmed instantly.\n'
                  '5. You’ll receive a receipt via email once your payment is successful.',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Note: Please make sure your GPay account has sufficient balance or is linked to a supported bank card.',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                    fontStyle: FontStyle.italic, // Italicize the note
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showPaymentDetails(context);
                    },
                    style: AppStyles
                        .primaryButtonStyle, // Use primary button style from AppStyles
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Apply Baloo font to button text
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.pink,
        child: IconButton(
          icon: const Icon(Icons.public, color: Colors.white),
          onPressed: () {
            // You can add an action here if needed
          },
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
                    MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(), // Navigate to Dashboard
                    ),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatPage1()), // Assuming you have a ChatPage1 class
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
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationPage()), // Assuming you have a NotificationPage class
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
                    MaterialPageRoute(
                      builder: (context) =>
                          BabysitterAccountPage(), // Navigate to AccountPage (self-link optional)
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to display payment details directly when "Proceed" is pressed
  void _showPaymentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              AppStyles.defaultPadding, // Use default padding from AppStyles
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay Service',
                          style: TextStyle(
                            fontFamily: 'Baloo', // Apply Baloo font
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₱410.00 + tax',
                          style: TextStyle(
                            fontFamily: 'Baloo', // Apply Baloo font
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Close the modal and return to Pay Service screen
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the current modal
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GPay2Page(), // Navigate to GPay2Page
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: AppStyles.secondaryColor),
                    SizedBox(width: 10),
                    Text(
                      'Visa - 8466',
                      style: TextStyle(
                        fontFamily: 'Baloo', // Apply Baloo font
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tap "Pay" to complete your purchase.',
                style: TextStyle(
                  fontFamily: 'Baloo', // Apply Baloo font
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the modal and process payment
                    // Process payment logic here
                  },
                  style: AppStyles
                      .primaryButtonStyle, // Use primary button style from AppStyles
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      fontFamily: 'Baloo', // Apply Baloo font
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show alternative payment options modal
  void _showAlternativePayments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              AppStyles.defaultPadding, // Use default padding from AppStyles
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Go back to the previous modal (Pay Service)
                    },
                  ),
                  Text(
                    'Choose Payment Option',
                    style: TextStyle(
                      fontFamily: 'Baloo', // Apply Baloo font
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40), // To balance the back button space
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Image.asset(
                  'images/paymaya.png', // Ensure this image exists in your assets
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  'Add PayMaya',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Add PayMaya as the selected payment method logic here
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/paypal.png', // Ensure this image exists in your assets
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  'Add PayPal',
                  style: TextStyle(
                    fontFamily: 'Baloo', // Apply Baloo font
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Add PayPal as the selected payment method logic here
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
