import 'package:flutter/material.dart';
import 'package:matchbussiness/Constants/routerConstants.dart';
import 'package:matchbussiness/Services/router.dart' as router;
import 'package:matchbussiness/Services/serviceLocator.dart';

void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  


  runApp(Main());

}



class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generateRoute,
      initialRoute: loginRoute,      
    );
  }
}
