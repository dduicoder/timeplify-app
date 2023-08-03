import 'package:flutter/material.dart';

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
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Timeplifey",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: _mainPages[index]["page"] as Widget,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: _mainPages
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(
                    (index == _mainPages.indexOf(e)
                        ? e["selctedIcon"]
                        : e["initialIcon"]) as IconData,
                  ),
                  label: e["title"] as String,
                ),
              )
              .toList(),
          elevation: 10,

          // backgroundColor: const Color.fromRGBO(255, 255, 255, 0.75),
          currentIndex: index,
          selectedItemColor: Colors.black,
          onTap: (int newIndex) {
            setState(
              () => index = newIndex,
            );
          },
        ),
      ),
    );
  }
}
