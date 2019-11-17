import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Pages/MatchPage/matchViewPage.dart';
import 'package:matchbussiness/Pages/MatchPage/multiSelectChip.dart';
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



List<String> demandList = [
    "Mobile App Development",
"Agile Development",
"Web Applications",

"Marketing Strategy",
"Growth Hacking",
"Marketing Automation",
"Content Marketing",
"Digital Marketing",
"UI Designer",
"Interaction Designer",
"Experience Designer",
"UI Arist",
"Web Designer",
"Industrial Design",
"Business Development manager",
"Business Development director",
"Business Development Lead",
"Business Development Analyst",
"Workplace Coaching",
"Data Scientist",
"Database Developer",
"Data Analytics Manager",
"Business Intelligence Analyst",
"Machine Learning Engineers",
"Data Scientists",
"Research Scientists"];

List<String> offerList = [
    "Mobile App Development",
"Agile Development",
"Web Applications",

"Marketing Strategy",
"Growth Hacking",
"Marketing Automation",
"Content Marketing",
"Digital Marketing",
"UI Designer",
"Interaction Designer",
"Experience Designer",
"UI Arist",
"Web Designer",
"Industrial Design",
"Business Development manager",
"Business Development director",
"Business Development Lead",
"Business Development Analyst",
"Workplace Coaching",
"Data Scientist",
"Database Developer",
"Data Analytics Manager",
"Business Intelligence Analyst",
"Machine Learning Engineers",
"Data Scientists",
"Research Scientists"];

    List<String> selectedDemandList = List();
  List<String> selectedOfferList = List();



var matchlist;

  @override
  Widget build(BuildContext context) {
    return matchlist == null? 
    
     new Container(
        color: Colors.white,
        
        child: SingleChildScrollView(
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
                      child: Column(
                        children: <Widget>[
                          new Text("What Do You Expect From Your Match",style: TextStyle(color: Colors.green,fontSize: 20),),
                          new Container(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: MultiSelectChip(
                              demandList,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    selectedDemandList = selectedList;
                  });
                },
                            ),
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          new Text("What Do You Offer To Your Match",style: TextStyle(color: Colors.green,fontSize: 20),),
                          new Container(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width,

                            child: MultiSelectChip(
                              demandList,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    selectedOfferList = selectedList;
                  });
                },
                            ),
                          ),
                        ],
                      )
                    ),
                    
                      GestureDetector(
                      onTap: ()async{
                              if (_formKey.currentState.validate()) {                              
                                List<DocumentSnapshot> found = List<DocumentSnapshot>();
                                List<DocumentSnapshot> docList = await matcher.matchQuerry();
                                
                                docList.forEach((f){
                                  List skills = f.data['skills'];
                                  for(var skill in skills){
                                    if(selectedDemandList.contains(skill)){
                                      found.add(f);
                                      break;
                                      }
                                  }  
                                  print("anan");
                                });
                                print("eben");
                                setState(() {
                                  matchlist = found;
                                });

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
        ),
    )
    :
    MatchViewPage(matchlist);
  }
}
