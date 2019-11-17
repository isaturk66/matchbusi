import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Models/userModel.dart';


class FirebaseAuth{


   UserModel _currentUser;

   get currentuser => _currentUser;
   set currentuser(var value) 
   {
     _currentUser = value;
   }

   final databaseReference = Firestore.instance;
    
  createAccount(var userID,name,title,skills,email,profileImg) async{
    await databaseReference.collection('users')
    .document()
    .setData({ 'userID' : userID,'email': email, 'username': name,'title' : title,'skills': skills, 'conversations' : [],'profileImg' : profileImg});


    var createnmodel = UserModel(
      userID: userID,
      email: email,
      username: name,
      skills: skills,
      title: title,
      profilePicture: profileImg,
      conversations: [],
    );
    _currentUser = createnmodel;
  }




  refreshState(){
      databaseReference
      .collection('users')
      .where("email", isEqualTo: currentuser.email)
      .snapshots()
      .listen((data) async{
         var model = UserModel(
            userID: data.documents.first.data['userID'],
            username: data.documents.first.data['username'],
            email: data.documents.first.data['email'],
            title: data.documents.first.data['title'],
            skills: data.documents.first.data['skills'].cast<String>().toList(),
            profilePicture: currentuser.profilePicture,
            conversations: data.documents.first.data['conversations'].cast<String>().toList(),
          );
            _currentUser = model;
      });
  }


  /// !!!!!!
   Future<bool> checkUserRegistiration(var email) {

      Stream<bool> result;

     databaseReference
      .collection('users')
      .where("email", isEqualTo: email)
      .snapshots()
      .listen((data){
        if(data.documents.isEmpty){
          print("no registiration");
          return false;
        }else{
          var model = UserModel(
            username: data.documents.first.data['username'],
            email: data.documents.first.data['email'],
            title: data.documents.first.data['title'],
            skills: data.documents.first.data['skills'].cast<String>().toList(),

            //profilePicture: data.documents.first.data[]
          );
          _currentUser = model;
            return true;
                  }
      });
  }






}