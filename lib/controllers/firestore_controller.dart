import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_50/models/user.dart';
import 'package:dars_50/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';

class FirestoreController extends ChangeNotifier{
  final _firestoreServices = FirestoreServices();
  List<User> _users = [];

  Future<void> writeUser(User user) async{
    _firestoreServices.writeUser(user);
  }

  Stream<QuerySnapshot> get getUsers {
    return _firestoreServices.getusers();
  }

  void adduser(User user){
    bool isFind = false;
    for(int i = 0;i < _users.length;i++)
      if(_users[i].globalId == user.globalId)
        isFind = true;

    if(!isFind)
      _users.add(user);

  }

  List<User> get getUsersController {
    return [..._users];
  }

}