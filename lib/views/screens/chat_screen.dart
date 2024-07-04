
import 'package:dars_50/controllers/chat_controller.dart';
import 'package:dars_50/controllers/firestore_controller.dart';
import 'package:dars_50/models/chat.dart';
import 'package:dars_50/models/message.dart';
import 'package:dars_50/models/user.dart';
import 'package:dars_50/views/screens/show_chat.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String email = '';
  bool isLoading = false;
  List<Chat> chats = [];
  String name = '';
  bool isGetChat = false;

  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    initShared();

  }

  void initShared() async {
    final pref = await SharedPreferences.getInstance();
    email = await pref.getString("email").toString();
    name = await pref.getString('name').toString();
  }

  @override
  Widget build(BuildContext context) {
    final _chatContoller = Provider.of<ChatController>(context);
    void getAllChats() async{
      final data = await _chatContoller.getMyWriteChats();
      chats.addAll(data);
      setState(() {
        isLoading = false;
        isGetChat = true;
      });
    }
    if(!isGetChat)
      getAllChats();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats(${name})",
        ),
        actions: [
          IconButton(
            onPressed: () {
              firebase.FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(
                color: Colors.red,
              ),
          )
          : StreamBuilder(
              stream: _chatContoller.getMyChats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );

                if(!snapshot.hasData)
                  return Center(child: Text("Hozircha chatlar yo'q"),);

                final data = snapshot.data!.docs;
                if (data != null) {
                  for (int i = 0; i < data.length; i++) {
                    print("Bu chat id ${data[i].data()}");
                    _chatContoller.addChat(Chat.fromJson(data[i]));
                  }
                }

                return data == null
                    ? const Center(
                        child: Text(
                          "Hozirda hech qanaqa chatlar mavjud emas",
                        ),
                      )
                    : ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          User user = _chatContoller.getUserWithGlobalId(email,chats[index].users);
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowChatScreen(user: user,chat: chats[index])));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${user.name}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.chat),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
    );
  }
}
