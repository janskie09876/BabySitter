import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BabysitterChatPage extends StatefulWidget {
  final String chatId;
  final String nannyName;
  final String userId;
  final String nannyId;

  const BabysitterChatPage({
    Key? key,
    required this.chatId,
    required this.nannyName,
    required this.userId,
    required this.nannyId,
  }) : super(key: key);

  @override
  _BabysitterChatPageState createState() => _BabysitterChatPageState();
}

class _BabysitterChatPageState extends State<BabysitterChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // Send a message to the chat
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .collection('messages')
            .add({
          'senderId': widget.userId,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _messageController.clear();
        });
      } catch (e) {
        // Handle any errors while sending the message
        print("Error sending message: $e");
      }
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final senderId = message['senderId'] ?? "Unknown";
                    final messageText =
                        message['message'] ?? "No message content";
                    final timestamp =
                        message['timestamp']?.toDate() ?? DateTime.now();

                    return ListTile(
                      title: Text(senderId),
                      subtitle: Text(messageText),
                      trailing: Text("${timestamp.hour}:${timestamp.minute}"),
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
                      border: OutlineInputBorder(),
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
