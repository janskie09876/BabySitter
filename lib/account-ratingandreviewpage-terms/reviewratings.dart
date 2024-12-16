import 'package:cloud_firestore/cloud_firestore.dart';
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

class ReviewPage extends StatelessWidget {
  final String nannyName;

  const ReviewPage({Key? key, required this.nannyName}) : super(key: key);

  // Fetch average rating and review count
  Future<Map<String, dynamic>> fetchSummary() async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('nannyName', isEqualTo: nannyName)
        .get();

    if (ratingsSnapshot.docs.isEmpty) {
      return {'averageRating': 0.0, 'reviewCount': 0};
    }

    final ratings =
        ratingsSnapshot.docs.map((doc) => doc['rating'] as int).toList();
    final totalRatings = ratings.length;
    final averageRating = ratings.reduce((a, b) => a + b) / totalRatings;

    return {'averageRating': averageRating, 'reviewCount': totalRatings};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Ratings',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.lightBackground,
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchSummary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final summary =
                snapshot.data ?? {'averageRating': 0.0, 'reviewCount': 0};
            final averageRating = summary['averageRating'] as double;
            final reviewCount = summary['reviewCount'] as int;

            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 208, 148, 96),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Average Rating: ${averageRating.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$reviewCount Ratings',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        if (index < averageRating.floor()) {
                          // Fully filled stars
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 28,
                          );
                        } else if (index == averageRating.floor() &&
                            averageRating % 1 != 0) {
                          // Half-filled star
                          return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 28,
                          );
                        } else {
                          // Empty stars
                          return const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
