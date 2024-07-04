import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_50/models/chat.dart';
import 'package:dars_50/models/user.dart';
import 'package:dars_50/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends ChangeNotifier{
  final _fireStoreServices = FirestoreServices();
  List<Chat> _chats = [];
  List<User> _allUsers = [];

  Stream<QuerySnapshot> get getMyChats{
    getAllUsers();
    return _fireStoreServices.getMyChats();
  }

  void addChat(Chat chat){
    bool isFind = false;
    for(int i = 0;i < _chats.length;i++)
      if(_chats[i].chatId == chat.chatId)
        isFind = true;

    if(!isFind)
      _chats.add(chat);
  }

  List<Chat> get chats{
    return [..._chats];
  }

  void addUser(User user){
    _allUsers.add(user);
  }

  List<User> get allUsers {
    return [..._allUsers];
  }

  Future<User?> getMyUser(String email) async{
    final _users = await _fireStoreServices.getAllUsers();
    for(int i = 0;i < _users.length;i++){
      if(_users[i].email == email){
        return _users[i];
      }
    }
  }

  User getUserWithGlobalId(String email,List<String> globalId){
    for(int i = 0;i < _allUsers.length;i++){
      if(globalId.contains(_allUsers[i].globalId) && _allUsers[i].email != email){
        return _allUsers[i];
      }
    }
    return User(globalId: '', name: '', email: '', chats: []);
  }

  Future<List<User>> getAllUsers() async{
    final users  = await _fireStoreServices.getAllUsers();
    for(int i = 0;i < users.length;i++){
      bool isFind = false;
      for(int j = 0;j < _allUsers.length;j++){
        if(users[i].globalId == allUsers[j].globalId){
          isFind = true;
        }
      }
      if(!isFind){
        addUser(users[i]);
      }
    }
    return users;
  }

  Future<List<Chat>> getMyWriteChats() async{
    final pref = await SharedPreferences.getInstance();
    final globalId = await pref.getString("globalId");
    List<Chat> chats = [];
    for(int i = 0;i < _chats.length;i++){
      if(_chats[i].users.contains(globalId)){
        chats.add(_chats[i]);
      }
    }
    return chats;
  }

  Future<void> writeMessage(String message,String chatId,String globalKey) async{
    await _fireStoreServices.writeMessage(message, chatId, globalKey);
  }

}