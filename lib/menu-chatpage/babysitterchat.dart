import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BabysitterChatPage extends StatefulWidget {
  final String chatId;
  final String nannyName;
  final String userId;
  final String nannyId;
  final String babysitterName;

  const BabysitterChatPage({
    Key? key,
    required this.chatId,
    required this.nannyName,
    required this.userId,
    required this.nannyId,
    required this.babysitterName,
  }) : super(key: key);

  @override
  _BabysitterChatPageState createState() => _BabysitterChatPageState();
}

class _BabysitterChatPageState extends State<BabysitterChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Send the message to Firestore
      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': _currentUserId,
        'receiverId': widget.nannyId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the message input field after sending
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.nannyName}'),
        backgroundColor: const Color(0xFFE3838E),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
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
                    final senderId = message['senderId'];
                    final messageText = message['message'];
                    final timestamp = message['timestamp'];

                    final isSentByCurrentUser = senderId == _currentUserId;

                    return ListTile(
                      title: Align(
                        alignment: isSentByCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isSentByCurrentUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSentByCurrentUser
                                  ? Colors.blue.shade900
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: isSentByCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          timestamp != null
                              ? timestamp.toDate().toLocal().toString()
                              : 'Loading...',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
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
                      labelText: 'Type a message',
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
