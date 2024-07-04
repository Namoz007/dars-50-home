import 'package:dars_50/controllers/auth_controller.dart';
import 'package:dars_50/views/screens/create_username_screen.dart';
import 'package:dars_50/views/screens/home_screen.dart';
import 'package:dars_50/views/screens/login_screen.dart';
import 'package:dars_50/views/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final servicesController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final firstPassword = TextEditingController();
  final secondPassword = TextEditingController();
  bool isLoading = false;
  String? error;

  void analistData() async{
    if(_formKey.currentState!.validate()){
      if(firstPassword.text == secondPassword.text){
        error = null;
        setState(() {
          isLoading = true;
        });
        // await servicesController.writeStatistic(email.text);
        final data = await servicesController.createUser(email.text, firstPassword.text);
        if(data != null){
          setState(() {
            isLoading = false;
          });
          if(data.isError){
            setState(() {
              if(data.status == 'invalid')
                error = "${data.status} email or password";
              else
                error = "${data.status} email";
            });
          }else{
            setState(() {
              error = null;
            });
            final pref = await SharedPreferences.getInstance();
            pref.setString("email", email.text);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateUsernameScreen()));
          }
        }
      }else{
        setState(() {
          error = 'Parollar bir xil emas';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 150,),
                  Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.blueAccent),),
                  SizedBox(height: 50,),
                  error != null ? Container(
                    height: 40,
                    child: Text("$error",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                  ): SizedBox(),
                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return "Emai boshh bolmasligi kerak";

                      if(!value.contains("@")){
                        return "Emailda @ belgisi bolishi shart";

                        return null;
                      }
                    },
                    controller: email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Email"
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return "Parol boshh bolmasligi kerak";

                      if(value.length < 6){
                        return "Parl kamida 6 ta elementdan iborat bolishi kerak";
                      }
                      return null;
                    },
                    controller: firstPassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Password"
                    ),
                  ),
                  SizedBox(height: 20,),

                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return "Parol boshh bolmasligi kerak";

                      if(value.length < 7){
                        return "Parl kamida 6 ta elementdan iborat bolishi kerak";
                      }
                      return null;
                    },
                    controller: secondPassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Confirm password"
                    ),
                  ),
                  SizedBox(height: 20,),

                  !isLoading ? InkWell(
                    onTap: analistData,
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Text("R E G I S T E R",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),),
                    ),
                  ) : LoadingDialog(),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  } , child: Text("Tizimga kirish",style: TextStyle(fontSize: 16,color: Colors.blueAccent,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
