import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDialog extends StatelessWidget {
  final String
      babysitterId; // You will pass the babysitter ID from the map click

  const ProfileDialog({super.key, required this.babysitterId});

  @override
  Widget build(BuildContext context) {
    // Fetch babysitter data from Firestore
    CollectionReference babysitters =
        FirebaseFirestore.instance.collection('babysitters');

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: FutureBuilder<DocumentSnapshot>(
        future: babysitters.doc(babysitterId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Babysitter not found'));
          }

          var babysitterData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(babysitterData['profileImage'] ??
                    'assets/images/default.jpg'), // Use the profile image URL from Firestore
              ),
              const SizedBox(height: 10),
              Text(
                babysitterData['name'] ?? 'John Doe',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                babysitterData['email'] ?? 'email@example.com',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                babysitterData['rating'].toString() ?? '4.5',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    babysitterData['location'] ?? 'Unknown location',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add action for the full profile view here
                },
                child: const Text('VIEW FULL PROFILE'),
              ),
            ],
          );
        },
      ),
    );
  }
}
