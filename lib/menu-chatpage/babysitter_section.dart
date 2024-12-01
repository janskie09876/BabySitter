import 'package:babysitter/menu-chatpage/BabysitterDetailPage.dart';
import 'package:flutter/material.dart';

import 'babysitter_list_page.dart';

class BabysitterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Babysitter Near You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BabysitterListPage()),
                );
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 12),
        BabysitterCard(),
      ],
    );
  }
}

class BabysitterCard extends StatelessWidget {
  final String babysitterName = "Jennifer Lawrence"; // Example data
  final String distance = "5 km | 1 hr"; // Example data

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 32, backgroundImage: AssetImage('6.jpg')),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  babysitterName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(distance),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Experienced and dedicated babysitter with over five years of child care experience.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to BabysitterDetailPage with relevant data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BabysitterDetailPage(
                          babysitterName: babysitterName,
                          distance: distance,
                        ),
                      ),
                    );
                  },
                  child: Text('Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
