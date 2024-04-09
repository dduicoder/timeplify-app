import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PomodoroForm extends StatefulWidget {
  final Function(String) onSubmit;

  const PomodoroForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<PomodoroForm> createState() => _PomodoroFormState();
}

class _PomodoroFormState extends State<PomodoroForm> {
  final TextEditingController _timeController = TextEditingController();
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
              "Set Time",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: "Time",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) {
                widget.onSubmit(_timeController.text);
                Navigator.of(context).pop();
              },
              controller: _timeController,
            ),
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
                  onPressed: () {
                    widget.onSubmit(_timeController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Set Time"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
