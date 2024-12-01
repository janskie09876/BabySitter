import 'package:flutter/material.dart';

class ChatPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontFamily: 'Baloo', // Heading font
          ),
        ),
        backgroundColor: Colors.pink.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'No message yet.',
          style: TextStyle(
            fontFamily: 'Balsamiq Sans', // Body text font
            fontSize: 16.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action for adding a new chat
          _showAddChatDialog(context);
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New Chat',
            style: TextStyle(
              fontFamily: 'Baloo', // Title font
            ),
          ),
          content: const Text(
            'Implement functionality to add a new chat.',
            style: TextStyle(
              fontFamily: 'Balsamiq Sans', // Body text font
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Balsamiq Sans', // Subtitle font
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
