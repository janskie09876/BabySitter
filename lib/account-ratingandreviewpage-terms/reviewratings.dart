import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final String nannyName; // Pass the nannyName to filter reviews

  const ReviewPage({Key? key, required this.nannyName}) : super(key: key);

  // Fetch reviews dynamically based on the nannyName
  Stream<QuerySnapshot> fetchReviews() {
    return FirebaseFirestore.instance
        .collection('ratings')
        .where('nannyName', isEqualTo: nannyName) // Filter by nanny name
        .orderBy('timestamp', descending: true) // Sort by latest reviews
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Ratings'),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.pink.shade50,
        child: StreamBuilder<QuerySnapshot>(
          stream: fetchReviews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No reviews available.'));
            }

            final reviews = snapshot.data!.docs;

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewItem(
                  parentName: review['parentName'],
                  rating: review['rating'],
                  feedback: review['feedback'],
                  timestamp: (review['timestamp'] as Timestamp).toDate(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String parentName;
  final int rating;
  final String feedback;
  final DateTime timestamp;

  const ReviewItem({
    Key? key,
    required this.parentName,
    required this.rating,
    required this.feedback,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/ajimboy.jpeg'), // Static avatar
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < rating ? Colors.pink : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              feedback,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'Reviewed on ${timestamp.toLocal()}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
