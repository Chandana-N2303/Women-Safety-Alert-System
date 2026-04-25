import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;
  int secondsLeft = 0;

  void startTimer(int minutes) {
    timer?.cancel();

    setState(() {
      secondsLeft = minutes * 60;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        t.cancel();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Safety Check"),
              content: const Text("Are you safe?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Yes, I'm Safe"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("SOS Triggered")),
                    );
                  },
                  child: const Text("Send SOS"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void cancelTimer() {
    timer?.cancel();
    setState(() {
      secondsLeft = 0;
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              formatTime(secondsLeft),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => startTimer(1),
                child: const Text('Start 1 Minute Timer'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => startTimer(5),
                child: const Text('Start 5 Minute Timer'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cancelTimer,
                child: const Text('Cancel Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}