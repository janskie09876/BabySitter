import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/login-bookingrequestpage/book_now.dart';
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewBabysitter extends StatefulWidget {
  final Nanny? nanny; // Use the Nanny class from nannylist.dart

  const ViewBabysitter({Key? key, required this.nanny, required String nannyId})
      : super(key: key);

  @override
  _ViewBabysitterState createState() => _ViewBabysitterState();
}

class _ViewBabysitterState extends State<ViewBabysitter> {
  bool isError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (widget.nanny == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Nanny Selected")),
        body: const Center(child: Text("Nanny data is not available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nanny!.name}\'s Profile'),
        backgroundColor: const Color(0xFFE3838E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/liza.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nanny!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Baloo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < widget.nanny!.rating.toInt()
                                ? Colors.amber
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.nanny!.isAvailable
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.nanny!.isAvailable
                              ? 'Available'
                              : 'Not Available',
                          style: TextStyle(
                            color: widget.nanny!.isAvailable
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Personal Information
            Text(
              'Personal Information:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 8),
            Text('Age: ${widget.nanny?.age}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Date of Birth: ${widget.nanny?.birthDate}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Location: ${widget.nanny?.location}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone Number: ${widget.nanny?.phoneNumber}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),

            const SizedBox(height: 20),

            // Availability Section
            Text(
              'Availability:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.nanny!.availability,
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),

            const SizedBox(height: 20),

            // Action Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final String currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;
                    final String nannyId = widget
                        .nanny!.id; // Ensure `widget.nanny` is passed correctly
                    final String nannyName = widget.nanny!
                        .name; // Ensure `widget.nanny.name` is passed correctly

                    // Create a unique chatId by combining nannyId and parentId (currentUserId)
                    String chatId = (currentUserId.hashCode <= nannyId.hashCode)
                        ? '$currentUserId-$nannyId'
                        : '$nannyId-$currentUserId';

                    // Query Firestore to check if the chat already exists
                    final chatSnapshot = await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .get();

                    if (chatSnapshot.exists) {
                      // Chat already exists, navigate to the chat page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterChatPage(
                            chatId: chatId,
                            nannyName: nannyName,
                            userId: currentUserId,
                            nannyId: nannyId,
                            babysitterName: '',
                          ),
                        ),
                      );
                    } else {
                      // Chat doesn't exist, create a new chat
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .set({
                        'createdAt': FieldValue.serverTimestamp(),
                        'user1': nannyId,
                        'user2': currentUserId,
                      });

                      // Send the initial message from the parent (current user)
                      final String initialMessage =
                          'Hello, I would like to know more about your services.';
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .add({
                        'senderId': currentUserId,
                        'receiverId': nannyId,
                        'message': initialMessage,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      // Send the initial message from the nanny (as a reply)
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .add({
                        'senderId': nannyId,
                        'receiverId': currentUserId,
                        'message': initialMessage,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      // Navigate to the chat page after creating the message
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterChatPage(
                            chatId: chatId,
                            nannyName: nannyName,
                            userId: currentUserId,
                            nannyId: nannyId,
                            babysitterName: '',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Contact Nanny'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to BookNow and pass the nanny data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookNow(
                          nannyId: widget.nanny!.id, // Pass the actual nannyId
                        ),
                      ),
                    );
                  },
                  child: const Text('Book Babysitter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3838E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
