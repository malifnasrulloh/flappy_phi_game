import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  static var db = FirebaseFirestore.instance;

  static List allData = [];

  static Future<void> storeData(String uid, Map<String, dynamic> data) async {
    await db.collection("userData").doc(uid).set(data, SetOptions(merge: true));
  }

  static Future<void> getAllData() async {
    allData = [];
    for (var element
        in (await FirestoreController.db.collection("userData").get()).docs) {
      allData.add({
        "uid": element.id,
        "name": element.data()['name'],
        "high_score": element.data()['high_score']
      });
    }
    allData.sort(((a, b) => b['high_score'].compareTo(a['high_score'])));
  }
}
