import 'package:babysitter/account-ratingandreviewpage-terms/review.dart';

import 'package:flutter/material.dart';

// First page: BabysitterRatingScreen
class BabysitterRatingScreen extends StatelessWidget {
  const BabysitterRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Babysitter's Rating"),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile image and name
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/joyce.jpeg'), // Replace with your image
            ),
            SizedBox(height: 10),
            Text(
              'Maricris Dela Cerna',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Overall rating
            Text(
              'Overall Rating',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            Text(
              '4.2',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                );
              }),
            ),
            SizedBox(height: 20),
            // Write a review
            Text(
              'Rate this sitter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Clickable star row for rating
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BabysitterRatingForm(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_border,
                    color: Colors.pink[200],
                    size: 30,
                  );
                }),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rating and reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward, // Right arrow icon
                  color: Colors.pink,
                ),
              ],
            ),

            // Review list
            Expanded(
              child: ListView(
                children: [
                  _buildReview('James Boy Boliwag', 4,
                      'Lorem ipsum dolor amet, consectetur adipiscing elit.'),
                  _buildReview('Jane Doe', 5,
                      'Very attentive and friendly with the kids!'),
                  _buildReview('John Smith', 3,
                      'Good overall, but could improve punctuality.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build individual reviews
  Widget _buildReview(String name, int rating, String review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
                'assets/images/jamesboy.png'), // Replace with your image
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                Text(
                  review,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
