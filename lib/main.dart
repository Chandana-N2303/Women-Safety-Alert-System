import 'dart:async';
import 'package:flutter/material.dart';
import 'contacts_screen.dart';
import 'timer_screen.dart';
import 'fake_call_screen.dart';
import 'settings_screen.dart';
import 'services/sos_service.dart';

void main() {
  runApp(const WomenSafetyApp());
}

class WomenSafetyApp extends StatelessWidget {
  const WomenSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Safety App',
      theme: ThemeData(
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> triggerSOS(BuildContext context) async {
    bool cancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int seconds = 5;

        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(seconds: 1), () {
              if (seconds > 0) {
                seconds--;
                setState(() {});
              } else if (!cancelled) {
                Navigator.pop(context);
                sendSOS(context);
              }
            });

            return AlertDialog(
              title: const Text("SOS Countdown"),
              content: Text("Sending SOS in $seconds seconds"),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelled = true;
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> sendSOS(BuildContext context) async {
    String message = await SOSService.triggerSOS();

    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showFakeCallTimeDialog(BuildContext context) {
    int selectedSeconds = 10;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text("Set Fake Call Time"),
              content: DropdownButtonFormField<int>(
                value: selectedSeconds,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 10, child: Text("10 seconds")),
                  DropdownMenuItem(value: 30, child: Text("30 seconds")),
                  DropdownMenuItem(value: 60, child: Text("1 minute")),
                  DropdownMenuItem(value: 120, child: Text("2 minutes")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSeconds = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    String timeText;
                    if (selectedSeconds == 60) {
                      timeText = "1 minute";
                    } else if (selectedSeconds == 120) {
                      timeText = "2 minutes";
                    } else {
                      timeText = "$selectedSeconds seconds";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Fake call will come in $timeText"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    Timer(Duration(seconds: selectedSeconds), () {
                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FakeCallScreen(),
                        ),
                      );
                    });
                  },
                  child: const Text("Start"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Icon(
              Icons.security,
              size: 80,
              color: Colors.pink,
            ),

            const SizedBox(height: 10),

            const Text(
              "Women Safety App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.warning),
              label: const Text(
                "SOS",
                style: TextStyle(fontSize: 22),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 70),
              ),
              onPressed: () => triggerSOS(context),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.contacts),
              label: const Text("Trusted Contacts"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.timer),
              label: const Text("Safety Timer"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimerScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text("Fake Call"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                showFakeCallTimeDialog(context);
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text("Settings"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
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