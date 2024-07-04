import 'package:dars_50/views/screens/chat_screen.dart';
import 'package:dars_50/views/screens/contacts_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [
    ChatScreen(),
    ContactsScreen()
  ];
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value){
          setState(() {
            _index = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat,color: _index == 0 ? Colors.green : Colors.black,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail,color: _index == 1 ? Colors.green : Colors.black,),label: ''),
        ],
      ),
    );
  }
}
