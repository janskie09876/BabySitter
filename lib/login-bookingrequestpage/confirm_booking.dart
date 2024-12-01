import 'package:babysitter/home-paymentpage/payment_methods_page.dart';
import 'package:babysitter/login-bookingrequestpage/child_profile.dart';
import 'package:flutter/material.dart';

class ConfirmBooking extends StatefulWidget {
  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  // Function to show dialog with date and time details
  void _showDateTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Date & Time",
                    style: TextStyle(
                      color: Color(0xFFE3838E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Baloo', // Apply Baloo font
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Booking from: 15 November to 16 November",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Balsamiq Sans', // Apply Balsamiq Sans font
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Time: 07:00 AM to 12:00 PM",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Balsamiq Sans', // Apply Balsamiq Sans font
                  ),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3838E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Close",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDEDE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDEDE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE3838E)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildrenInput()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Confirm Booking",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE3838E),
                  fontFamily: 'Baloo', // Apply Baloo font to heading
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Rhea Hernando", // Name of the person
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily:
                      'Balsamiq Sans', // Apply Balsamiq Sans font to subtitle
                ),
              ),
              const SizedBox(height: 20),

              // Button to show Date & Time Dialog
              GestureDetector(
                onTap: _showDateTimeDialog, // Show dialog when tapped
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Color(0xFFE3838E),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Date & Time",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE3838E),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Baloo', // Apply Baloo font to subtitle
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Babysitter Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Babysitter Info",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE3838E),
                        fontFamily:
                            'Baloo', // Apply Baloo font to section title
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Name: Van Ramley Castino",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily:
                            'Balsamiq Sans', // Apply Balsamiq Sans font to body
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Age: 29",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Poppins', // Apply Poppins font to numbers
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Address: Purok 1, Kawayanan Street, Panabo City, Davao Del Norte",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily:
                            'Balsamiq Sans', // Apply Balsamiq Sans font to body
                      ),
                    ),
                    SizedBox(height: 10),
                    // Babysitter Profile Picture
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage("assets/images/profile.jpg"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Proceed Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A8F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the payment methods screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentDetailsPage()),
                    );
                  },
                  child: const Text(
                    "Proceed to Pay",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Baloo', // Apply Baloo font to button text
                    ),
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
