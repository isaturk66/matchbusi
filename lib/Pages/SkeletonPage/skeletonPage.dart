import 'package:flutter/material.dart';
import 'package:matchbussiness/Pages/ChatPage/chatPage.dart';
import 'package:matchbussiness/Pages/MatchPage/matchFormPage.dart';
import 'package:matchbussiness/Pages/ProfilePage/profilePage.dart';
import 'package:matchbussiness/Services/chatService.dart';
import 'package:provider/provider.dart';

class SkeletonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.chat, color: Colors.black)),
            Tab(icon: Icon(Icons.search, color: Colors.black)),
            Tab(
                icon: Icon(
              Icons.person,
              color: Colors.black,
            )),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ChangeNotifierProvider(
              builder: (context) => ChatService(),
              child: ChatPage(),
            ),
            MatchFormPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
