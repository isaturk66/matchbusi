import 'package:flutter/material.dart';






class SwipeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Card(
      elevation: 1.0,
      child: new Container(
        width: media.width*4/5,
        height: media.height/2,
        child: new Center(child: new Text("new Card"),),
      ),
    );
  }
}