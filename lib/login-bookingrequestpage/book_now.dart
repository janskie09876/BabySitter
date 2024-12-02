import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookNow extends StatefulWidget {
  final String nannyId; // Accept Firebase document ID of the nanny

  const BookNow({Key? key, required this.nannyId, required nanny})
      : super(key: key);

  @override
  _BookNowState createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay currentTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
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
    final bookingData = {
      'nannyId': widget.nannyId, // Use the Firebase `id` of the nanny
      'userName': nameController.text,
      'userPhone': phoneController.text,
      'message': messageController.text,
      'date': selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
          : '',
      'time': selectedTime != null ? selectedTime!.format(context) : '',
      'status': 'Pending', // Initially set the status as 'Pending'
    };

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      _showConfirmationDialog(context);
    } catch (e) {
      print('Error submitting booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book with Nanny'),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                onTap: () => _selectTime(context),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        selectedTime == null
                            ? 'Choose a time'
                            : selectedTime!.format(context),
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
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
