import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference collection =
      FirebaseFirestore.instance.collection("users");

  // readingGroup is either youth or adult.  Should be an enum I think
  Future updateUserData(String name, String ward, String readingGroup) async {
    return await collection
        .doc(uid)
        .set({'name': name, 'ward': ward, 'readingGroup': readingGroup});
  }

  Future updateUserProgress(UserChapter uc) async {
    return await collection
        .doc(uid).collection("UserChapter")
        .doc(uc.chapterId)
        .set({'read': uc.read, 'lastUpdate': uc.lastUpdate, 'chapterId': uc.chapterId});
  }
}
