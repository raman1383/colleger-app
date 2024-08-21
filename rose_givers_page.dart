import 'package:flutter/material.dart';

class RoseGivers extends StatefulWidget {
  const RoseGivers({super.key});

  @override
  State<RoseGivers> createState() => _RoseGiversState();
}

class _RoseGiversState extends State<RoseGivers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("who gave you roses"),
      ),
      body: const Center(
        child: Text(
            "who gave you roses and how many rose do you have to give(number of roses in circulation will increase, a rose sent form A is a rose gotten by B and sendable to C)"),
      ),
    );
  }
}
