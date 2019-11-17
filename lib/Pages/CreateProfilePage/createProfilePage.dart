import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Models/createAccountArgModel.dart';
import 'package:matchbussiness/Pages/MatchPage/multiSelectChip.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';

class CreateProfilePage extends StatefulWidget {

  final CreateAccArg args;
  CreateProfilePage(this.args);

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final GetIt sl = GetIt.instance;

    final namecontroller = TextEditingController();

  final titlecontroller = TextEditingController();

  final skillscontroller = TextEditingController();

    List<String> selectedSkillsList = List();

List<String> skillsList = [
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
                  child: Form(
            key: _formKey,
            child: 
                new Column(
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(top:30.0+MediaQuery.of(context).padding.top,bottom: 20),
                      child: new Text("Let's Create Your Account",style: TextStyle(color: Colors.green,fontSize: 30),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
    controller: namecontroller,
                        decoration: new InputDecoration(
                          
                          labelText: "Enter Your Name",
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: titlecontroller,
                        // The validator receives the text that the user has entered.
                        decoration: new InputDecoration(
                          labelText: "Enter Your Title",
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          new Text("What Do You Expect From Your Match",style: TextStyle(color: Colors.green,fontSize: 20),),
                          new Container(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: MultiSelectChip(
                              skillsList,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    selectedSkillsList = selectedList;
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
                                             var myAppModel = sl<FirebaseAuth>();
                                             await myAppModel.createAccount(widget.args.userID,namecontroller.value.text, titlecontroller.value.text, selectedSkillsList, widget.args.email,widget.args.profileImg);
                                             Navigator.of(context).pushNamed(skeletonRoute);
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
                          
                          child: new Center(child: new Text("Create Now",style: TextStyle(color:Colors.white,fontSize: 30),),),
                        ),
                      ),
                    )

                  ],
                ),
              
          ),
        ),
      ),
    );
  }
}
