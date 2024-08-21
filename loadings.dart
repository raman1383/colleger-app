import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HeartLoading extends StatelessWidget {
  const HeartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SpinKitPumpingHeart(
          color: Colors.red,
          size: 50.0,
        ),
        Text(
          "LOADING...",
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
