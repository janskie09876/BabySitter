import 'package:babysitter/menu-chatpage/chat.dart';
import 'package:flutter/material.dart';

class BabysitterDetailPage extends StatelessWidget {
  final String babysitterName;
  final String distance;

  BabysitterDetailPage({required this.babysitterName, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: Text(
          babysitterName,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              babysitterName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Distance: $distance',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Rating: ★★★★☆', // Example rating
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Experienced babysitter with a friendly demeanor, available for part-time babysitting jobs in your area.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.pink.shade100,
                  ),
                  onPressed: () {
                    // Implement booking functionality here
                  },
                  icon: Icon(Icons.book_online),
                  label: Text("Book Now"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.pink.shade100,
                  ),
                  onPressed: () {
                    // Navigate to the ChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  icon: Icon(Icons.chat),
                  label: Text("Chat"),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.pink,
        child: IconButton(
          icon: Icon(Icons.public, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.pink.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, size: 30),
                onPressed: () {
                  // Navigate to the Chat Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.notifications_none, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
