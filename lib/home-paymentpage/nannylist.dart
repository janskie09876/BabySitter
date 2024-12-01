import 'package:babysitter/home-paymentpage/nannycard.dart';
import 'package:babysitter/requirement-babysitterprofilepage/view_babysitter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nanny {
  final String name;
  final double rating;
  final String availability;
  final String? birthDate; // Made nullable
  final int age;
  final String location;
  final String? phoneNumber; // Made nullable
  final bool isAvailable;
  final String role;

  Nanny({
    required this.name,
    required this.rating,
    required this.availability,
    this.birthDate,
    required this.age,
    required this.location,
    this.phoneNumber,
    required this.isAvailable,
    required this.role,
  });

  factory Nanny.fromMap(Map<String, dynamic> data) {
    return Nanny(
      name: data['name'] ?? 'Unknown',
      rating: (data['rating'] ?? 0).toDouble(),
      availability: data['availability'] ?? 'Unavailable',
      birthDate: data['birthDate'], // Nullable field
      age: data['age'] ?? 0,
      location: data['location'] ?? 'Unknown',
      phoneNumber: data['phoneNumber'], // Nullable field
      isAvailable: data['isAvailable'] ?? false,
      role: data['role'] ?? 'Unknown',
    );
  }
}

class NannyList extends StatelessWidget {
  const NannyList({Key? key}) : super(key: key);

  Future<List<Nanny>> fetchNannies() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      return snapshot.docs
          .map((doc) => Nanny.fromMap(doc.data() as Map<String, dynamic>))
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
                    builder: (context) => ViewBabysitter(nanny: nannies[index]),
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
