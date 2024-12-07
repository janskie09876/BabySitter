import 'package:babysitter/home-paymentpage/nannylist.dart'; // Import only nannylist.dart
import 'package:babysitter/login-bookingrequestpage/book_now.dart'; // Keep this import for BookNow
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewBabysitter extends StatelessWidget {
  final Nanny? nanny; // Use the Nanny class from nannylist.dart

  const ViewBabysitter({Key? key, required this.nanny, required String nannyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (nanny == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Nanny Selected")),
        body: const Center(child: Text("Nanny data is not available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${nanny!.name}\'s Profile'),
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
                        nanny!.name,
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
                            color: index < nanny!.rating.toInt()
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
                          color: nanny!.isAvailable
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          nanny!.isAvailable ? 'Available' : 'Not Available',
                          style: TextStyle(
                            color:
                                nanny!.isAvailable ? Colors.green : Colors.grey,
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
            Text('Age: ${nanny?.age}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Date of Birth: ${nanny?.birthDate}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Location: ${nanny?.location}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone Number: ${nanny?.phoneNumber}',
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
            Text(nanny!.availability,
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),

            const SizedBox(height: 20),

            // Action Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final String currentUserId =
                        'loggedInUserId'; // Replace with the actual logged-in user ID
                    final String nannyId =
                        nanny!.id; // Replace with the nanny's user ID
                    final String chatId =
                        '${currentUserId}_${nannyId}'; // Generate a unique chat ID

                    // Check if the chat already exists
                    final chatDoc = await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .get();

                    if (!chatDoc.exists) {
                      // Create a new chat document if it doesn't exist
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .set({
                        'babysitterId': currentUserId,
                        'nannyId': nannyId,
                      });

                      // Create a messages subcollection for this chat
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .add({
                        'senderId': currentUserId,
                        'message':
                            'Hello, I would like to know more about your services.',
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }

                    // Navigate to the chat page after creating the chat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NannyChatPage(
                          chatId: chatId, // Pass the unique chatId
                          nannyName: nanny!.name,
                          userId: currentUserId,
                          nannyId: nannyId,
                        ),
                      ),
                    );
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
                          nanny: nanny,
                          nannyId: '',
                        ), // This will work now because it's the same Nanny class
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
