import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:matchbussiness/Models/createAccountArgModel.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final String redirectUrl = 'https://example.com/';

final String clientId = '77d89fpupzschu';

final String clientSecret = 'qqJbZs56eSPbuHM5';

var isSignInTouched = false;

final GetIt sl = GetIt.instance;

 fetchAccount(String token) async{
  var response = await http.get(
    'https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))',
    // Send authorization headers to the backend.
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"}, /// Token object access tocen Bearer auth
  );
  return processProfileImage(response.body);
}

processProfileImage(String jsonstring){
  var json = jsonDecode(jsonstring);
  var imageList = json['profilePicture']['displayImage~']['elements'];
  assert(imageList is List);
  var profileImage = imageList[imageList.length-1]['identifiers'][0]['identifier'];
  return profileImage;
}

 

@override
void initState(){ 
  super.initState();
}

/// Sign In Button Widget Params : context
  Widget SignInButton(BuildContext context){

    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        setState(() {
          isSignInTouched = true;
        });
      },
      child: new Container(
        height: 50.0,
        width: media.width*4/8,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.grey
          )
        ),
         child: new Row(
           children: <Widget>[
             new Image.asset("assets/googlelogo.png"),
             new Text("Sign in with Google",style: TextStyle(color: Colors.grey,fontSize: 16),)
           ],
         ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.white,
        child: new Center(
          child: isSignInTouched ? 
          LinkedInUserWidget(
       redirectUrl: redirectUrl,
       clientId: clientId,
       clientSecret: clientSecret,
       onGetUserProfile:
           (LinkedInUserModel linkedInUser) async{
             var myAppModel = sl<FirebaseAuth>();
                final databaseReference = Firestore.instance;
                //print("UserID : "+linkedInUser.userId);
                //print("ProfilePicture : "+linkedInUser.profilePicture.toString());

print(linkedInUser.token.accessToken);
                
                databaseReference
      .collection('users')
      .where("email", isEqualTo: linkedInUser.email.elements[0].handleDeep.emailAddress)
      .snapshots()
      .listen((data) async{
        var profileimg = await fetchAccount(linkedInUser.token.accessToken);
        if(data.documents.isEmpty){
                 Navigator.of(context).pushNamed(createAccountRoute,arguments: CreateAccArg(linkedInUser.userId,linkedInUser.email.elements[0].handleDeep.emailAddress,profileimg.body));
          
        }else{
        
          var model = UserModel(
            userID: data.documents.first.data['userID'],
            username: data.documents.first.data['username'],
            email: data.documents.first.data['email'],
            title: data.documents.first.data['title'],
            skills: data.documents.first.data['skills'].cast<String>().toList(),
            profilePicture: profileimg,
          );
            myAppModel.currentuser = model;
                  Navigator.of(context).pushNamed(skeletonRoute);
                  }
      });
                
              
                
                
       },
       catchError: (LinkedInErrorObject error) {
         print(
             'Error description: ${error.description},'
             ' Error code: ${error.statusCode.toString()}');
        },
    )
    :
    SignInButton(context),
          
        ),

      ),
      
    );
  }
}  
