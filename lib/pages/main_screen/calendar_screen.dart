import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeplifey/graphql/querys.dart';
import 'package:timeplifey/widget/calendar_list.dart';

import '../../models/calendar.dart';
import '../../widget/calendar_form.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
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
              GraphQLProvider.of(ctx).value.mutate(
                    MutationOptions(
                      document: gql(querys["addCalendar"]),
                      variables: {
                        "date": DateFormat("yyyy-MM-dd").format(_focusedDay),
                        "calendarId": calendar.id,
                        "title": calendar.title,
                        "start": calendar.start,
                        "end": calendar.end,
                        "description": calendar.description,
                      },
                    ),
                  );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
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
            Query(
              options: QueryOptions(
                document: gql(querys["getAll"]),
              ),
              builder: (result, {refetch, fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                }

                final events = LinkedHashMap<DateTime, List<String>>(
                  equals: isSameDay,
                  hashCode: (DateTime key) {
                    return key.day * 1000000 + key.month * 10000 + key.year;
                  },
                )..addAll({
                    for (var element in result.data!["getAll"]
                        .where((e) => e["calendars"].length != 0))
                      DateTime.parse(element["date"]):
                          (element["calendars"] as List)
                              .map(
                                (item) => item["title"].toString(),
                              )
                              .toList()
                  });

                return TableCalendar<String>(
                  firstDay: DateTime(_today.year, _today.month - 3, _today.day),
                  lastDay: DateTime(_today.year, _today.month + 3, _today.day),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: (DateTime day) {
                    return events[day] ?? [];
                  },
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
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Query(
              options: QueryOptions(
                document: gql(querys["getDate"]),
                variables: {
                  "date": DateFormat('yyyy-MM-dd').format(_focusedDay)
                },
              ),
              builder: (result, {refetch, fetchMore}) {
                if (result.isLoading) {
                  return const Expanded(
                    child: Center(child: Text("Loading...")),
                  );
                }
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                final List<dynamic> queryRes =
                    result.data!["getDate"]["calendars"];
                final List<Calendar> calendars = queryRes.map(
                  (e) {
                    Map<dynamic, dynamic> item = Map.from(e);
                    return Calendar(
                      id: item["id"],
                      title: item["title"],
                      start: item["start"],
                      end: item["end"],
                      description: item["description"],
                    );
                  },
                ).toList();
                return Expanded(
                  child: calendars.isEmpty
                      ? const Center(child: Text("- No Calendars -"))
                      : CalendarList(
                          calendars: calendars,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
