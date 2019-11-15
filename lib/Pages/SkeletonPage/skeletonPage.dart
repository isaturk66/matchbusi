import 'package:flutter/material.dart';
import 'package:matchbussiness/Pages/MatchPage/matchFormPage.dart';
class SkeletonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.search,color: Colors.black)),
                Tab(icon: Icon(Icons.person,color: Colors.black,)),
                
              ],
            ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MatchFormPage(),
              Icon(Icons.directions_transit),
              
            ],
          ),
        ),
      );
  }
}