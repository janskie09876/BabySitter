import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ParentChatListPage extends StatefulWidget {
  @override
  _ParentChatListPageState createState() => _ParentChatListPageState();
}

class _ParentChatListPageState extends State<ParentChatListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String parentId = FirebaseAuth
      .instance.currentUser!.uid; // Assuming current user is the parent

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
            .where('user2',
                isEqualTo: parentId) // Filter chats where the parent is user2
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
              String nannyId = chatDoc['user1']; // user1 is the nannyId

              print("Chat ID: $chatId, Nanny ID: $nannyId");

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('babysitters').doc(nannyId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    print("No user data found for nannyId: $nannyId");
                    return const SizedBox();
                  }

                  var nannyName = userSnapshot.data!['name'] ?? 'Unknown Nanny';

                  print("Nanny Name: $nannyName");

                  return ListTile(
                    title: Text(nannyName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabysitterChatPage(
                            chatId: chatId,
                            nannyName: nannyName,
                            userId: parentId,
                            nannyId: nannyId,
                            babysitterName: nannyName,
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
