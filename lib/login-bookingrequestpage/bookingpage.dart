import 'package:babysitter/search-bookingconfirmationpage/bookingconfirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String selectedBabysitter = 'Select a Babysitter';
  String address = '';
  final List<String> babysitters = [
    'Jona Di Magiba',
    'Maria Cruz',
    'Anna Smith',
  ];

  String selectedPaymentMode = 'Cash'; // Default to 'Cash'
  final List<String> paymentModes = ['Cash', 'GCash'];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationPage(
          babysitterName: selectedBabysitter,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          address: address,
          totalAmount: 55.0, // Dummy data, can be dynamic
          // Pass payment mode
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text(
          'Booking',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Baloo'), // Apply Baloo font
        ),
        centerTitle: true,
      ),
      // Automatically adjust UI for keyboard
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              title: 'Start Date',
              controller: _startDateController,
              onTap: () => _selectDate(context, _startDateController),
            ),
            _buildInputField(
              title: 'End Date',
              controller: _endDateController,
              onTap: () => _selectDate(context, _endDateController),
            ),
            const SizedBox(height: 16),
            const Text(
              'Babysitter',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Baloo'), // Apply Baloo font
            ),
            DropdownButton<String>(
              value: selectedBabysitter != 'Select a Babysitter'
                  ? selectedBabysitter
                  : null,
              hint: const Text('Select a Babysitter',
                  style: TextStyle(fontFamily: 'Baloo')), // Apply Baloo font
              isExpanded: true,
              items: babysitters
                  .map(
                    (sitter) => DropdownMenuItem(
                      value: sitter,
                      child: Text(sitter,
                          style: TextStyle(
                              fontFamily: 'Baloo')), // Apply Baloo font
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBabysitter = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Address',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Baloo'), // Apply Baloo font
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Address',
                hintStyle: TextStyle(fontFamily: 'Baloo'), // Apply Baloo font
              ),
              onChanged: (value) => address = value,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                onPressed: _navigateToConfirmation,
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontFamily: 'Baloo'), // Apply Baloo font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Baloo')), // Apply Baloo font
          TextField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: 'Select $title',
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }
}
