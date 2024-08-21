import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:colleger/main.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// first&last name, gender, birthday, phone/confirm-SMS , and pass(double confirm), pics

// class InvitedBy extends StatefulWidget {
//   const InvitedBy({super.key});

//   @override
//   State<InvitedBy> createState() => _InvitedByState();
// }

// TextEditingController textEditingController = TextEditingController();

// Future<bool> usernameExists(String userName) async {
//   print("------------------------------");
//   print(userName);
//   String query = "SELECT COUNT(*) FROM users WHERE user_name = '$userName';";
//   var res = await executeQuery(query);
//   print(res);

//   if (res.contains("1")) {
//     return true;
//   }
//   return false;
// }

// bool valid = false;
// bool pending = false;
// bool invalid = true;

// class _InvitedByState extends State<InvitedBy> {
//   @override
//   Widget build(BuildContext context) {
//     var devHeight = MediaQuery.of(context).size.height;
//     var devWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               width: devWidth,
//               height: devHeight * 0.2,
//             ),
//             const Text(
//               "کالجر آیدی کسی که دعوتت کرده",
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(
//               height: devHeight * 0.02,
//             ),
//             Container(
//               height: devHeight * 0.1,
//               width: devWidth * 0.7,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: greenShade,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     left: 25, right: 25, top: 20, bottom: 20),
//                 child: TextField(
//                   onChanged: (value) async {
//                     print("....awaiting....");
//                     setState(() {
//                       invalid = true;
//                       pending = true;
//                       valid = false;
//                     });
//                     print("awaiting....");
//                     //check existence of id
//                     bool x = await usernameExists(value);
//                     print("....");
//                     print(x);
//                     if (x == true) {
//                       print("object");
//                       setState(() {
//                         valid = true;
//                         pending = false;
//                         invalid = false;
//                       });
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignUp(),
//                         ),
//                       );
//                     } else {
//                       setState(() {
//                         valid = false;
//                         pending = false;
//                         invalid = true;
//                       });
//                     }
//                   },
//                   decoration: const InputDecoration(
//                       prefix: Text(
//                     "@ ",
//                     style: TextStyle(
//                       color: greenShade,
//                       fontSize: 20,
//                     ),
//                   )),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: devHeight * 0.05,
//             ),
//             GestureDetector(
//               onTap: () {
//                 if (invalid == false && pending == false && valid == true) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SignUp(),
//                     ),
//                   );
//                 }
//               },
//               child: invalid == true && pending == false && valid == false
//                   ? const Icon(
//                       Icons.radio_button_checked_sharp,
//                       color: Colors.red,
//                       size: 40,
//                     )
//                   : invalid == false && pending == true && valid == false
//                       ? const Icon(
//                           Icons.circle_outlined,
//                           color: Colors.yellow,
//                           size: 40,
//                         )
//                       : invalid == false && pending == false && valid == true
//                           ? const Icon(
//                               Icons.check_circle_sharp,
//                               color: greenShade,
//                               size: 40,
//                             )
//                           : Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

File? _selected_image;
String username_feedback = "";
String date = "";
Jalali dateJ = Jalali.now();
TextEditingController phone_number_field = TextEditingController();
TextEditingController name_field = TextEditingController();
TextEditingController pass_field = TextEditingController();
TextEditingController pass_field_repeat = TextEditingController();
TextEditingController username_field = TextEditingController();
TextEditingController verification_code = TextEditingController();
bool is_male = false;
bool gender_selected = false;
bool picked_username = true;
bool tooLongFirstName = false;
bool usernameTooShort = false;
bool passTooShort = false;
bool usernameTooLong = false;
bool awaitingSignUp = false;
bool agreeWithTermsOfUse = false;
bool phoneNumberAlreadyExists = false;
(String, String) location = ("", "");

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.22,
            ),
            const Icon(
              Icons.flag_circle,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.1,
                //   width: MediaQuery.of(context).size.width * 0.45,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(55),
                //     border: Border.all(color: greenShade, width: 2),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 20.0, right: 20),
                //     child: TextField(
                //       controller: last_name_field,
                //       textAlign: TextAlign.center,
                //       onChanged: (value) {
                //         if (last_name_field.text.length > 20) {
                //           setState(() {
                //             tooLongLastName = true;
                //           });
                //         } else {
                //           setState(() {
                //             tooLongLastName = false;
                //           });
                //         }
                //       },
                //       decoration: InputDecoration(
                //         hintText: " نام خانوادگی",
                //         helperText: tooLongLastName ? "  بیش از حد طولانی" : "",
                //         helperStyle: const TextStyle(
                //           color: Colors.red,
                //           fontSize: 15,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(color: greenShade, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) {
                        if (name_field.text.length > 20) {
                          setState(() {
                            tooLongFirstName = true;
                          });
                        } else {
                          setState(() {
                            tooLongFirstName = false;
                          });
                        }
                      },
                      controller: name_field,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "نام",
                        helperText:
                            tooLongFirstName ? "  بیش از حد طولانی" : "",
                        helperStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                //!
                //TODO: username, auto suggest based on name and birthdate
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final Jalali? dateSelected = await showPersianDatePicker(
                      context: context,
                      initialDate: Jalali(1380),
                      firstDate: Jalali(130),
                      lastDate: Jalali.now(),
                    );
                    if (dateSelected != null) {
                      setState(() {
                        date = dateSelected.formatCompactDate();
                        dateJ = dateSelected;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: greenShade, width: 2),
                        borderRadius: BorderRadius.circular(40)),
                    height: MediaQuery.of(context).size.height * 0.092,
                    width: MediaQuery.of(context).size.width * 0.4,
                    // color: Colors.cyanAccent,
                    child: Center(
                      child: Text(
                        date == "" ? "تاریخ تولد" : date,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                //!
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: greenShade, width: 2),
                      borderRadius: BorderRadius.circular(40)),
                  height: MediaQuery.of(context).size.height * 0.092,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: PopupMenuButton(
                    iconSize: 35,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(
                                Icons.male,
                                size: 40,
                              ),
                              Text(
                                "  مذکر",
                                style: TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              is_male = true;
                              gender_selected = true;
                            });
                          }),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.female,
                              size: 40,
                            ),
                            Text(
                              "  مونث",
                              style: TextStyle(fontSize: 40),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            is_male = false;
                            gender_selected = true;
                          });
                        },
                      ),
                    ],
                    child: gender_selected
                        ? is_male
                            ? const Icon(
                                Icons.male,
                                size: 40,
                              )
                            : const Icon(
                                Icons.female,
                                size: 40,
                              )
                        : const Center(
                            child: Text(
                            "جنسیت",
                            style: TextStyle(fontSize: 19),
                          )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            !((Jalali.now().year - dateJ.year) >= 18) && date != ""
                ? const Text(
                    " استفاده فقط برای افراد 18+ سال مجاز است",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : Container(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            GestureDetector(
              onTap: () {
                gender_selected &&
                        name_field.text.isNotEmpty &&
                        (Jalali.now().year - dateJ.year) >= 18
                    // (Jalali.now().year - dateJ.year) < 18
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const SecondPageSignUp()),
                      ))
                    : null;

                print("${name_field.text}--$date--$is_male");
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 50,
                color: gender_selected &&
                        name_field.text.isNotEmpty &&
                        !tooLongFirstName &&
                        (Jalali.now().year - dateJ.year) >= 18
                    // (Jalali.now().year - dateJ.year) < 18
                    ? greenShade
                    : Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: phone number and verification must have its own page

class SecondPageSignUp extends StatefulWidget {
  const SecondPageSignUp({super.key});

  @override
  State<SecondPageSignUp> createState() => _SecondPageSignUpState();
}

class _SecondPageSignUpState extends State<SecondPageSignUp> {
  int timeLeftInSecs = 32;
  bool completelyEnteredPhone = false;
  bool activateReSend = false;
  bool hitSendVerificationCode = false;

  void _startCountDown(bool isReset) {
    if (isReset) {
      setState(() {
        timeLeftInSecs = 32;
      });
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        //TODO : render re-sent button

        if (timeLeftInSecs == 0) {
          timer.cancel();
        } else {
          timeLeftInSecs--;
        }
      });
    });
  }

  final Random _random =
      Random(); // Create a Random object for generating random numbers
  int _randomNumber = 0;
  // Method for generating a random 4 digit number
  void generateRandomNumber() {
    setState(
      () {
        _randomNumber =
            1000 + _random.nextInt(9000); // Generates a random 4-digit number
      },
    );
  }

  void sendVerificationCodeViaSMS(int code, String targetPhoneNumber) {
    //TODO: send code to targetPhoneNumber via SMS API
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.22,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.flag_circle,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: devWidth,
            height: devHeight * 0.2,
          ),
          // const Padding(
          //   padding: EdgeInsets.only(bottom: 8.0),
          //   child: Text(
          //     "به کاربران دیگر نشان داده نمیشود",
          //     style: TextStyle(
          //       fontSize: 19,
          //       color: Colors.red,
          //     ),
          //   ),
          // ),
          Container(
            // height: devHeight * 0.092,
            width: devWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55),
              border: Border.all(color: greenShade, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 3),
              child: TextField(
                onChanged: (value) async {
                  if (phone_number_field.text.length == 11 &&
                      phone_number_field.text[0] == "0" &&
                      phone_number_field.text[1] == "9") {
                    //TODO: check if entered phone number does not already exist in DB

                    String x = await executeQuery(
                        "SELECT COUNT(*) FROM users WHERE phone_number = '$value';");
                    if (x != "0") {
                      setState(() {
                        phoneNumberAlreadyExists = true;
                      });
                    } else {
                      setState(() {
                        phoneNumberAlreadyExists = false;
                      });
                    }
                  }
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 11,
                decoration: InputDecoration(
                  helperText: phoneNumberAlreadyExists
                      ? "این شماره تلفن دارای حساب کاربری است"
                      : "OK",
                  hintText: "09XXXXXXXXX :شماره موبایل",
                ),
                controller: phone_number_field,
              ),
            ),
          ),
          SizedBox(
            height: devHeight * 0.071,
          ),

          //TODO: on phone_number submit, generate randow 4-digit code and SMS it by API, start timer, check entered code

          hitSendVerificationCode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: devHeight * 0.08,
                      width: devWidth * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        border: Border.all(color: greenShade, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 3),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 4,
                          decoration: const InputDecoration(
                            hintText: "_  _  _  _",
                          ),
                          onChanged: (value) {
                            //TODO: if entered code is valid, push next page

                            if (verification_code.text ==
                                _randomNumber.toString()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ThirdPageSIgnUp(),
                                ),
                              );
                            }
                          },
                          controller: verification_code,
                        ),
                      ),
                    ),
                    //!
                    SizedBox(
                      width: devWidth * 0.04,
                    ),
                    timeLeftInSecs != 0
                        ? Text(
                            timeLeftInSecs.toString(),
                            style: const TextStyle(
                              fontSize: 19,
                              color: greenShade,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              //TODO: re-generate and re-send verification code and reset countdown

                              _startCountDown(true);
                              generateRandomNumber();
                              print(_randomNumber);
                              sendVerificationCodeViaSMS(
                                  _randomNumber, phone_number_field.text);
                            },
                            child: const Icon(
                              Icons.replay,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                    SizedBox(
                      height: devHeight * 0.05,
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    phone_number_field.text.length == 11 &&
                            phoneNumberAlreadyExists == false &&
                            phone_number_field.text[0] == "0" &&
                            phone_number_field.text[1] == "9"
                        ? setState(() {
                            generateRandomNumber();
                            print(_randomNumber);
                            _startCountDown(false);
                            hitSendVerificationCode = true;
                            sendVerificationCodeViaSMS(
                                _randomNumber, phone_number_field.text);
                          })
                        : null;
                  },
                  child: Icon(
                    Icons.check_circle,
                    color: phone_number_field.text.length == 11 &&
                            phone_number_field.text[0] == "0" &&
                            phone_number_field.text[1] == "9"
                        ? greenShade
                        : Colors.grey,
                    size: 40,
                  ),
                ),
          SizedBox(
            height: devHeight * 0.02,
          ),

          SizedBox(
            height: devHeight * 0.05,
          ),
          GestureDetector(
            onTap: () {
              verification_code.text == _randomNumber.toString()
                  // (Jalali.now().year - dateJ.year) < 18
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ThirdPageSIgnUp()),
                    ))
                  : null;
            },
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 50,
              color: verification_code.text == _randomNumber.toString()
                  // (Jalali.now().year - dateJ.year) < 18
                  ? greenShade
                  : Colors.white30,
            ),
          ),
        ]),
      ),
    );
  }
}

