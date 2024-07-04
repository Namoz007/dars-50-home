import 'package:dars_50/controllers/auth_controller.dart';
import 'package:dars_50/controllers/chat_controller.dart';
import 'package:dars_50/controllers/firestore_controller.dart';
import 'package:dars_50/firebase_options.dart';
import 'package:dars_50/services/firestore_services.dart';
import 'package:dars_50/views/screens/home_screen.dart';
import 'package:dars_50/views/screens/login_screen.dart';
import 'package:dars_50/views/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "name-here",
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx){
            return AuthController();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx){
            return FirestoreController();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx){
            return ChatController();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }

            if (snapshot.hasError)
              return Text(
                "Xatolik kelilb chiqdi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              );

            return snapshot.data == null ? LoginScreen() : HomeScreen();
          },
        ),
      ),
    );
  }
}
