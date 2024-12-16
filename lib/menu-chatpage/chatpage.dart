import 'package:babysitter/menu-chatpage/babysitterchat.dart';
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

class NannyChatListPage extends StatefulWidget {
  @override
  _NannyChatListPageState createState() => _NannyChatListPageState();
}

class _NannyChatListPageState extends State<NannyChatListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String nannyId = FirebaseAuth
      .instance.currentUser!.uid; // Assuming current user is the nanny

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('user1',
                isEqualTo: nannyId) // Filter chats where the nanny is user1
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.blackColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No chats available.',
                style: TextStyle(color: AppColors.grayColor),
              ),
            );
          }

          var chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              String chatId = chatDoc.id;
              String parentId = chatDoc['user2']; // user2 is the parentId

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('parents').doc(parentId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${userSnapshot.error}',
                        style: const TextStyle(color: AppColors.blackColor),
                      ),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  var parentName =
                      userSnapshot.data!['name'] ?? 'Unknown Parent';

                  return ListTile(
                    title: Text(
                      parentName,
                      style: const TextStyle(color: AppColors.blackColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterChatPage(
                            chatId: chatId,
                            nannyName:
                                parentName, // You can retrieve dynamically if needed
                            userId: nannyId,
                            nannyId: nannyId,
                            babysitterName: parentName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
