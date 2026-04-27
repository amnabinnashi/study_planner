import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/study_provider.dart';

class HomeScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Study Planner")),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Subject"),
          ),
          TextField(
            controller: hoursController,
            decoration: InputDecoration(labelText: "Hours"),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              provider.addSubject(
                nameController.text,
                int.parse(hoursController.text),
              );
            },
            child: Text("Add"),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: provider.subjectsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final s = docs[i];

                    double progress =
                        s['doneHours'] / s['totalHours'];

                    return ListTile(
                      title: Text(s['name']),
                      subtitle:
                          LinearProgressIndicator(value: progress),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              provider.addProgress(
                                s.id,
                                s['doneHours'],
                                s['totalHours'],
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteSubject(s.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
