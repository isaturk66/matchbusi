
import 'package:matchbussiness/Services/chatService.dart';
import 'package:matchbussiness/Services/firebaseAuth.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;


void setupLocator() {
    locator.registerSingleton(FirebaseAuth());
    locator.registerSingleton(ChatService());
}