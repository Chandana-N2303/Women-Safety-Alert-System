import 'package:flutter/material.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.call,
              color: Colors.green,
              size: 90,
            ),
            const SizedBox(height: 20),
            const Text(
              'Incoming Call',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Call answered'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}