class ThirdPageSIgnUp extends StatefulWidget {
  const ThirdPageSIgnUp({super.key});

  @override
  State<ThirdPageSIgnUp> createState() => _ThirdPageSIgnUpState();
}

class _ThirdPageSIgnUpState extends State<ThirdPageSIgnUp> {
  bool usernameAvailable = true;
  bool obscurePassFields = true;

  //TODO: make user unable to move forward with taken username

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: devWidth * 0.25,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.flag_circle,
              color: greenShade,
            ),
            const Icon(
              Icons.circle_outlined,
              color: greenShade,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: devWidth,
              height: devHeight * 0.1,
            ),
            Column(
              children: [
                Container(
                  height: devHeight * 0.095,
                  width: devWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(color: greenShade, width: 2),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
                    child: TextField(
                      //TODO: username_feedback as tooltip

                      controller: username_field,
                      textAlign: TextAlign.center,
                      // maxLength: 20,
                      decoration: InputDecoration(
                        helperText: usernameTooShort
                            ? usernameAvailable
                                ? usernameTooLong
                                    ? "بیش از حد طولانی  "
                                    : "      OK"
                                : "     ! $username_feedback !"
                            : "   حداقل 3 حرف",
                        helperStyle: TextStyle(
                            color: usernameTooShort
                                ? usernameAvailable
                                    ? usernameTooLong
                                        ? Colors.red
                                        : Colors.green
                                    : Colors.red
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        hintText: "ID : ",
                        prefix: const Text("@"),
                      ),
                      onChanged: (value) async {
                        // print("---------------");
                        // print(checkSqlQueryParameterSecurity(
                        //     username_field.text));
                        // print("---------------");

                        if (username_field.text.trim().length >= 3) {
                          setState(() {
                            usernameTooShort = true;
                          });
                        } else {
                          setState(() {
                            usernameTooShort = false;
                          });
                        }
                        if (username_field.text.trim().length >= 20) {
                          setState(() {
                            usernameTooLong = true;
                          });
                        } else {
                          setState(() {
                            usernameTooLong = false;
                          });
                        }
                        print("#####");
                        print(await checkUsernameAvailability(
                            username_field.text));
                        print("#####");
                        if (await checkUsernameAvailability(
                            username_field.text)) {
                          setState(() {
                            usernameAvailable = false;
                            username_feedback = "! گرفته شده !";
                          });
                        } else {
                          setState(() {
                            usernameAvailable = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, right: devWidth * 0.13, left: devWidth * 0.13),
                  child: const Column(
                    children: [
                      Text(
                        "با داشتن آیدی کالجر, کاربرای دیگه بدون نیاز به شماره تلفن میتونن باهات در ارتباط باشن",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Aa-Zz , _ , 1-9",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: devHeight * 0.05,
            ),
            Column(
              children: [
                Container(
                  height: devHeight * 0.095,
                  width: devWidth * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(color: greenShade, width: 2),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 3),
                    child: TextField(
                      obscureText: obscurePassFields,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(hintText: " تعیین رمز"),
                      controller: pass_field,
                      onChanged: (value) {
                        if (pass_field.text.trim().length < 8) {
                          setState(() {
                            passTooShort = true;
                          });
                        } else {
                          setState(() {
                            passTooShort = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
                passTooShort
                    ? const Text(
                        "حداقل 8 کاراکتر",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: devHeight * 0.07,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscurePassFields = !obscurePassFields;
                    });
                  },
                  child: Text(
                    obscurePassFields ? "🙈" : "😃",
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
            Container(
              height: devHeight * 0.095,
              width: devWidth * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(color: greenShade, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 3),
                child: TextField(
                  onChanged: (value) {
                    if (username_field.text.trim().length >= 3 &&
                        pass_field.text == pass_field_repeat.text) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const ForthSignUpPage()),
                        ),
                      );
                    }
                  },
                  obscureText: obscurePassFields,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: " تکرار رمز"),
                  controller: pass_field_repeat,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            GestureDetector(
              onTap: () {
                username_field.text.trim().length >= 3 &&
                        pass_field.text == pass_field_repeat.text &&
                        usernameAvailable
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const ForthSignUpPage()),
                        ),
                      )
                    : null;
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 50,
                color: username_field.text.trim().length >= 3 &&
                        pass_field.text == pass_field_repeat.text &&
                        usernameAvailable
                    // (Jalali.now().year - dateJ.year) < 18
                    ? greenShade
                    : Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForthSignUpPage extends StatefulWidget {
  const ForthSignUpPage({super.key});

  @override
  State<ForthSignUpPage> createState() => _ForthSignUpPageState();
}

class _ForthSignUpPageState extends State<ForthSignUpPage> {
  late String lat, long;
  Future<Position> _getLocation() async {
    bool servicesEnabled = await Geolocator.isLocationServiceEnabled();

    if (!servicesEnabled) {
      return Future.error("location services are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("location access denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("location permissions denied forever");
    }
    var x = await Geolocator.getCurrentPosition();

    setState(() {
      location = (x.altitude.toString(), x.longitude.toString());
    });
    return x;
  }

  Future getProfilePhoto(bool fromGallery) async {
    bool accessGallery = await Permission.photos.request().isGranted;
    bool accessCamera = await Permission.camera.request().isGranted;
    final ImagePicker picker = ImagePicker();

    if (fromGallery && accessGallery) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Do something with the picked image file (e.g., display it)
        // pickedFile.path gives you the path of the picked image
        setState(() {
          _selected_image = pickedFile as File?;
        });
      }
    } else if (!fromGallery && accessCamera) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        // Do something with the picked image file (e.g., display it)
        // pickedFile.path gives you the path of the picked image
        setState(() {
          _selected_image = pickedFile as File?;
        });
      }
    } else {
      print("nothing selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: devWidth * 0.25,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: greenShade,
            ),
            const Icon(
              Icons.flag_circle,
              color: greenShade,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: devWidth,
              height: _selected_image == null ? devHeight * 0.16 : 0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11, right: 11),
              child: Container(
                // height: devHeight * 0.5,
                // width: devWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: greenShade, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: _selected_image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                is_male
                                    ? "😅😉یه عکس از خودت که دخترارو دیوونت کنه "
                                    : "😅😉یه عکس از خودت که پسرارو دیوونت کنه ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final picker = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (picker != null) {
                                        setState(() {
                                          _selected_image = File(picker.path);
                                        });
                                      } else {
                                        null;
                                      }
                                    },
                                    child: const Icon(
                                      Icons.photo,
                                      size: 50,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final picker = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (picker != null) {
                                        setState(() {
                                          _selected_image = File(picker.path);
                                        });
                                      } else {
                                        null;
                                      }
                                    },
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                height: devHeight * 0.49,
                                width: devWidth * 0.79,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.file(
                                  _selected_image!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selected_image = null;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Icon(
                                    Icons.highlight_remove_sharp,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: devHeight * 0.02,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  agreeWithTermsOfUse = !agreeWithTermsOfUse;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    agreeWithTermsOfUse
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: greenShade,
                    size: 30,
                  ),
                  const Text(
                      "I've read and agree with terms\n of use and privacy policy")
                ],
              ),
            ),
            SizedBox(
              height: devHeight * 0.03,
            ),
            GestureDetector(
              onTap: () async {
                //TODO: access location
                await _getLocation().then((value) {
                  setState(() {
                    location = ('${value.latitude}', '${value.longitude}');
                    // awaitingSignUp = true;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    location != ("", "")
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: greenShade,
                    size: 30,
                  ),
                  const Text(
                    "  Enable location services ",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: devHeight * 0.04,
            ),
            GestureDetector(
              onTap: () async {
                print(location);
                if (_selected_image != null &&
                    agreeWithTermsOfUse &&
                    location != ("", "")) {
                  setState(() {
                    awaitingSignUp = true;
                  });
                  (int, String) result = await sqlSignUp(
                    name_field.text.trim(),
                    username_field.text.trim(),
                    phone_number_field.text,
                    dateJ,
                    is_male,
                    BCrypt.hashpw(pass_field.text, BCrypt.gensalt()),
                    _selected_image!,
                    location,
                  );

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setInt("user_id", result.$1);
                  await prefs.setString("password_hash", result.$2);

                  print("Prefs saved");

                  print(prefs.getInt("user_id"));
                  await fillUserObj(prefs.getInt("user_id")!);
                  print(prefs.getString("password_hash"));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55),
                    color: _selected_image != null &&
                            agreeWithTermsOfUse &&
                            location != ("", "")
                        ? greenShade
                        : Colors.white54),
                height: devHeight * 0.1,
                width: devWidth * 0.8,
                child: Center(
                  child: awaitingSignUp
                      ? const SpinKitPumpingHeart(
                          color: Colors.black,
                        )
                      : const Text(
                          "ورود",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: devHeight * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

// Future<List<Contact>> getContacts() async {
//   bool isGranted = await Permission.contacts.status.isGranted;
//   if (!isGranted) {
//     isGranted = await Permission.contacts.request().isGranted;
//   }
//   if (isGranted) {
//     return await FastContacts.getAllContacts();
//   }
//   return [];
// }
