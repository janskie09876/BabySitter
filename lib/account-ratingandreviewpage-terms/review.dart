import 'package:babysitter/home-paymentpage/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color beige = Color(0xFFE3C3A3); // Beige for highlights
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black text
  static const Color grayColor = Color(0xFF7D7D7D); // Gray for secondary text
  static const Color whiteColor = Color(0xFFFFFFFF); // White
}

class BabysitterRatingForm extends StatefulWidget {
  const BabysitterRatingForm({Key? key}) : super(key: key);

  @override
  _BabysitterRatingFormState createState() => _BabysitterRatingFormState();
}

class _BabysitterRatingFormState extends State<BabysitterRatingForm> {
  int _rating = 0;
  String nannyName = "Loading...";
  String parentName = "Loading...";
  String? bookingId;
  String? babysitterId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserBooking();
  }

  Future<void> _fetchCurrentUserBooking() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        print('User is not logged in.');
        return;
      }

      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user1', isEqualTo: currentUserId)
          .limit(1)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        final bookingDoc = bookingSnapshot.docs.first;
        bookingId = bookingDoc.id;
        babysitterId = bookingDoc.data()?['user2'];

        if (babysitterId != null) {
          final babysitterDoc = await FirebaseFirestore.instance
              .collection('babysitters')
              .doc(babysitterId)
              .get();

          if (babysitterDoc.exists) {
            setState(() {
              nannyName = babysitterDoc.data()?['name'] ?? 'Unknown';
              parentName = 'You';
            });
          } else {
            setState(() {
              nannyName = 'Babysitter record not found';
            });
          }
        } else {
          setState(() {
            nannyName = 'Babysitter ID not found';
          });
        }
      } else {
        setState(() {
          nannyName = 'No booking found';
          parentName = 'No booking found';
        });
      }
    } catch (e) {
      print('Error fetching booking for current user: $e');
      setState(() {
        nannyName = 'Error loading name';
        parentName = 'Error loading name';
      });
    }
  }

  void _submitRating() async {
    if (_rating < 1 || _rating > 5) {
      print('Error: Rating must be between 1 and 5!');
      return;
    }

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null || bookingId == null || babysitterId == null) {
      print('Error: User, booking, or babysitter not found.');
      return;
    }

    final ratingData = {
      'nannyName': nannyName,
      'parentName': parentName,
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    };

    try {
      await FirebaseFirestore.instance.collection('ratings').add(ratingData);

      final babysitterRef = FirebaseFirestore.instance
          .collection('babysitters')
          .doc(babysitterId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final babysitterDoc = await transaction.get(babysitterRef);

        if (babysitterDoc.exists) {
          final currentRating = babysitterDoc.data()?['averageRating'] ?? 0.0;
          final ratingCount = babysitterDoc.data()?['ratingCount'] ?? 0;

          final newRatingCount = ratingCount + 1;
          final newAverageRating =
              ((currentRating * ratingCount) + _rating) / newRatingCount;

          transaction.update(babysitterRef, {
            'averageRating': newAverageRating,
            'ratingCount': newRatingCount,
          });
        } else {
          transaction.set(babysitterRef, {
            'averageRating': _rating.toDouble(),
            'ratingCount': 1,
          });
        }
      });

      print('Rating submitted successfully!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard()), // Redirect to Dashboard
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      print('Error submitting rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          "Rate Your Babysitter",
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.beige,
                  child: Icon(Icons.person, color: AppColors.blackColor),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nannyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const Text(
                      'Reviews are public and include your account and device info.',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.grayColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit Rating',
                style: TextStyle(fontSize: 18, color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
