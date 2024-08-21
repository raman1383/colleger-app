import 'package:colleger/main.dart';
import 'package:colleger/screens/login_page.dart';
import 'package:colleger/screens/signup.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';

// phoneNumber and pass, or sign-up

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// File? testImage;

class _LoginState extends State<Login> {
  // Future<String> uploadImage(File imageFile) async {
  //   var uri = Uri.parse('http://dl.colleger.ir/FTP_up.php');
  //   var request = http.MultipartRequest('POST', uri)
  //     ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     // Read the response stream and convert it to a string
  //     String responseString = await response.stream.bytesToString();
  //     return responseString;
  //   } else {
  //     throw Exception('Failed to upload image');
  //   }
  // }

  TextEditingController phone_number_field = TextEditingController();
  TextEditingController password_field = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Colleger",
            style: TextStyle(
              fontFamily: "Silkscreen",
              color: greenShade,
              fontSize: 40,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: devWidth,
            // height: devHeight * 0.25,
          ),
          GestureDetector(
            onTap: () async {
              String likersQuery = "SELECT * FROM `users`";
              String strings = await executeQuery(likersQuery);
              print(strings);

              String sysFillQuery =
                  "SELECT (user_id) FROM users WHERE  LIMIT 5";
              List<String> strings2 = await getBulkSql(sysFillQuery, "user_id");
              print(strings2);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: devHeight * 0.1,
              width: devWidth * 0.2,

              // color: Colors.greenAccent,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "./assets/logo.jpeg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: devHeight * 0.05,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const SizedBox(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(55),
              //   border: Border.all(width: 4),
              //   gradient: const LinearGradient(
              //     colors: [Colors.black, greenShade],
              //     begin: Alignment.topRight,
              //     end: Alignment.topLeft,
              //   ),
              // ),
              // height: devHeight * 0.1,
              // width: devWidth * 0.55,
              child: Center(
                child: Text(
                  "ورود ",
                  style: TextStyle(
                    color: greenShade,
                    fontWeight: FontWeight.w700,
                    fontSize: 27,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: devHeight * 0.05,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
            },
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: const LinearGradient(
              //     colors: [Colors.black, greenShade],
              //     begin: Alignment.topLeft,
              //     end: Alignment.topRight,
              //   ),
              //   borderRadius: BorderRadius.circular(55),
              // ),
              // height: devHeight * 0.1,
              // width: devWidth * 0.55,
              child: const Center(
                child: Text(
                  "ثبت نام",
                  style: TextStyle(
                    color: greenShade,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
