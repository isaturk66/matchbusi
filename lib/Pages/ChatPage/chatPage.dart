import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matchbussiness/Models/messageModel.dart';
import 'package:matchbussiness/Models/userModel.dart';
import 'package:matchbussiness/Services/chatService.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';
import 'package:provider/provider.dart';




class PreChatPage extends StatelessWidget {
  
  final UserModel chatUser;
  PreChatPage(this.chatUser);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
              builder: (context) => ChatService(),
              child: ChatPage(chatUser),
            );
  }
}

class ChatPage extends StatefulWidget {
final UserModel chatUser;
  ChatPage(this.chatUser);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  List<MessageModel> messages;
  final GetIt sl = GetIt.instance;

  Widget MessageElement(var message,from,to){
    var user = sl<FirebaseAuth>().currentuser;


    if(from == user.userID){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          children: <Widget>[
            new Container(height: 8,),
            new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                          color: Colors.greenAccent,

              ),
              child: Container(padding: EdgeInsets.all(8),child: new Text(message)),
            ),
          ],
        ),
      ],
    );
    }else{
      return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            new Container(height: 8,),
            new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,

              ),
              child: Container(padding: EdgeInsets.all(8),child: new Text(message)),
            ),
          ],
        ),
      ],
    );
    }




    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
        setupMessages();

  }
GetIt getIt = GetIt.I;
  setupMessages() async{
    var chatService = Provider.of<ChatService>(context);
    var currenUser = getIt<FirebaseAuth>().currentuser;

    var response;

    //TODO: Change this
    response = await chatService.getMessage(currenUser.userID,widget.chatUser.userID);


    if(response ==null){
      messages = [];
    }else messages =response;
    if(mounted){
    setState(() {
      
    });
    }
  }

  TextEditingController controller = TextEditingController();


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: new Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(widget.chatUser.profilePicture),backgroundColor: Colors.grey,),
            new Container(width: 15,),
            new Text(widget.chatUser.username,style: TextStyle(fontSize: 20,color: Colors.white)),
          ],
        ),
      ),

        body: messages != null?
        
        Padding(
          padding: const EdgeInsets.only(left: 10,top:30.0),
          child: Column(
              children: <Widget>[
                
                Expanded(
                  child: SingleChildScrollView(
                                      child: new Column(
                      children: messages.map((f) => MessageElement(f.message,f.from,f.to)).toList()
                    ),
                  ),
                // child:ListView(
                //         
                //   ),
              ),
                Container(
                      padding: EdgeInsets.only(bottom: 8 , left: 8),
                    child: Row(
                      children: <Widget>[

                        Expanded(


                          child: TextField(
                            controller: controller,
                            
                            cursorColor: Colors.blueGrey,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Mesajınızı Yazınız",
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                borderSide: BorderSide.none
                              ),

                            ),

                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 4
                          ),
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.navigation,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: ()async{
                              var chatService = Provider.of<ChatService>(context);
                              var from,to;
                               var currenUser = getIt<FirebaseAuth>().currentuser;
                               from = currenUser.userID;
                               to = widget.chatUser.userID;

                              FocusScope.of(context).unfocus();
                              var recentlysent = controller.value.text;
                              controller.text = "";
                              setState(() {
                                messages.add(MessageModel(from: from,to: to,message: recentlysent));
                              });
                              chatService.pushMessage(from, to, recentlysent);
                              
                            },

                          ),

                        )

                      ],

                    ),

                ),

              ],
            ),
        )
        :
        new Center(
          child: new CircularProgressIndicator(),
        )
        );
  }
}