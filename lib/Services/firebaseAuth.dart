import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Models/userModel.dart';


class FirebaseAuth{


   UserModel _currentUser;

   get currentuser => _currentUser;
   set currentuser(var value) 
   {
     _currentUser = currentuser;
   }

   final databaseReference = Firestore.instance;
    
  createAccount(var userID,name,title,skills,email,profileImg) async{
    List<String> skilllist =skills.toString().split(",").toList();
    await databaseReference.collection('users').document("linked in idw").snapshots().listen((querrsnapshots){});
    await databaseReference.collection('users')
    .document()
    .setData({ 'userID' : userID,'email': email, 'username': name,'title' : title,'skills': skilllist});


    var createnmodel = UserModel(
      userID: userID,
      email: email,
      username: name,
      skills: skilllist,
      title: title,
      profilePicture: profileImg
    );
    _currentUser = createnmodel;
  }
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