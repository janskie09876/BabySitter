import 'package:babysitter/login-bookingrequestpage/book_now.dart';
import 'package:babysitter/login-bookingrequestpage/confirm_booking.dart';

import 'package:flutter/material.dart';

class ChildrenInput extends StatefulWidget {
  @override
  _ChildrenInputState createState() => _ChildrenInputState();
}

class _ChildrenInputState extends State<ChildrenInput> {
  List<Map<String, String>> childrenData = [
    {'name': '', 'address': '', 'notes': ''},
  ];

  get nanny => null;

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookNow(nanny: nanny)),
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
                "Child Profile",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE3838E),
                  fontFamily: 'Baloo', // Apply Baloo font
                ),
              ),
              const SizedBox(height: 20),

              // Loop through each child data
              ...childrenData.map((child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE3838E),
                        fontFamily: 'Baloo', // Apply Baloo font
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter child\'s name',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily:
                                  'Baloo'), // Apply Baloo font to hint text
                        ),
                        onChanged: (value) {
                          setState(() {
                            child['name'] = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add Another Child button with no functionality
                    GestureDetector(
                      onTap: () {
                        // No functionality here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A8F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Add Another Child",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE3838E),
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFE3838E),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        maxLines: 6,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter child\'s address',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily:
                                  'Baloo'), // Apply Baloo font to hint text
                        ),
                        onChanged: (value) {
                          setState(() {
                            child['address'] = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Add Direction button with no functionality
                    GestureDetector(
                      onTap: () {
                        // No functionality here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A8F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Add Direction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE3838E),
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          color: Color(0xFFE3838E),
                          size: 20,
                        ), // Edit icon next to the label
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        maxLines: 6,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Add any additional notes here',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily:
                                  'Baloo'), // Apply Baloo font to hint text
                        ),
                        onChanged: (value) {
                          setState(() {
                            child['notes'] = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Implement X button functionality here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "X",
                          style: TextStyle(
                            color: Color(0xFFE3838E),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmBooking()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A8F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo', // Apply Baloo font
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
