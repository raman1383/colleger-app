import 'package:flutter/material.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

// view the ones liked and sent gift to you(priority based of number of likes then number of roses)
// see their profile and which part they liked/commented on your profile

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifs"),
      ),
      body: const Center(child: Text("notifications")),
    );
  }
}
