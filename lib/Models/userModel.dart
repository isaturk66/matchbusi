class UserModel{
  final String username,email,title,userID;
 final List<String> skills;
 final List<String> conversations;
  final String profilePicture;
  UserModel({this.userID,this.username,this.email,this.title,this.skills,this.profilePicture,this.conversations});


  Map<String,dynamic> toJson() {
    if(conversations == null){
return {
      'userID': userID,
      'email' : email,
      'username':username,
      'title' : title,
      'skills' : skills,
      'conversations': List<String>(),
      'profileImg' : profilePicture,

    };
    }else{
      return {
      'userID': userID,
      'email' : email,
      'username':username,
      'title' : title,
      'skills' : skills,
      'conversations': conversations,
      'profileImg' : profilePicture,

    };
    }

    
  }

}