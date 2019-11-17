import 'package:cloud_firestore/cloud_firestore.dart';

class Matcher {
  final db = Firestore.instance;


  Future<List<DocumentSnapshot>> matchQuerry() async {
    var result = await db
        .collection("users")
        .getDocuments();
    return result.documents;
  }


  matchQuerry2(var skill1,skill2) async {
    var result = await db
        .collection("users")
        .where("skills", arrayContains: skill1)
        .where("skills", arrayContains: skill2)
        .getDocuments();
    return result;
  }
  matchQuerry3(var skill1,skill2,skill3) async {
    var result = await db
        .collection("users")
        .where("skills", arrayContains: skill1)
        .where("skills", arrayContains: skill2)
        .where("skills", arrayContains: skill3)
        .getDocuments();
    return result;
  }
}
