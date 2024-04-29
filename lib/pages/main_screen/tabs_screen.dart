import 'package:flutter/material.dart';
import 'package:timeplifey/pages/main_screen/note_screen.dart';

import '../../pages/account_screen.dart';
import '../../pages/main_screen/calendar_screen.dart';
import '../../pages/main_screen/pomodoro_screen.dart';
import '../../pages/notification_screen.dart';
import '../../pages/settings_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  static const List<Map<String, Object>> _appBarPages = [
    {
      "url": NotificationScreen.routeName,
      "icon": Icons.notifications_rounded,
    },
    {
      "url": AccountScreen.routeName,
      "icon": Icons.person_rounded,
    },
    {
      "url": SettingsScreen.routeName,
      "icon": Icons.settings_rounded,
    },
  ];

  static const List<Map<String, Object>> _mainPages = [
    {
      "page": CalendarScreen(),
      "title": "Calendar",
      "selctedIcon": Icons.calendar_today,
      "initialIcon": Icons.calendar_today_outlined,
    },
    {
      "page": PomodoroScreen(),
      "title": "Pomodoro",
      "selctedIcon": Icons.watch_later_rounded,
      "initialIcon": Icons.watch_later_outlined,
    },
    {
      "page": NoteScreen(),
      "title": "Note",
      "selctedIcon": Icons.note_alt_rounded,
      "initialIcon": Icons.note_alt_outlined,
    },
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeplify"),
        actions: _appBarPages
            .map(
              (e) => IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(e["url"] as String);
                },
                icon: Icon(e["icon"] as IconData),
              ),
            )
            .toList(),
      ),
      body: _mainPages[_index]["page"] as Widget,
      extendBody: true,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.025),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            items: _mainPages
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(
                      (_index == _mainPages.indexOf(e)
                          ? e["selctedIcon"]
                          : e["initialIcon"]) as IconData,
                    ),
                    label: e["title"] as String,
                  ),
                )
                .toList(),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.75),
            currentIndex: _index,
            selectedItemColor: Colors.black,
            onTap: (int newIndex) {
              setState(
                () => _index = newIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
