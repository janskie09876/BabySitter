import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        backgroundColor:
            AppColors.primaryColor, // Use primaryColor from AppColors
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
                                ? AppColors
                                    .primaryColor // Light shade of primaryColor for sent messages
                                : AppColors
                                    .beige, // Light background for received messages
                            borderRadius: BorderRadius.circular(
                                16), // More rounded corners
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSentByCurrentUser
                                  ? AppColors.whiteColor
                                  : AppColors
                                      .blackColor, // Text color for sent and received messages
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
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                AppColors.grayColor, // Gray color for timestamp
                          ),
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
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      labelStyle: TextStyle(
                          color: AppColors.grayColor), // Gray for label
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                        borderSide: BorderSide(
                            color: AppColors
                                .primaryColor), // Primary color for border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                        borderSide: BorderSide(
                            color: AppColors
                                .primaryColor), // Primary color for focused border
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: AppColors
                        .primaryColor, // Icon color set to primaryColor
                  ),
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
