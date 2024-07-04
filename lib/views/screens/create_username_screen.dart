import 'package:dars_50/controllers/firestore_controller.dart';
import 'package:dars_50/models/user.dart';
import 'package:dars_50/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUsernameScreen extends StatefulWidget {
  const CreateUsernameScreen({super.key});

  @override
  State<CreateUsernameScreen> createState() => _CreateUsernameScreenState();
}

class _CreateUsernameScreenState extends State<CreateUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final fireStroreControler = Provider.of<FirestoreController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create user name"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos username qaytadan kiriting";
                  }

                  return null;
                },
                controller: userName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: "Username"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () async{
                if(_formKey.currentState!.validate()){
                  setState(() {
                    isLoading = true;
                  });
                  final pref = await SharedPreferences.getInstance();
                  final email = await pref.getString("email");
                  await fireStroreControler.writeUser(User(globalId: '', name: userName.text,email: email.toString(), chats: [],),);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              },
              icon: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: isLoading ? CircularProgressIndicator(color: Colors.red,) : Text(
                  "Create Accaunt",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
