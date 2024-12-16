import 'package:babysitter/account-ratingandreviewpage-terms/reviewratings.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:babysitter/login-bookingrequestpage/book_now.dart';
import 'package:babysitter/menu-chatpage/babysitterchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysitter/home-paymentpage/nannycard.dart';

// Define AppColors class
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

int _calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;

  if (currentDate.month < birthDate.month ||
      (currentDate.month == birthDate.month &&
          currentDate.day < birthDate.day)) {
    age--;
  }
  return age;
}

DateTime _parseBirthDate(String birthDate) {
  try {
    if (birthDate.isEmpty) {
      return DateTime(1900, 1, 1); // Default fallback date for empty strings
    }
    final dateFormat = DateFormat('MMMM dd, yyyy'); // Expected format
    return dateFormat.parse(birthDate);
  } catch (e) {
    print('Error parsing birthDate: $e');
    return DateTime(1900, 1, 1); // Default fallback date for parsing errors
  }
}

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
        backgroundColor:
            AppColors.primaryColor, // Using AppColors for the AppBar
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Stars with fractional logic
                          Row(
                            children: List.generate(5, (index) {
                              final rating = widget.nanny!.rating;
                              if (index < rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else if (index == rating.floor() &&
                                  rating % 1 != 0) {
                                return const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else {
                                return const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }
                            }),
                          ),
                          const SizedBox(
                              width:
                                  8), // Spacing between stars and icon button
                          // Arrow Button
                          IconButton(
                            onPressed: () {
                              // Navigate to the ReviewPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                    nannyName: widget
                                        .nanny!.name, // Pass the necessary data
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: AppColors
                                  .primaryColor, // Use AppColors for consistent design
                              size: 20, // Adjust size if necessary
                            ),
                            tooltip:
                                'Babysitter Ratings & Reviews', // Tooltip for accessibility
                          ),
                        ],
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor, // Using AppColors for text color
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.nanny?.birthdate != null &&
                      widget.nanny!.birthdate!.isNotEmpty
                  ? 'Age: ${_calculateAge(_parseBirthDate(widget.nanny!.birthdate ?? ''))}'
                  : 'Age: Unknown', // Handle null or empty birthdate
              style: const TextStyle(fontSize: 16),
            ),
            Text('Date of Birth: ${widget.nanny?.birthdate}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Address: ${widget.nanny?.address}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone Number: ${widget.nanny?.phoneNumber}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // Availability Section
            Text(
              'Availability:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.nanny!.availability,
                style: const TextStyle(fontSize: 16)),

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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor, // Keep the primary color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded borders
                    ),
                  ),
                  child: const Text(
                    'Contact Nanny',
                    style: TextStyle(
                      color: AppColors.blackColor, // Set text color to black
                    ),
                  ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor, // Keep the primary color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book Babysitter',
                    style: TextStyle(
                      color: AppColors.blackColor, // Set text color to black
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
