import 'package:dars_50/controllers/firestore_controller.dart';
import 'package:dars_50/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    final _fireStoreController = Provider.of<FirestoreController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: StreamBuilder(
        stream: _fireStoreController.getUsers,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.red,),);
          }

          if(snapshot.hasError){
            return Center(child: Text("Kechirasiz malumot olishda hatolik yuzaga keldi",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),),);
          }

          final data = snapshot.data!.docs;
          if(data != null){
            for(int i = 0;i < data.length;i++)
              _fireStoreController.adduser(User.fromJson(data[i]));
          }

          return ListView.builder(
            itemCount: _fireStoreController.getUsersController.length,
            itemBuilder: (context,index){
              User user = _fireStoreController.getUsersController[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${user.name}",style: TextStyle(fontSize: 20,color: Colors.blue),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.chat),),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
