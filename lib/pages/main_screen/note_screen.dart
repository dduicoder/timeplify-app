import 'package:flutter/material.dart';
import 'package:timeplifey/widget/note_form.dart';
import '../../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final List<Note> _notes = [
    Note(id: "n1", title: "Note", text: "hihi"),
  ];

  void _openNoteModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NoteForm(
            onSubmit: (note) {
              setState(() {
                _notes.add(note);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Note",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ElevatedButton(
                  onPressed: () {
                    _openNoteModal(context);
                  },
                  child: const Text("Add Note"),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            _notes.isEmpty
                ? const Expanded(child: Center(child: Text("- No Notes -")))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (ctx, index) {
                        final item = _notes[index];
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _notes.remove(item);
                                      });
                                    },
                                    icon: const Icon(Icons.delete_rounded),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.black.withOpacity(0.05)),
                              Text(item.text),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
