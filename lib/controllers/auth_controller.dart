import 'package:dars_50/models/error.dart';
import 'package:dars_50/services/auth_services.dart';
import 'package:flutter/cupertino.dart';

class AuthController extends ChangeNotifier{
  final _authServices = AuthServices();

  Future<ErrorType?> createUser(String email,String password) async{
    final response = await _authServices.createUser(email, password);
    return response;
  }

  Future<ErrorType> inUser(String email,String password) async{
    final response = await _authServices.inUser(email, password);
    return response!;
  }

}