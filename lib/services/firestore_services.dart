import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_50/models/chat.dart';
import 'package:dars_50/models/message.dart';
import 'package:dars_50/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreServices{
  final _fireStoreConnect = FirebaseFirestore.instance.collection("users");
  final _chatRooms = FirebaseFirestore.instance.collection("chatrooms");

  Future<void> writeUser(User user) async{
    final response = await _fireStoreConnect.add(user.toJson());

    _fireStoreConnect.doc(response.id).update({
      "globalId":response.id
    });
  }

  Stream<QuerySnapshot> getusers() async*{
    yield* _fireStoreConnect.snapshots();
  }

  Stream<QuerySnapshot> getMyChats() async*{
    yield* _chatRooms.snapshots();
  }

  Future<List<User>> getAllUsers() async{
    final response = await _fireStoreConnect.get();
    return [for(int i = 0;i < response.docs.length;i++) User.fromJson(response.docs[i])];
  }

  Future<void> writeMessage(String message, String chatId, String globalKey) async {
    List<Map<String, dynamic>> messages = [];
    final data = await _chatRooms.doc(chatId).get();
    if (data.exists) {
      Map<String, dynamic> mp = data.data() as Map<String, dynamic>;
      if (mp.containsKey('messages')) {
        messages = List<Map<String, dynamic>>.from(mp['messages']);
      }
    }
    messages.add(
        {
          "date": DateTime.now().toIso8601String(),
          "message": message,
          "sendUser": globalKey
        }
    );
    await _chatRooms.doc(chatId).update({
      "messages": messages
    });
  }

}