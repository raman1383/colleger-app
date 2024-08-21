import 'package:bcrypt/bcrypt.dart';
import 'package:colleger/main.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//! TODO: FORGOT PASS? enter phone number and enter sent code

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginPassField = TextEditingController();
  TextEditingController loginUsernameField = TextEditingController();
  String loginUsername = "";
  String loginPass = "";

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: devWidth,
              height: devHeight * 0.12,
            ),
            Container(
              height: devHeight * 0.1,
              width: devWidth * 0.66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(color: greenShade, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "colleger ID"),
                  controller: loginUsernameField,
                ),
              ),
            ),
            SizedBox(
              height: devHeight * 0.06,
            ),
            Container(
              height: devHeight * 0.1,
              width: devWidth * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(color: greenShade, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "pass"),
                  controller: loginPassField,
                ),
              ),
            ),
            SizedBox(
              height: devHeight * 0.1,
            ),
            GestureDetector(
              onTap: () async {
                var x = await executeQuery(
                    "SELECT password_hash FROM users WHERE user_name='${loginUsernameField.text}';");
                print("->  $x");

                if (x != "No results found.") {
                  // var hash =
                  //     BCrypt.hashpw(loginPassField.text, BCrypt.gensalt());

                  final bool checkPassword = BCrypt.checkpw(
                    loginPassField.text,
                    x,
                  );
                  print("***#");
                  if (checkPassword) {
                    print("***");
                    print(x);
                    print(loginPassField.text);
                    // get user_id, save to shared_prefs,
                    var userId = await executeQuery(
                        "SELECT user_id FROM users WHERE user_name='${loginUsernameField.text}';");

                    userObj = await fillUserObj(int.parse(userId));
                    print(userObj);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setInt("user_id", int.parse(userId));
                    await prefs.setString(
                        "password_hash", userObj["password_hash"]);

                    print("Prefs saved");

                    print(prefs.getInt("user_id"));
                    await fillUserObj(prefs.getInt("user_id")!);
                    print(prefs.getString("password_hash"));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
                  }
                }
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 50,
                color:
                    //&& loginUsernameField.text.length >= 3
                    (loginPassField.text.isNotEmpty) ? greenShade : Colors.grey,
              ),
            ),
            SizedBox(
              height: devHeight * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
