import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatefulWidget {
  final String babysitterId; // Babysitter document ID from Firestore

  const ProfileDialog({Key? key, required this.babysitterId}) : super(key: key);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  Map<String, dynamic>? nannyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBabysitterData();
  }

  Future<void> _fetchBabysitterData() async {
    try {
      // Fetch babysitter data from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('babysitters')
          .doc(widget.babysitterId)
          .get();

      if (snapshot.exists) {
        setState(() {
          nannyData = snapshot.data();
          isLoading = false;
        });
      } else {
        print('Babysitter not found');
        Navigator.of(context).pop(); // Close dialog if babysitter not found
      }
    } catch (e) {
      print('Error fetching babysitter data: $e');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: isLoading
          ? const Center(heightFactor: 5, child: CircularProgressIndicator())
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: nannyData?["profileImage"] != null
                  ? NetworkImage(nannyData!["profileImage"])
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 12),

            // Name
            Text(
              nannyData?["name"] ?? "No Name",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),

            const SizedBox(height: 8),
            // Rating and Availability Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(
                  ' ${nannyData?["rating"]?.toStringAsFixed(1) ?? "N/A"} '
                  '(${nannyData?["transactions"] ?? 0} reviews)',
                ),
                const SizedBox(width: 10),
                nannyData?["isAvailable"] == true
                    ? const Text('Available',
                        style: TextStyle(color: Colors.green))
                    : const Text('Not Available',
                        style: TextStyle(color: Colors.red)),
              ],
            ),

            const Divider(height: 24),

            // Other Info
            _buildInfoTile(
                "Location", nannyData?["location"] ?? "Not Specified"),
            _buildInfoTile("Contact", nannyData?["contact"] ?? "N/A"),
            _buildInfoTile("Age", nannyData?["age"]?.toString() ?? "N/A"),
            _buildInfoTile("Gender", nannyData?["gender"] ?? "N/A"),
            _buildInfoTile("Address", nannyData?["address"] ?? "Not Provided"),
            _buildInfoTile("Service", nannyData?["service"] ?? "N/A"),

            const Divider(height: 24),

            // Booking and Transaction Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatTile(
                    "Bookings", nannyData?["bookings"]?.toString() ?? "0"),
                _buildStatTile("Transactions",
                    nannyData?["transactions"]?.toString() ?? "0"),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
