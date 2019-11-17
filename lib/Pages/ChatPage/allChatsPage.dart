import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/chatService.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class AllChatsPage extends StatefulWidget {
  @override
  
  _AllChatsPageState createState() => _AllChatsPageState();
}


class _AllChatsPageState extends State<AllChatsPage> {
  final GetIt getIt = GetIt.I;
  
  List<UserModel> allConversations = List<UserModel>();
   final c = new Completer();

  Future<void >setupCoversations(){
    var chatState = getIt<ChatService>();
    var authState = getIt<FirebaseAuth>();
    allConversations = [];
    chatState.getAllConversation().listen((data) async{
         var model = UserModel(
            userID: data.documents.first.data['userID'],
            username: data.documents.first.data['username'],
            email: data.documents.first.data['email'],
            title: data.documents.first.data['title'],
            skills: data.documents.first.data['skills'].cast<String>().toList(),
            profilePicture: data.documents.first.data['profileImg'],
            conversations: data.documents.first.data['conversations'].cast<String>().toList(),
          );
            authState.currentuser = model;

        List<String> conversationList = model.conversations;
      



        //Todo: Userları sırayla almayı mutlaka değiştir yoksa rezil olursun mazallah
        
        conversationList.forEach((f)async{
             final databaseReference = Firestore.instance;

          databaseReference
      .collection('users')
      .where("userID", isEqualTo: f)
      .snapshots()
      .listen((data) async{
        DocumentSnapshot doc = data.documents.first;
        allConversations.add(
            UserModel(
              userID: doc.data['userID'],
              username: doc.data['username'],
              email: doc.data['email'],
              title: doc.data['title'],
              skills:doc.data['skills'].cast<String>().toList(),
              profilePicture: doc.data['profileImg'],
              conversations: doc.data['conversations'].cast<String>().toList(),
            )
          );  
        setState(() {
        });
        c.complete();

      });

          
        });
      
      
        
      });
      return c.future;
  }


  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

    print("asda");
    setupCoversations();
  }


  Widget UserTile(UserModel model){
    return new ListTile(
      onTap: (){
        
        Navigator.of(context).pushNamed(chatRoute,arguments: model);
      },
      title: new Text(model.username),
      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(model.profilePicture),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    
    return new Container(
      color: Colors.white,
      
      child: RefreshIndicator(
        onRefresh: setupCoversations,
              child: new ListView.builder(
                itemCount: allConversations.length,
                itemBuilder: (context,i) => UserTile(allConversations[i]) ,
                 
              ),
                  
      )
    );
  }
}