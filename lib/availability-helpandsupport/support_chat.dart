import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class SupportChatPage extends StatelessWidget {
  const SupportChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Support Chat'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppStyles.textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages container
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // User message
                MessageBubble(
                  text: "I am having trouble with uploading the required files",
                  color:
                      AppStyles.secondaryColor, // Updated to use secondaryColor
                  isUser: true,
                ),
                SizedBox(height: 20),
                // Support message
                MessageBubble(
                  text:
                      "We are sorry for the inconvenience. To fix your problem, here are some steps you can do:",
                  color: Colors.grey[800],
                  isUser: false,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Message input area
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.pink,
                    size: 30,
                  ),
                  onPressed: () {
                    // Handle send message action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.text,
    required this.color,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Text(
                'John will be serving you today',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(
                color: isUser
                    ? Colors.white
                    : AppStyles
                        .whiteColor, // Set support team message text color to white
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
