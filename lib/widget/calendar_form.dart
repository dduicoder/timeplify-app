import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeplifey/models/calendar.dart';
import 'package:uuid/uuid.dart';

TimeOfDay convertStringToTimeOfDay(String inputTime) {
  List<String> parts = inputTime.split(':');
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}

bool isTime1BeforeTime2(String time1, String time2) {
  DateTime dateTime1 = DateTime.parse("2023-08-03 $time1:00");
  DateTime dateTime2 = DateTime.parse("2023-08-03 $time2:00");

  return dateTime1.isBefore(dateTime2);
}

class CalendarForm extends StatefulWidget {
  final Function(Calendar) onSubmit;
  final DateTime currentDate;

  const CalendarForm({
    super.key,
    required this.onSubmit,
    required this.currentDate,
  });

  @override
  State<CalendarForm> createState() => _CalendarFormState();
}

class _CalendarFormState extends State<CalendarForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String _start = "Start";
  late String _end = "End";
  late bool _isDate = true;

  void _openTimePicker(String initialTime, Function(String) setValue) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: convertStringToTimeOfDay(initialTime),
    );

    if (selectedTime != null) {
      var hour = selectedTime.hour.toString();
      var minute = selectedTime.minute.toString();

      hour = hour.length <= 1 ? "0$hour" : hour;
      minute = minute.length <= 1 ? "0$minute" : minute;

      setValue("$hour:$minute");
    }
  }

  void _submitForm() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (_isDate &&
        title.isNotEmpty &&
        _start != "Start" &&
        _end != "End" &&
        isTime1BeforeTime2(_start, _end) &&
        description.isNotEmpty) {
      widget.onSubmit(
        Calendar(
          id: const Uuid().v4(),
          title: title,
          start: _start,
          end: _end,
          description: description,
        ),
      );

      Navigator.of(context).pop();
    } else if (!_isDate && title.isNotEmpty && description.isNotEmpty) {
      widget.onSubmit(
        Calendar(
          id: const Uuid().v4(),
          title: title,
          start: "",
          end: "",
          description: description,
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
              "New Calendar",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "Date: ${DateFormat.yMd().format(widget.currentDate)}",
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Time"),
                Checkbox(
                  value: _isDate,
                  onChanged: (newVal) {
                    setState(() {
                      _isDate = newVal!;
                    });
                  },
                )
              ],
            ),
            _isDate
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => _openTimePicker(
                          _start == "Start"
                              ? DateFormat('HH:mm').format(DateTime.now())
                              : _start,
                          (value) => setState(
                            () => _start = value,
                          ),
                        ),
                        child: Text(_start),
                      ),
                      const Text("~"),
                      TextButton(
                        onPressed: () => _openTimePicker(
                          _end == "End"
                              ? DateFormat('HH:mm').format(DateTime.now())
                              : _end,
                          (value) => setState(
                            () => _end = value,
                          ),
                        ),
                        child: Text(_end),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 16,
                  ),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) => _submitForm(),
              controller: _descriptionController,
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
                  child: const Text("Add Calendar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
