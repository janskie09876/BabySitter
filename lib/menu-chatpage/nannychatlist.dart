import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BabyChatPage extends StatefulWidget {
  final String chatId;
  final String nannyName;
  final String userId;
  final String nannyId;
  final String babysitterName;

  const BabyChatPage({
    Key? key,
    required this.chatId,
    required this.nannyName,
    required this.userId,
    required this.nannyId,
    required this.babysitterName,
  }) : super(key: key);

  @override
  _BabyChatPageState createState() => _BabyChatPageState();
}

class _BabyChatPageState extends State<BabyChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // Send message to Firestore
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final String message = _messageController.text;

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': widget.userId,
        'receiverId': widget.nannyId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear(); // Clear the message input field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.nannyName}'),
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Show the most recent messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final senderId = messageData['senderId'];
                    final message = messageData['message'];

                    return ListTile(
                      title: Text(senderId == widget.userId
                          ? 'You: $message'
                          : '${widget.nannyName}: $message'),
                    );
                  },
                );
              },
            ),
          ),

          // Message input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
