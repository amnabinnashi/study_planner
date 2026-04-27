import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSubjects() {
    return _db.collection('subjects').snapshots();
  }

  Future<void> addSubject(String name, int hours) async {
    await _db.collection('subjects').add({
      'name': name,
      'totalHours': hours,
      'doneHours': 0,
    });
  }

  Future<void> updateProgress(String id, int doneHours) async {
    await _db.collection('subjects').doc(id).update({
      'doneHours': doneHours,
    });
  }

  Future<void> deleteSubject(String id) async {
    await _db.collection('subjects').doc(id).delete();
  }
}
