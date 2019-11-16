import 'package:flutter/material.dart';
import 'package:matchbussiness/Models/messageModel.dart';
import 'package:matchbussiness/Services/chatService.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  List<MessageModel> messages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
        setupMessages();

  }

  setupMessages() async{
    var chatService = Provider.of<ChatService>(context);
    messages = await chatService.getMessage("mert","isa");
    setState(() {
      
    });
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: messages != null?
        
        Padding(
          padding: const EdgeInsets.only(left: 10,top:30.0),
          child: Column(
              children: <Widget>[
                Expanded(
                child:ListView(
                        children: messages.map((f) => new Text(f.message)).toList()
                  ),
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
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.navigation,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: ()async{
                              var chatService = Provider.of<ChatService>(context);
                              var from = "isa",to= "mert";

                              FocusScope.of(context).unfocus();
                              var recentlysent = controller.value.text;
                              controller.text = "";
                              setState(() {
                                messages.add(MessageModel(from: from,to: to,message: recentlysent));
                              });
                              chatService.pushMessage("isa", "mert", recentlysent);
                              
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