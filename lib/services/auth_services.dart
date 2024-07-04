import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_50/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final _authGet = FirebaseAuth.instance;

  Future<ErrorType?> createUser(String email, String password) async {
    try {
      final response = await _authGet.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ErrorType(isError: false, status: 'null');
    } catch (e) {
      if (e.toString().contains("already")) {
        return ErrorType(isError: true, status: 'already');
      } else if (e.toString().contains("invalid")) {
        return ErrorType(isError: true, status: 'invalid');
      }
    }
  }


  Future<ErrorType?> inUser(String email, String password) async {
    try {
      final response = await _authGet.signInWithEmailAndPassword(
          email: email, password: password);
      return ErrorType(isError: false, status: 'null');
    } catch (e) {
      if (e.toString().contains("invalid")) {
        return ErrorType(isError: true, status: "invalid");
      } else if (e.toString().contains("already")) {
        return ErrorType(isError: true, status: 'already');
      }
    }
  }
}
