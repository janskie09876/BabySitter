import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  /// Fetch the current user's booking document
  Future<void> _fetchCurrentUserBooking() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        print('User is not logged in.');
        return;
      }

      // Query the bookings collection where user1 matches the current user
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user1', isEqualTo: currentUserId)
          .limit(1)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        final bookingDoc = bookingSnapshot.docs.first;
        print(
            'Booking document data: ${bookingDoc.data()}'); // Log document data
        bookingId = bookingDoc.id;
        babysitterId = bookingDoc.data()?['user2']; // Babysitter's ID

        if (babysitterId != null) {
          // Fetch babysitter's name from the babysitters collection
          final babysitterDoc = await FirebaseFirestore.instance
              .collection('babysitters')
              .doc(babysitterId)
              .get();

          if (babysitterDoc.exists) {
            setState(() {
              nannyName = babysitterDoc.data()?['name'] ?? 'Unknown';
              parentName = 'You'; // Current user's name (static for now)
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
      // Add the rating to the ratings collection
      await FirebaseFirestore.instance.collection('ratings').add(ratingData);

      // Update babysitter's ratings in the babysitters collection
      final babysitterRef = FirebaseFirestore.instance
          .collection('babysitters')
          .doc(babysitterId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final babysitterDoc = await transaction.get(babysitterRef);

        if (babysitterDoc.exists) {
          // Update the babysitter's average rating
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
          // If babysitter document doesn't exist, initialize it
          transaction.set(babysitterRef, {
            'averageRating': _rating.toDouble(),
            'ratingCount': 1,
          });
        }
      });

      print('Rating submitted successfully!');
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Rate Your Babysitter"),
        backgroundColor: Colors.pink[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
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
                  backgroundImage: AssetImage('assets/images/jamesboy.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nannyName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Reviews are public and include your account and device info.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
                    color: Colors.pink[300],
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
                backgroundColor: Colors.red[300],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit Rating',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
