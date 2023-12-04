import 'package:flutter/material.dart';
import 'dart:async';

class PomodoroScreen extends StatefulWidget {
  static const routeName = "/pomodoro";
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const waitTime = 60 * 25;
  int _totalCounts = 0;
  int _totalSeconds = waitTime;
  bool _isPlaying = false;
  late Timer _timer;

  late double _opacity = 0.5;

  void _onTick(Timer timer) {
    setState(() {
      if (_totalSeconds == 0) {
        timer.cancel();
        _totalSeconds = waitTime;
        _totalCounts += 1;
        _isPlaying = false;
      } else {
        _totalSeconds -= 1;
      }
    });
  }

  void _onReset() {
    if (_isPlaying) {
      _timer.cancel();
    }

    setState(() {
      _isPlaying = false;
      _totalSeconds = waitTime;
    });
  }

  void _onPlay() {
    if (!_isPlaying) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        _onTick,
      );
    } else {
      _timer.cancel();
    }

    setState(() {
      _isPlaying = !_isPlaying;
      _opacity = _opacity == 0.5 ? 0.25 : 0.5;
    });
  }

  void _onSkip() {
    if (_totalSeconds >= 60 * 15) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "You can't skip until 10 minutes have passed.",
          ),
          duration: const Duration(milliseconds: 3000),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    if (_isPlaying) {
      _timer.cancel();
    }

    setState(() {
      _isPlaying = false;
      _totalSeconds = waitTime;
      _totalCounts += 1;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void dispose() {
    if (_isPlaying) {
      _timer.cancel();
    }
    _isPlaying = false;
    _totalSeconds = waitTime;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pomodoro",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: _onPlay,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, _opacity),
                      width: 16,
                    ),
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(145, 150, 255, 0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        format(_totalSeconds),
                        style: const TextStyle(
                          fontSize: 48,
                          letterSpacing: -2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isPlaying ? "Lets go!" : "Take your time",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    onPressed: _onReset,
                    icon: const Icon(
                      Icons.restore,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    iconSize: 80,
                    onPressed: _onPlay,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    onPressed: _onSkip,
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "$_totalCounts Pomodoros yet",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
