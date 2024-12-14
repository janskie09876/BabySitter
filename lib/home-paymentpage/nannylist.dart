import 'package:babysitter/home-paymentpage/nannycard.dart';
import 'package:babysitter/requirement-babysitterprofilepage/view_babysitter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nanny {
  final String id; // Add id property
  final String name;
  final double rating; // Average rating
  final int ratingCount; // Total number of ratings
  final String availability;
  final String? birthdate;
  final int age;
  final String location;
  final String? phoneNumber;
  final bool isAvailable;
  final String role;
  final String gender; // New property for gender
  final String address; // New property for address
  final String service;

  Nanny({
    required this.id, // Ensure the id is passed in the constructor
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.availability,
    this.birthdate,
    required this.age,
    required this.location,
    this.phoneNumber,
    required this.isAvailable,
    required this.role,
    required this.gender, // Include gender in constructor
    required this.address,
    required this.service, // Include address in constructor
  });

  factory Nanny.fromMap(Map<String, dynamic> data) {
    return Nanny(
      id: data['id'] ?? '', // Use the Firestore document id here
      name: data['name'] ?? 'Unknown',
      rating: (data['averageRating'] ?? 0.0).toDouble(), // Fetch average rating
      ratingCount: data['ratingCount'] ?? 0, // Fetch total number of ratings
      availability: data['availability'] ?? 'Unavailable',
      birthdate: data['birthdate'],
      age: data['age'] ?? 0,
      location: data['location'] ?? 'Unknown',
      phoneNumber: data['phone'],
      isAvailable: data['isAvailable'] ?? false,
      role: data['role'] ?? 'Unknown',
      gender: data['gender'] ?? 'Not Specified', // Fetch gender from Firestore
      address: data['address'] ??
          'No Address Provided', // Fetch address from Firestore
      service: data['service'] ?? 'N/A',
    );
  }
}

class NannyList extends StatelessWidget {
  const NannyList({Key? key}) : super(key: key);

  Future<List<Nanny>> fetchNannies() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('babysitters').get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Nanny.fromMap({
              ...data,
              'id': doc.id, // Include Firestore document id
            });
          })
          .where((nanny) => nanny.role == 'Babysitter')
          .toList();
    } catch (e) {
      print('Error fetching nannies: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Nanny>>(
      future: fetchNannies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No babysitters available.'));
        }

        final nannies = snapshot.data!;
        return ListView.builder(
          itemCount: nannies.length,
          itemBuilder: (context, index) {
            return NannyCard(
              nanny: nannies[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBabysitter(
                      nanny: nannies[index],
                      nannyId: nannies[index].id, // Pass the nanny ID
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
