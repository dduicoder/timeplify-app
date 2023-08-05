import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/calendar.dart';
import '../../widget/calendar_form.dart';
import '../../functions/calendar.dart';

String getAll = """
query GetAll {
  getAll {
    date
    calendars {
      title
    }
  }
}
""";

String getDate = """
query getDate(\$date: String!) {
  getDate(date: \$date) {
    calendars {
      id
      title
      start
      end
      description
    }
  }
}
""";

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late ValueNotifier<List<Calendar>> _selectedCalendars;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Calendar> _getCalendarsForDay(DateTime day) {
    return kCalendars[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedCalendars.value = _getCalendarsForDay(selectedDay);
    }
  }

  void _openTransactionModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: CalendarForm(
            currentDate: _focusedDay,
            onSubmit: (calendar) {
              print((calendar).id);
            },
          ),
        );
      },
    );
  }

  void _showDescription(BuildContext ctx, String description) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(
            "Description",
            style: Theme.of(ctx).textTheme.bodyLarge,
          ),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedCalendars = ValueNotifier(_getCalendarsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedCalendars.dispose();
    super.dispose();
  }

  final _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Calendar",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ElevatedButton(
                  onPressed: () => _openTransactionModal(context),
                  child: const Text(
                    "Add Calendar",
                  ),
                ),
              ],
            ),
            TableCalendar<Calendar>(
              firstDay: DateTime(_today.year, _today.month - 3, _today.day),
              lastDay: DateTime(_today.year, _today.month + 3, _today.day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              eventLoader: _getCalendarsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                markerSize: 6,
              ),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ValueListenableBuilder<List<Calendar>>(
                valueListenable: _selectedCalendars,
                builder: (context, value, _) {
                  return value.isEmpty
                      ? const Center(child: Text("- No Calendars -"))
                      : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final item = value[index];
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              onTap: () =>
                                  _showDescription(context, item.description),
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                "${item.startTime} ~ ${item.endTime}",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              subtitle: Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
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
