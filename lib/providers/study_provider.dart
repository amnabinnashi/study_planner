import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class StudyProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  Stream get subjectsStream => _service.getSubjects();

  Future<void> addSubject(String name, int hours) async {
    await _service.addSubject(name, hours);
  }

  Future<void> addProgress(
      String id, int doneHours, int totalHours) async {
    if (doneHours < totalHours) {
      await _service.updateProgress(id, doneHours + 1);
    }
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
  }
}
