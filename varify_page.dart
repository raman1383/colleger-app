import 'package:colleger/main.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("گرفتن تیک سبز"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: devHeight * 0.05,
            width: devWidth,
          ),
          const Text(
            "یه سلفی مثل حالت عکس پایین\n               از خودت بگیر",
            style: TextStyle(fontSize: 30),
          ),
          const Text(
            "این عکست با عکسای پروفایلت مقایسه میشه تا تایید کنیم ",
            style: TextStyle(fontSize: 30),
          ),
          const Text(
            "باید اشتراک داشته باشی!",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: devHeight * 0.1,
          ),
          Image.asset(
            "./assets/Screenshot 2024-03-08 174131.png",
          ),
          SizedBox(
            height: devHeight * 0.1,
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              decoration: BoxDecoration(
                color: greenShade,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "انتخاب از گالری و ارسال",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
