import 'package:dars_50/controllers/chat_controller.dart';
import 'package:dars_50/models/chat.dart';
import 'package:dars_50/models/message.dart';
import 'package:dars_50/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowChatScreen extends StatefulWidget {
  User user;
  Chat chat;

  ShowChatScreen({super.key, required this.user, required this.chat});

  @override
  State<ShowChatScreen> createState() => _ShowChatScreen();
}

class _ShowChatScreen extends State<ShowChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final textMessage = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    List<Message> message = [for(int i = 0;i < widget.chat.messages.length;i++) Message.fromJson(widget.chat.messages[i])];
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: message.length,
          itemBuilder: (context, index) {
            print(message[index].sendUser);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: message[index].sendUser == widget.user.globalId ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "${message[index].message}",
                      style: TextStyle(color: message[index].sendUser == widget.user.globalId ? Colors.green : Colors.blue),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(),
        child: Row(
          children: [
            Form(
              key: _formKey,
              child: Expanded(child: TextFormField(
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Xabar bosh bolmasligi kerak";
                  }

                  return null;
                },
                controller: textMessage,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Write message"
                ),
              ),),
            ),
            IconButton(
              onPressed: () async{
                final pref = await SharedPreferences.getInstance();
                final globalKey = await pref.getString("globalId");
                if(_formKey.currentState!.validate()){
                  await chatController.writeMessage(textMessage.text, widget.chat.chatId, globalKey.toString());
                }
                print("XAbar yuborildi");
              },
              icon: Icon(
                Icons.send,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
