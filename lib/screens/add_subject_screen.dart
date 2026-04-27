import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/study_provider.dart';

class AddSubjectScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Subject"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Subject Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: hoursController,
              decoration: InputDecoration(
                labelText: "Total Hours",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final hours = int.tryParse(hoursController.text);

                if (name.isEmpty || hours == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter valid data")),
                  );
                  return;
                }

                provider.addSubject(name, hours);

                Navigator.pop(context); // يرجع للشاشة الرئيسية
              },
              child: Text("Add Subject"),
            )
          ],
        ),
      ),
    );
  }
}
