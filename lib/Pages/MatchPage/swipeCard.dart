import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';






class SwipeCard extends StatelessWidget {

  final DocumentSnapshot doc;
  SwipeCard(this.doc);


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Card(
      elevation: 1.0,
      child: SingleChildScrollView(
        primary: true,
              child: new Container(
          child: new Column(children: <Widget>[
            Container(
              height: 175,
              width: 175,
              child: new CircleAvatar(
                backgroundImage: NetworkImage(doc.data["profileImg"]),
              ),
            ),

            Container(height: 12  ,),

            new Text(doc.data["username"],style: TextStyle(fontSize: 20),),
            new Text(doc.data["title"],style: TextStyle(fontSize: 13,color: Colors.black54),),

            Container(height: 12  ,),
            ...doc.data["skills"].map((data)=> new Text(data)).toList()

            
          ],),
        ),
      ),
    );
  }
}