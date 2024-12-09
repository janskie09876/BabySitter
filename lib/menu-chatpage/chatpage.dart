import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Chats'),
        backgroundColor: Colors.blue,
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          var chatDocs = snapshot.data!.docs;

          print("Chats found: ${chatDocs.length}");
          print("Chat data: ${chatDocs.map((e) => e.data()).toList()}");

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              String chatId = chatDoc.id;
              String parentId = chatDoc['user2']; // user2 is the parentId

              print("Chat ID: $chatId, Parent ID: $parentId");

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('parents').doc(parentId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    print("No user data found for parentId: $parentId");
                    return const SizedBox();
                  }

                  var parentName =
                      userSnapshot.data!['name'] ?? 'Unknown Parent';

                  print("Parent Name: $parentName");

                  return ListTile(
                    title: Text(parentName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterChatPage(
                            chatId: chatId,
                            nannyName:
                                'Nanny', // You can retrieve dynamically if needed
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
