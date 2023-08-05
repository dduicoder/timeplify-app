import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'package:timeplifey/models/calendar.dart';

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kCalendars = LinkedHashMap<DateTime, List<Calendar>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<String, List<Calendar>> serverData = {
  "2023-08-04": [
    Calendar(
      id: "dd",
      title: "First",
      startTime: "11:00",
      endTime: "12:55",
      description: "Normal Description",
    ),
    Calendar(
      id: "ff",
      title: "Second",
      startTime: "13:00",
      endTime: "13:55",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dictum eleifend massa a tempor. Sed non scelerisque odio. ",
    ),
  ],
  "2023-08-05": [
    Calendar(
      id: "dds",
      title: "First",
      startTime: "12:00",
      endTime: "12:55",
      description: "Normal Description",
    ),
    Calendar(
      id: "ff",
      title: "Second",
      startTime: "12:00",
      endTime: "12:55",
      description: "Normal Description",
    ),
  ],
};

final Map<DateTime, List<Calendar>> _kEventSource = serverData.map(
  (key, value) => MapEntry(
    DateTime.parse(key),
    value,
  ),
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
