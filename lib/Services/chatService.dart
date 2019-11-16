import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchbussiness/Models/messageModel.dart';

class ChatService with ChangeNotifier {
  final db = Firestore.instance;

  ChatService(){
    db.collection("conversations").snapshots().listen((querySnapshot) {
      notifyListeners();
    });
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
    }else return null;
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