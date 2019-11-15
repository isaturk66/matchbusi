import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

import 'package:get_it/get_it.dart';



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
                
                databaseReference
      .collection('users')
      .where("email", isEqualTo: linkedInUser.email.elements[0].handleDeep.emailAddress)
      .snapshots()
      .listen((data){
        if(data.documents.isEmpty){
                 Navigator.of(context).pushNamed(createAccountRoute,arguments:linkedInUser.email.elements[0].handleDeep.emailAddress );
          
        }else{
          var model = UserModel(
            username: data.documents.first.data['username'],
            email: data.documents.first.data['email'],
            title: data.documents.first.data['title'],
            skills: data.documents.first.data['skills'].cast<String>().toList(),
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
