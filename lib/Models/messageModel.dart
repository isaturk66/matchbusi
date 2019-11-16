class MessagesModel{
  final List<dynamic> messages;
  MessagesModel(this.messages);

  Map<String, dynamic> toJson() =>
    {
      'messages': messages,
    };
}

class MessageModel{
  final String from, to , message;
  MessageModel({this.from,this.to,this.message});


  String stringlfy()=> "From The User : "+ from +" | "+"To The User : "+ to +" | "+"Message : "+ message;

}
