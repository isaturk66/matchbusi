import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:flutter/material.dart';
import 'package:matchbussiness/Pages/ChatPage/chatPage.dart';
import 'package:matchbussiness/Pages/CreateProfilePage/createProfilePage.dart';
import 'package:matchbussiness/Pages/LoginPage/loginPage.dart';
import 'package:matchbussiness/Pages/MatchPage/matchFormPage.dart';
import 'package:matchbussiness/Pages/SkeletonPage/skeletonPage.dart';



Route<dynamic> generateRoute(RouteSettings settings) {
  // Here is where all the routing is handled

  switch(settings.name){
    case loginRoute : {
        return MaterialPageRoute(builder: (context) => LoginPage());
      }
      break;
    case matchFormRoute :{
      return MaterialPageRoute(builder: (context) => MatchFormPage());

    }
    break;
    case createAccountRoute :{
      return MaterialPageRoute(builder: (context) => CreateProfilePage(settings.arguments));

    }
    break;
    case skeletonRoute :{
      return MaterialPageRoute(builder: (context) => SkeletonPage());

    }
    break;

    case chatRoute : {
            return MaterialPageRoute(builder: (context) => PreChatPage(settings.arguments));

    }
    break;
  }

}
