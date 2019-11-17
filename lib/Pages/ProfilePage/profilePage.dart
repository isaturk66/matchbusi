  import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class ProfilePage extends StatelessWidget {
    GetIt getIt = GetIt.I;
  
  ProfilePage({Key key}) : super(key: key);

  
  
  @override   
  Widget build(BuildContext context) {
    UserModel user = getIt<FirebaseAuth>().currentuser;
    return Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*2/5,
          child: Stack(
            children: <Widget>[
              new Container(

                color: Color.fromRGBO(45, 62, 80, 1),
              ),
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Center(
                     child: Container(
                       width: MediaQuery.of(context).size.width*4/10,
                       child: new ClipRRect(
                         
            borderRadius: BorderRadius.circular(100),  
            child: new Image.network(user.profilePicture),
          ),
                     ),
                   ),
                   new Container(height: 8,),
                   new Text(user.username,style: TextStyle(color: Colors.white,fontSize: 25),),
                  new Text(user.title,style: TextStyle(color: Colors.white70,fontSize: 16),),

                 ],
               )
            ],
          ),),
         
          new Column(
            children: <Widget>[
              new Container(height: 10,),
              new Text("Skills",style: TextStyle(color: Colors.green,fontSize: 30),),
              ...user.skills.map((f) => new Text(f)).toList()
            ],
          )

        ],
      ),
    );
  }
}