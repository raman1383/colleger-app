import 'package:colleger/screens/profile.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

//! able to update location

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("settings"),
        ),
        // child: Text("settings/ logins and outs, age and proxy preferences"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            viewerIsOwner
                ? Column(
                    children: [
                      const Text("محدوده سنی کسایی که بهت نشون میدیم"),
                      Container(
                        color: Colors.amber,
                        height: 100,
                        child: Row(children: [
                          RangeSlider(
                            min: 18,
                            max: 50,
                            values: const RangeValues(18, 50),
                            onChanged: (value) {},
                          )
                        ]),
                      ),
                    ],
                  )
                : Container(),
            GestureDetector(
              onTap: () {
                //wipe shared_prefs
                //nav to login/signin
              },
              child: Container(
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                      Text(
                        "log out",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ]),
              ),
            )
          ],
        ));
  }
}
