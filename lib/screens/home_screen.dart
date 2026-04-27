import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/study_provider.dart';
import '../add_subject/add_subject_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: provider.subjectsStream,
        builder: (context, snapshot) {
        
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No subjects yet"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final s = docs[i];

              int done = s['doneHours'];
              int total = s['totalHours'];

              double progress =
                  total == 0 ? 0 : done / total; // 🔥 حماية من الخطأ

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    s['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 4),
                      Text("$done / $total hours"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          provider.addProgress(
                            s.id,
                            done,
                            total,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.deleteSubject(s.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSubjectScreen(),
            ),
          );
        },
      ),
    );
  }
}
