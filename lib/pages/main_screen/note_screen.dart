import 'package:flutter/material.dart';
import '../../models/note.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = [
      Note(title: "Hi", text: "1"),
      Note(title: "Hi", text: "2"),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Note",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (ctx, index) {
                  final item = notes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.025),
                          blurRadius: 8,
                          spreadRadius: 8,
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title),
                        Divider(color: Colors.black.withOpacity(0.1)),
                        Text(item.text),
                      ],
                    ),
                  );
                },
              ),
            ),
            const TextField(),
          ],
        ),
      ),
    );
  }
}
