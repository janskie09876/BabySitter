import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NannyChatPage extends StatefulWidget {
  final String chatId;
  final String nannyName;
  final String userId;
  final String nannyId;
  final String babysitterName;

  const NannyChatPage({
    Key? key,
    required this.chatId,
    required this.nannyName,
    required this.userId,
    required this.nannyId,
    required this.babysitterName,
  }) : super(key: key);

  @override
  _NannyChatPageState createState() => _NannyChatPageState();
}

class _NannyChatPageState extends State<NannyChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // Method to send a new message
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId) // Use the provided chatId
            .collection('messages')
            .add({
          'senderId': widget.userId,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the text field after sending
        _messageController.clear();
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.babysitterName}'),
      ),
      body: Column(
        children: [
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
                  return const Center(child: Text('Error loading messages'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['senderId'] == widget.userId
                          ? 'You'
                          : widget.nannyName),
                      subtitle: Text(message['message']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
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
