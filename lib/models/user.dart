import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  String globalId;
  String name;
  String email;
  List<String> chats;

  User({
    required this.globalId,
    required this.name,
    required this.email,
    required this.chats,
  });

  factory User.fromJson(QueryDocumentSnapshot query) {
    return User(
      globalId: query.id,
      name: query['name'],
      email: query['email'],
      chats: query['chats'].cast<String>(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "globalId":globalId,
      "name":name,
      "email": email,
      "chats": chats
    };
  }


}
