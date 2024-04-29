import 'package:flutter/material.dart';
import 'package:timeplifey/models/calendar.dart';
import 'package:timeplifey/widget/calendar_form.dart';

List<String> timeDifferenceInHours(String startTime, String endTime) {
  List<int> startComponents = startTime.split(':').map(int.parse).toList();
  List<int> endComponents = endTime.split(':').map(int.parse).toList();

  int startMinutes = startComponents[0] * 60 + startComponents[1];
  int endMinutes = endComponents[0] * 60 + endComponents[1];

  int differenceInMinutes = endMinutes - startMinutes;

  int hourDifference = differenceInMinutes ~/ 60;
  int minuteDifference = differenceInMinutes % 60;

  return [
    hourDifference == 0 ? "" : "${hourDifference}h",
    minuteDifference == 0 ? "" : " ${minuteDifference}m",
  ];
}

class CalendarList extends StatelessWidget {
  final List<Calendar> calendars;
  final DateTime currentDate;
  final Function(BuildContext, String) onRemoveCalendar;
  final Function(BuildContext, Calendar) onUpdateCalendar;

  const CalendarList({
    super.key,
    required this.calendars,
    required this.currentDate,
    required this.onRemoveCalendar,
    required this.onUpdateCalendar,
  });

  void _showDescription(
    BuildContext ctx,
    Calendar calendar,
  ) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        final isTime = calendar.start != "";
        late List<String> timeD = [];
        if (isTime) {
          timeD = timeDifferenceInHours(calendar.start, calendar.end);
        }
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(
            isTime
                ? "${calendar.title} (${timeD[0]}${timeD[1]})"
                : calendar.title,
            style: Theme.of(ctx).textTheme.bodyLarge,
          ),
          content: Text(calendar.description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: ctx,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.opaque,
                      child: CalendarForm(
                        currentDate: currentDate,
                        initCalendar: calendar,
                        onSubmit: (calendar) {
                          onUpdateCalendar(
                              ctx, calendar); // WTF the context is wrong
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: calendars.length,
      itemBuilder: (context, index) {
        final item = calendars[index];
        return Dismissible(
          onDismissed: (_) {
            onRemoveCalendar(context, item.id);
          },
          direction: DismissDirection.endToStart,
          key: ValueKey(item.id),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.red,
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.delete_rounded,
                color: Colors.white,
              ),
            ),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () => _showDescription(
              context,
              item,
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: item.start != ""
                ? Text(
                    "${item.start} ~ ${item.end}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )
                : const SizedBox.shrink(),
            subtitle: Text(
              item.description,
              style: const TextStyle(
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
