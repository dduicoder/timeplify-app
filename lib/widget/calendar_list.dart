import 'package:flutter/material.dart';
import 'package:timeplifey/models/calendar.dart';

class CalendarList extends StatelessWidget {
  final List<Calendar> calendars;
  final Function(BuildContext, String) onRemoveCalendar;

  const CalendarList({
    super.key,
    required this.calendars,
    required this.onRemoveCalendar,
  });

  void _showDescription(
    BuildContext ctx,
    String title,
    String description,
  ) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: Theme.of(ctx).textTheme.bodyLarge,
          ),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Pomodoro"),
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
              item.title,
              item.description,
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              "${item.start} ~ ${item.end}",
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
          ),
        );
      },
    );
  }
}
