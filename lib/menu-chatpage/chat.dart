import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String nannyName;
  final String userId;
  final String nannyId;
  final String babysitterName;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.nannyName,
    required this.userId,
    required this.nannyId,
    required this.babysitterName,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

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
        print("Error sending message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.nannyName}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
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

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return ListTile(
                        title: Text(message['message']),
                        subtitle: Text('Sent by: ${message['senderId']}'),
                      );
                    },
                  );
                }

                return const Center(child: Text("No messages yet"));
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
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
