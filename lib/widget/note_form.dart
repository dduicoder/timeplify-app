import 'package:flutter/material.dart';
import 'package:timeplifey/models/note.dart';
import 'package:uuid/uuid.dart';

class NoteForm extends StatefulWidget {
  final Function(Note) onSubmit;

  const NoteForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  void _submitForm() {
    final title = _titleController.text;
    final description = _textController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      widget.onSubmit(
        Note(
          id: const Uuid().v4(),
          title: title,
          text: description,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.only(
          top: 0,
          left: 32,
          right: 32,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 32,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const SizedBox(
                    height: 5,
                    width: 100,
                  ),
                ),
              ),
            ),
            Text(
              "New Note",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) => _submitForm(),
              controller: _titleController,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Text",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) => _submitForm(),
              controller: _textController,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Add Note"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
