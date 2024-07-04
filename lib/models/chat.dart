import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatId;
  List<String> users;
  List<Map<String, dynamic>> messages;

  Chat({
    required this.chatId,
    required this.users,
    required this.messages,
  });

  factory Chat.fromJson(QueryDocumentSnapshot query) {
    return Chat(
      chatId: query['chatId'],
      users: query['users'].cast<String>(),
      messages: query['messages'].cast<Map<String,dynamic>>(),
    );
  }
}
