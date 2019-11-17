import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Models/messageModel.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class ChatService with ChangeNotifier {
  final db = Firestore.instance;
  GetIt getIt = GetIt.I;


  List<UserModel> allConversations = new List<UserModel>();

  getConver(){
    var authState = getIt<FirebaseAuth>();
    getAllConversation().listen((data) async{
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
        notifyListeners();

      });

          
        });
      
      
        
      });
  }

  ChatService(){
    db.collection("conversations").snapshots().listen((querySnapshot) {
      notifyListeners();  
  
    });
  }

   final databaseReference = Firestore.instance;

  Stream<QuerySnapshot> getAllConversation(){
    var authState = getIt<FirebaseAuth>();

    return databaseReference
      .collection('users')
      .where("email", isEqualTo: authState.currentuser.email)
      .snapshots();
      // .listen((data) async{
      //    var model = UserModel(
      //       userID: data.documents.first.data['userID'],
      //       username: data.documents.first.data['username'],
      //       email: data.documents.first.data['email'],
      //       title: data.documents.first.data['title'],
      //       skills: data.documents.first.data['skills'].cast<String>().toList(),
      //       profilePicture: authState.currentuser.profilePicture,
      //       conversations: data.documents.first.data['conversations'].cast<String>().toList(),
      //     );
      //       authState.currentuser = model;

      //   var conversationList = model.conversations;
      // });
      
    
  }


///Returns a [List<MessageModel>]
  getMessage(var user1,user2) async{
    var docInstance = await _checkDocument(user1, user2);
    if(docInstance is DocumentSnapshot){
      List<dynamic> responseList = docInstance.data["messages"];
      List<MessageModel> messages = List<MessageModel>(); 
      responseList.forEach((mes){
        messages.add(MessageModel(
          from: mes['from'],
          to: mes['to'],
          message: mes['message']
        ));
      });
      return messages;
    }else{
        Map<String, dynamic> postMap = MessagesModel([]).toJson();
        var artificialdocumentID = user1+"--"+user2;
        db.collection("conversations").document(artificialdocumentID).setData(postMap);

        UserModel currentuser = getIt<FirebaseAuth>().currentuser;
          List<String> conversationList = List<String>();
          conversationList.addAll(currentuser.conversations);
          conversationList.add(user2);
          var overrideUser= UserModel(
            userID: currentuser.userID,
            username: currentuser.username,
            email: currentuser.email,
            title: currentuser.title,
            profilePicture: currentuser.profilePicture,
            skills: currentuser.skills,
            conversations: conversationList,
          );

          var seconduser = await db.collection("users").where("userID",isEqualTo: user2).getDocuments();
          var firstUser = await db.collection("users").where("userID",isEqualTo: user1).getDocuments();

          List<String> conve2 = List<String>();
          var convearray = new List<String>.from(seconduser.documents.first.data['conversations']);
          conve2.addAll(convearray);
          conve2.add(user1);
          print("USER 1 : -------------------------------- : "+user1);
          var overrideUser2= UserModel(
            userID: seconduser.documents.first.data['userID'],
            username: seconduser.documents.first.data['username'],
            email: seconduser.documents.first.data['email'],
            title: seconduser.documents.first.data['title'],
            profilePicture: seconduser.documents.first.data['profileImg'],
            skills: new List<String>.from(seconduser.documents.first.data['skills']),
            conversations: conve2
          );


          Map<String, dynamic> postUser1 = overrideUser.toJson();
          Map<String, dynamic> postUser2 = overrideUser2.toJson();

          db.collection("users").document(seconduser.documents.first.documentID).setData(postUser2);
          db.collection("users").document(firstUser.documents.first.documentID).setData(postUser1);
          

        return null;
      };
  }


///Returns a [List<MessageModel>] after the new message pushed
  pushMessage(var from,to,message) async{
    var response = await _checkDocument(from, to);
      var messageMap = new Map();
      messageMap["from"] = from;
      messageMap["to"] = to;
      messageMap["message"] =message;
      List<dynamic> responseMessages = List<dynamic>();
      if(response is DocumentSnapshot){
        responseMessages.addAll(response.data["messages"]);
      }
      responseMessages.add(messageMap);
      Map<String, dynamic> postMap = MessagesModel(responseMessages).toJson();
      if(response != null){
        db.collection("conversations").document(response.documentID).setData(postMap);
      }else{  
        var artificialdocumentID = from+"--"+to;
          db.collection("conversations").document(artificialdocumentID).setData(postMap);
          UserModel currentuser = getIt<FirebaseAuth>().currentuser;
          List<String> conversationList = List<String>();
          conversationList.addAll(currentuser.conversations);
          conversationList.add(to);
          var overrideUser= UserModel(
            userID: currentuser.userID,
            username: currentuser.username,
            email: currentuser.email,
            title: currentuser.title,
            profilePicture: currentuser.profilePicture,
            skills: currentuser.skills,
            conversations: conversationList,
          );
          Map<String, dynamic> postUser = overrideUser.toJson();

           db.collection("users").where("email",isEqualTo:currentuser.email).snapshots().listen((data){
             db.collection("users").document(data.documents[0].documentID).setData(postUser);
            currentuser = overrideUser;
          });

      }

      return await getMessage(from, to);
  }

  _checkDocument(var user1,user2)async{
    var documentID = user1+"--"+user2;
    var docSnapshot = await db.collection('conversations').document(documentID).get();

      if(docSnapshot.exists){
         return docSnapshot;
      }else{
         var docSnapshot2=await db.collection('conversations').document(user2+"--"+user1).get();
            if(docSnapshot2.exists){
              return docSnapshot2;

            }else{
              return null;
            }

      }    


  }


}