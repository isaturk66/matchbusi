import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class ProfilePage extends StatelessWidget {
    GetIt getIt = GetIt.I;
  
  ProfilePage({Key key}) : super(key: key);

  
  
  @override   
  Widget build(BuildContext context) {
    var authState = getIt<FirebaseAuth>();

    return Container(
      color: Colors.blueAccent,
      child: new Center(
        child: Image.network(authState.currentuser.profilePicture),
      ),
    );
  }
}