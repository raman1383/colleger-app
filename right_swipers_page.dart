import 'package:flutter/material.dart';

class RightSwipers extends StatefulWidget {
  const RightSwipers({super.key});

  @override
  State<RightSwipers> createState() => _RightSwipersState();
}

class _RightSwipersState extends State<RightSwipers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("who right swiped on you"),
      ),
      body: const Center(
        child: Text("profiles of those who right swiped on you"),
      ),
    );
  }
}
