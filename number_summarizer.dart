import 'package:colleger/main.dart';
import 'package:flutter/material.dart';

Widget number_summarizer(
    double totalPoints, double numbersFontSize, double letterFontSize) {
  // 0-999.99
  if (totalPoints <= 999.9999) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          totalPoints.toStringAsFixed(0).toString(),
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
      ],
    );
  }
  // 999.99-9999.99
  if (totalPoints > 999.999 && totalPoints <= 9999.999) {
    double x = (totalPoints / 1000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "K",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 9999.999 && totalPoints <= 99999.999) {
    double x = (totalPoints / 1000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "K",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 99999.999 && totalPoints <= 999999.999) {
    double x = (totalPoints / 1000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}${x.toString()[4]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "K",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 999999.999 && totalPoints <= 9999999.999) {
    double x = (totalPoints / 1000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "M",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 9999999.999 && totalPoints <= 99999999.999) {
    double x = (totalPoints / 1000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "M",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 99999999.999 && totalPoints <= 999999999.999) {
    double x = (totalPoints / 1000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}${x.toString()[4]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "M",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 999999999.999 && totalPoints <= 9999999999.999) {
    double x = (totalPoints / 1000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "B",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 9999999999.999 && totalPoints <= 99999999999.999) {
    double x = (totalPoints / 1000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "B",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 99999999999.999 && totalPoints <= 999999999999.999) {
    double x = (totalPoints / 1000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}${x.toString()[4]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "B",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 999999999999.999 && totalPoints <= 9999999999999.999) {
    double x = (totalPoints / 1000000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "T",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 9999999999999.999 && totalPoints <= 99999999999999.999) {
    double x = (totalPoints / 1000000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "T",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }
  if (totalPoints > 99999999999999.999 && totalPoints <= 999999999999999.999) {
    double x = (totalPoints / 1000000000000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${x.toString()[0]}${x.toString()[1]}${x.toString()[2]}${x.toString()[3]}${x.toString()[4]}",
          style: TextStyle(
            fontSize: numbersFontSize,
            fontFamily: "Silkscreen",
            color: greenShade,
          ),
        ),
        Text(
          "T",
          style: TextStyle(
            fontSize: letterFontSize,
            fontFamily: "Silkscreen",
            color: Colors.red,
          ),
        )
      ],
    );
  }

  return const Text("NO SHIT");
}
