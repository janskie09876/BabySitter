import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookNow extends StatefulWidget {
  final Nanny? nanny;
  final String nannyId;

  const BookNow({Key? key, required this.nannyId, this.nanny})
      : super(key: key);

  @override
  _BookNowState createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay currentTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: const Text('Wait for Babysitter\'s confirmation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitBooking() async {
    if (widget.nannyId.isEmpty) {
      print('Error: nannyId is empty!');
      return;
    }

    if (startTime == null || endTime == null || selectedDate == null) {
      print('Error: Missing date or time!');
      return;
    }

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the current user's name (parent's name)
    String currentUserName = 'Unknown';
    String nannyName = 'Unknown';

    try {
      // Fetch the parent's name
      final userDoc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(currentUserId)
          .get();
      if (userDoc.exists) {
        currentUserName = userDoc.data()?['name'] ?? 'Unknown';
      }

      // Fetch the nanny's name
      final nannyDoc = await FirebaseFirestore.instance
          .collection('babysitters')
          .doc(widget.nannyId)
          .get();
      if (nannyDoc.exists) {
        nannyName = nannyDoc.data()?['name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching names: $e');
    }

    final bookingData = {
      'createAt': FieldValue.serverTimestamp(),
      'user1': currentUserId, // Parent's ID
      'user2': widget.nannyId, // Babysitter's ID
      'user1Name': currentUserName, // Parent's name
      'user2Name': nannyName, // Babysitter's name
      'status': 'Pending', // Booking status
      'paymentStatus': 'Pending', // Initialize payment status
    };

    final bookingDetails = {
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'startTime': startTime!.format(context),
      'endTime': endTime!.format(context),
      'name': nameController.text,
      'phone': phoneController.text,
      'message': messageController.text,
      'receiverId': widget.nannyId, // Babysitter's ID
      'receiverName': nannyName, // Babysitter's name
      'senderId': currentUserId, // Parent's ID
      'senderName': currentUserName, // Parent's name
      'status': 'Pending',
    };

    try {
      // Create a new booking document in the 'bookings' collection
      var bookingRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add(bookingData);

      // Add booking details as a sub-collection
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingRef.id)
          .collection('booking')
          .add(bookingDetails);

      _showConfirmationDialog(context);
    } catch (e) {
      print('Error submitting booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book with ${widget.nanny?.name ?? 'Nanny'}'),
        backgroundColor: const Color(0xFFE3838E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message/Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        selectedDate == null
                            ? 'Choose a date'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        startTime == null
                            ? 'Choose start time'
                            : startTime!.format(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        endTime == null
                            ? 'Choose end time'
                            : endTime!.format(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitBooking,
                child: const Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3838E),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
