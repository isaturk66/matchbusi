import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Pages/MatchPage/swipeCard.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class MatchViewPage extends StatefulWidget {
  @override
    
  _MatchViewPageState createState() => _MatchViewPageState();
  final documents;
  MatchViewPage(this.documents);
}


class _MatchViewPageState extends State<MatchViewPage> {  


  CardController controller; //Use this to trigger swap.

  double messageBox = 0,favBox = 0;
  bool islistOver = false;


  onMessageRequested(var doc){
    TabController controller = DefaultTabController.of(context);
    
    var model = UserModel(
            userID: doc['userID'],
            username: doc['username'],
            email: doc['email'],
            title: doc['title'],
            skills: doc['skills'].cast<String>().toList(),
            profilePicture: doc['profileImg'],
            conversations: doc['conversations'].cast<String>().toList(),
          );

    controller.animateTo(0,duration: Duration(milliseconds:200));


    Future.delayed(Duration(milliseconds:200),() => Navigator.of(context).pushNamed(chatRoute,arguments: model));
    
  }


final GetIt getIt = GetIt.I;

  Widget TinderBody(var totalCount){
        List<DocumentSnapshot> docList= widget.documents;
        
        var currentUser = getIt<FirebaseAuth>().currentuser;
        docList.removeWhere((docsnap) => docsnap.data['userID'] == currentUser.userID);
    return Column(
          children: <Widget>[
            Container(
              height: 500,
                  child: new TinderSwapCard(
                            orientation: AmassOrientation.BOTTOM,
                            totalNum: docList.length,
                            stackNum: 3,
                            swipeEdge: 4.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                            maxHeight: MediaQuery.of(context).size.width * 0.9,
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            minHeight: MediaQuery.of(context).size.width * 0.8,
                            cardBuilder: (context, index) => Card(
                                  child: SwipeCard(docList[index]),
                                 ),
                            cardController: controller = CardController(),
                            swipeUpdateCallback:
                                (DragUpdateDetails details, Alignment align) {
                                  
                              /// Get swiping card's alignment
                              if (align.x < -4) {
                                //Card is LEFT swiping
                                setState(() {
                                  messageBox = 30;
                                });

                              } else if (align.x > 4) {
                                //Card is RIGHT swiping
                                setState(() {
                                  favBox = 30;
                                });
                              }else {
                                setState(() {
                                favBox = 0;
                                messageBox = 0;  
                                });
                                
                              }
                            },
                            swipeCompleteCallback:
                                (CardSwipeOrientation orientation, int index) {
                                  setState(() {
                                    favBox = 0;
                                    messageBox = 0;  
                                });
                                if(orientation == CardSwipeOrientation.LEFT){
                                  onMessageRequested(docList[index]);
                                }
                                if(index == docList.length-1&& orientation != CardSwipeOrientation.RECOVER){
                                  setState(() {
                                    islistOver = true;
                                  });
                                }
                              /// Get orientation & index of swiped card!
                            }),
                ),
              new Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                child:new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){

                      },                    
                      child: new AnimatedContainer(
                        width: messageBox+60,
                        height: messageBox+60,
                        duration: Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(messageBox+50),
                        ),
                        child: new Center(
                          child: new Icon(Icons.message, size: 30, color: Colors.white),
                        ),
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: (){
                        
                    //   },                    
                    //   child: new AnimatedContainer(
                    //     width: 50,
                    //     height: 50,
                    //     duration: Duration(milliseconds: 100),

                    //     decoration: BoxDecoration(
                    //       color: Colors.green,
                    //       borderRadius: BorderRadius.circular(50),
                    //     ),
                    //     child: new Center(
                    //       child: new Icon(Icons.favorite, size: 30, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    
                    GestureDetector(
                      onTap: (){
                      },                    
                      child: new AnimatedContainer(
                        
                        width: favBox+60,
                        height: favBox+60,
                        duration: Duration(milliseconds: 100),

                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(favBox+50),
                        ),
                        child: new Center(
                          child: new Icon(Icons.close, size: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    
                  ],
                )
              )
          ],
        );
  }

  Widget NoCardLeft(){
    
    
    return Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("No Match Left For You"),
                        Card(
                          elevation: 1.0,
                          child: new Container(
                            width: 30,
                            height: 30  ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
  
                            ),
                            child: new Center(
                              child: Icon(Icons.refresh,size:25),
                            ),
                          ),
                        )
                      ],

        
    
                  
                  ),
                
            );
  }


  @override
  Widget build(BuildContext context) {

    return Container(
        color: Colors.white,
        child: islistOver ||widget.documents.length ==0? NoCardLeft() : TinderBody(1)
    );
  }
}