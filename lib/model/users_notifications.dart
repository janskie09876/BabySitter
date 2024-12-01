import 'package:cloud_firestore/cloud_firestore.dart';

class UsersNotifications {
  final docUsersNotifications =
      FirebaseFirestore.instance.collection('users_notifications').doc();
  final String userId;
  final String message;
  final String route;
  final DateTime timestamp;

  UsersNotifications(
      {required this.userId,
      required this.message,
      required this.route,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'message': message,
        'route': route,
        'timestamp': timestamp,
      };

  Future<void> createNotification() async {
    final json = toJson();
    await docUsersNotifications.set(json);
  }
}
