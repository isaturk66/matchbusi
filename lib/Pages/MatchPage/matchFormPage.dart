import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Pages/MatchPage/matchViewPage.dart';
import 'package:matchbussiness/Services/matcher.dart';
class MatchFormPage extends StatefulWidget {

  @override
  _MatchFormPageState createState() => _MatchFormPageState();
}

class _MatchFormPageState extends State<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();

  final GetIt sl = GetIt.instance;

    final namecontroller = TextEditingController();

  final titlecontroller = TextEditingController();

  final skillscontroller = TextEditingController();

Matcher matcher = new Matcher();

var matchlist;

  @override
  Widget build(BuildContext context) {
    return matchlist == null? 
     new Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: 
              new Column(
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top:30.0+MediaQuery.of(context).padding.top,bottom: 20),
                    child: new Text("Let's Match!!",style: TextStyle(color: Colors.green,fontSize: 30),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
    controller: namecontroller,
                      decoration: new InputDecoration(
                        
                        labelText: "What Do You Expect From Your Match?",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }else if(value.split(",").toList().length >3){
                          return 'Your expectation must be less than 3';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: titlecontroller,
                      // The validator receives the text that the user has entered.
                      decoration: new InputDecoration(
                        labelText: "What Do You Offer To Your Match?",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                    GestureDetector(
                    onTap: ()async{
                            if (_formKey.currentState.validate()) { 
                              var querrylist = namecontroller.value.text.split(",").toList();
                              switch (querrylist.length) {
                                case 1:
                                matchlist = await matcher.matchQuerry1(querrylist[0]);

                                setState((){});                        
                                  break;
                                case 2:
                                
                                   matchlist = await matcher.matchQuerry2(querrylist[0],querrylist[1]);
                                setState((){});                        
                                  break;
                                case 3:
                                
                                  matchlist = await matcher.matchQuerry3(querrylist[0],querrylist[1],querrylist[2]);
                                setState((){});                        
                                  break;
                              }
                            }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new Container(
                        width: MediaQuery.of(context).size.width-40,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: new BorderRadius.circular(30.0),

                        ),
                        
                        child: new Center(child: new Text("Match Now",style: TextStyle(color:Colors.white,fontSize: 30),),),
                      ),
                    ),
                  )

                ],
              ),
            
        ),
    )
    :
    MatchViewPage(matchlist);
  }
}