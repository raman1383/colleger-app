import 'package:colleger/main.dart';
import 'package:colleger/screens/swipe.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Money extends StatefulWidget {
  const Money({super.key});

  @override
  State<Money> createState() => _MoneyState();
}

//! one rose a month + unlimited swipes for month + filter by age and proximity + more accurate geo-location
//! boost: 1 day boost
//! rose
//! soulmate package

///! make the price dynamic, not hard-coded! fetch price from DB. based on gender, age,

String price = "99,999";
double age = 23;

class _MoneyState extends State<Money> {
  var x = JalaliRange(
              start: Jalali(int.parse(userObj["birth_date"].substring(0, 4)),
                  int.parse(userObj["birth_date"].substring(5, 7)), 15),
              end: Jalali.now())
          .duration
          .inDays /
      365;

  void getAgeAndSetPrice() {
    setState(() {
      age = x;
    });
    if (age > 22) {
      price = "49,999";
    } else {
      price = "99,999";
    }
  }

  @override
  void initState() {
    getAgeAndSetPrice();
    super.initState();
  }

  Future buySubs() async {
    //TODO: set sub_end_date to 30 days from now
    //TODO:
    Jalali next30Days = Jalali.now().addMonths(1);

    String dateOfNext30Days = getDateAsString(next30Days);
    await executeQuery(
        "UPDATE users SET subs_end_date = '$dateOfNext30Days' WHERE user_id = $locallyFetchedUserId;");
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "X UPGRADE X",
          style: TextStyle(
            color: greenShade,
            fontWeight: FontWeight.w500,
            fontSize: 30,
            fontFamily: "Silkscreen",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                print("...BUY SUBSCRIPTION...");
                await buySubs();
              },
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Container(
                  // height: devHeight * 0.3,
                  // width: devWidth * 0.,
                  decoration: BoxDecoration(
                    // border: Border.all(color: greenShade, width: 2),
                    color: const Color.fromARGB(66, 127, 127, 127),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "! اشتراک یک ماهه",
                                style:
                                    TextStyle(fontSize: 25, color: greenShade),
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "سوایپ های نامحدود ",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "  یک گل رز مجانی  ",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "چت با مدیرعامل و\n موسس(انتقاد و پیشنهادات)",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "میتونی ببینی کیا خودشونو به صف تو \nاضافه کردن و کیا روت راست\n زدن و کیا توسط الگوریتم اضافه شدن",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "قابلیت بازگشت به کارت قبلی",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                      style: TextStyle(fontSize: 18),
                                      "الگوریتم برنامه بهت اولویت\n بالاتری نسبت به کاربرهای \nدیگه میده(مچ های بهتر و بیشتر)"),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.02,
                              ),
                              const Row(
                                children: [
                                  Text(
                                      style: TextStyle(fontSize: 20),
                                      "قابلیت فیلتر بر اساس سن\n و فاصله جغرافیایی"),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "گرفتن تیک سبز",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.01,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "(1/12)نزدیکتر به کاربر حرفه ای شدن",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  Icon(
                                    Icons.crisis_alert_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: devHeight * 0.03,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "$price تومان",
                        style: const TextStyle(fontSize: 23, color: greenShade),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Container(
            //     // height: devHeight * 0.3,
            //     // width: devWidth * 0.,
            //     decoration: BoxDecoration(
            //       // border: Border.all(color: greenShade, width: 2),
            //       borderRadius: BorderRadius.circular(25),
            //       color: const Color.fromARGB(66, 127, 127, 127),
            //     ),
            //     child: const Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Column(
            //               children: [
            //                 Text(
            //                   "تقویت پروفایل (موقت)",
            //                   style: TextStyle(fontSize: 25),
            //                 ),
            //                 Text("گرفتن تیک سبز"),
            //               ],
            //             ),
            //           ],
            //         ),
            //         Text(
            //           "49,999 تومان",
            //           style: TextStyle(fontSize: 23),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: devHeight * 0.03,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,

            //   // scrollDirection: Axis.horizontal,
            //   children: [
            //     Container(
            //       height: devHeight * 0.3,
            //       width: devWidth * 0.45,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: greenShade, width: 2),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //     Container(
            //       height: devHeight * 0.3,
            //       width: devWidth * 0.45,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: greenShade, width: 2),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: devHeight * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Container(
                height: devHeight * 0.27,
                // width: devWidth * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(66, 127, 127, 127),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "خرید یک گل رز",
                      style: TextStyle(fontSize: 25, color: greenShade),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "اگه از یکی خیییلی خوشت اومد و خواستی بدون اینکه منتظر بمونی تا اونم لایکت کنه تا بتونی باهاش چت کنی... کافیه بهش یه رز بدی",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "99,999 تومان",
                      style: TextStyle(
                        fontSize: 23,
                        color: greenShade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Container(
                height: devHeight * 0.23,
                width: devWidth * 0.95,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(66, 127, 127, 127),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "پیدا کردن نیمه ی گمشده",
                      style: TextStyle(fontSize: 23, color: greenShade),
                    ),
                    Text(
                      "شما هنوز کاربر حرفه ای نیستید \nپس این قابلیت برای شما فعال نیست",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
