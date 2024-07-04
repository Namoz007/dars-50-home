import 'package:dars_50/controllers/auth_controller.dart';
import 'package:dars_50/controllers/chat_controller.dart';
import 'package:dars_50/main.dart';
import 'package:dars_50/views/screens/home_screen.dart';
import 'package:dars_50/views/screens/register_screen.dart';
import 'package:dars_50/views/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final servicesController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final login = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;
  String? error;

  void analistData() async{
    if (_formKey.currentState!.validate()) {
      error = null;
      setState(() {
        isLoading = true;
      });
      final data = await servicesController.inUser(login.text, password.text);
      isLoading = false;
      if(data != null){
        if(data.isError){
          if(data.status == 'invalid'){
            setState(() {
              error = "Invalid email or password";
            });
          }else if(data.status == 'already'){
            setState(() {
              error = "Email already exists";
            });
          }
        }else{
          error = null;
          final controller = ChatController();
          final user = await controller.getMyUser(login.text);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("email", user!.email);
          await prefs.setString("globalId", user!.globalId);
          await prefs.setString("name", user!.name);
        }
      }
    }
  }

  @override
  void dispose(){
    super.dispose();
    login.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  Text(
                    "L O G I N",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  isLoading ? LoadingDialog() : SizedBox(),

                  error != null ? Container(height: 50,child: Text("$error",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),) : SizedBox(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Login kiritish majburiy";
                      }

                      if (!value.contains("@")) {
                        return "Loginda @ belgisi bolishi shart";
                      }

                      return null;
                    },
                    controller: login,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Login"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Parol kiritish majburiy";
                      }

                      if (value.length < 7) {
                        return "Parol kamida 6 ta elementdan iborat bolishi kerak";
                      }

                      return null;
                    },
                    controller: password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Password"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: analistData,
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      child: Text(
                        "L O G I N",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen(),),);
                    },
                    child: Text(
                      "Ro'yxatdan o'tish",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
