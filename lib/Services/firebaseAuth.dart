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
  
  createAccount(var name,title,skills,email,) async{
    List<String> skilllist =skills.toString().split(",").toList();
    await databaseReference.collection('users').document()
    .setData({ 'email': email, 'username': name,'title' : title,'skills': skilllist});


    var createnmodel = UserModel(
      email: email,
      username: name,
      skills: skilllist,
      title: title,
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
          );
          _currentUser = model;
            return true;
                  }
      });
  }






}