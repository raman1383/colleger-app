import 'dart:io';

import 'package:colleger/main.dart';
import 'package:colleger/screens/edit_answered_prompts.dart';
import 'package:colleger/screens/money_page.dart';
import 'package:colleger/screens/pick_prompts_page.dart';
import 'package:colleger/screens/settings_page.dart';
import 'package:colleger/screens/varify_page.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

//TODO:  vanity metric of POPULARITY: depends on how many right swipes you get. not shared publicly(sell boosts and subscriptions with it)

class Profile extends StatefulWidget {
  final String idOfProfileBeingViewed;
  const Profile({super.key, required this.idOfProfileBeingViewed});

  @override
  State<Profile> createState() => _ProfileState();
}

// List<String> prompt_titles = [
//   "...چه نوع رابطه ای میخوام",
//   "...من دنبال کسی هستم که",
//   "...لذت های ساده من",
//   "...بزرگترین قدرت من",
//   "...رل من بودن مثل",
//   "...آخر هفته معمولی",
//   "...بهترین راه برای درخواست سر قرار اومدن از من این است که",
//   "من به طرز عجیبی جذب…",
//   "ویژگی بارز یک رابطه خوب این است که…",
//   "چیزی که برای من غیرقابل مذاکره است…",
//   "پرچم های سبزی(ویژگی های خوب) که دنبالشونم...",
//   "من ساکت نمیشم در مورد ...",
//   "کلید به قلب من این است…",
//   "من خودمو از یک حال روحی بد درمیارم با ...",
//   "چیزایی که دوستام دربارش ازم نصیحت میپرسن ...",
//   "من آروم میشم با ...",
//   "تنها چیزی که دوست دارم درباره تو بدونم این است که…",
//   "بیا مطمئن شیم که باهم توافق داریم درباه ...",
//   "بزرگترین ریسک هایی که کردم ...",
//   "خودجوش ترین کاری که انجام دادم…",
//   "شعار زندگی من اینه که...",
//   "تا حقیقت و یک دروغ درباره من...",
//   "بدترین ایده ای که تو عمرم داشتم...",
//   "من بهترین جای شهرو میدونم برای ...",
//   "چیکار میکنی اگه بهت بگم که...",
//   "...اگه غول چراغ جادو سه تا آرزو برام براورده میکرد, سه تا آرزوم"
// ];

double getAge(String birthDate) {
  return JalaliRange(
              start: Jalali(int.parse(birthDate.substring(0, 4)),
                  int.parse(birthDate.substring(5, 7)), 15),
              end: Jalali.now())
          .duration
          .inDays /
      365;
}

//TODO: use a future builder
int? height, weight;
String bio = "bio here...";
bool viewerIsOwner = false;

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    seeIfViewerIsOwner();
    getGeneralData(
        viewerIsOwner ? accountOwnerId! : widget.idOfProfileBeingViewed);
    getProfilePicLinks(
        viewerIsOwner ? accountOwnerId! : widget.idOfProfileBeingViewed);
    getPromptTitles(
        viewerIsOwner ? accountOwnerId! : widget.idOfProfileBeingViewed);

    //TODO:  getPrompts();
    super.initState();
  }

  void seeIfViewerIsOwner() {
    if (widget.idOfProfileBeingViewed == accountOwnerId) {
      setState(() {
        viewerIsOwner = true;
      });
    } else {
      setState(() {
        viewerIsOwner = false;
      });
    }
    // print(
    //     "viewer: ${widget.viewerId}  profileOwner: ${widget.profileOwnerId} viewerIsOwner: $viewerIsOwner");
  }

  List<String> profilePicLinks = [];
  List<String> promptAnswersList = [];
  List<String> promptAnswersIndex = [];

  Map<String, dynamic> userGeneralData = {
    'user_name': "",
    'birth_date': '1380-01-01',
    "weight": "",
    "bio": "",
    "verified": "",
    'first_name': "",
    "roses_sendable_count": "X"
  };

  Future getGeneralData(String id) async {
    // can give rose to profile you searched/found to start chat
    // username, verification, first_name, age, height,weight,bio,
    var x = await fillUserObj(int.parse(id));
    setState(() {
      userGeneralData = x;
    });
  }

  Future getProfilePicLinks(String id) async {
    String query = "SELECT pic_link FROM profile_pics WHERE owner_id = '$id';";
    var x = await getPicLinks(query);
    print(x);
    setState(() {
      profilePicLinks = x;
    });
    // return x;
  }

  Future getPromptTitles(String id) async {
    String query =
        "SELECT prompt_title FROM prompts WHERE prompt_id IN (SELECT prompt_title FROM users_prompt_answers WHERE owner_id = '$id');";
    String query2 =
        "SELECT prompt_title FROM users_prompt_answers WHERE owner_id = '$id';";
    var x = await getUsersPromptTitlesSql(query);
    var y = await getUsersPromptTitlesSql(query2);
    print("#######");
    print(x);
    print(y);
    setState(() {
      promptAnswersList = x;
      promptAnswersIndex = y;
    });
  }

  bool hitsSave = false;

  //TODO: hold onto prompts or pics to see delete option

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        //TODO: green shadow on end of appbar
        shadowColor: greenShade,
        centerTitle: true,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            viewerIsOwner
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Verify(),
                        ),
                      );
                    },
                    child: userGeneralData["verified"] == "none"
                        ? const Icon(
                            Icons.radio_button_checked_sharp,
                            color: Colors.red,
                            size: 30,
                          )
                        : userGeneralData["verified"] == "pending"
                            ? const Icon(
                                Icons.circle_outlined,
                                color: Colors.yellow,
                                size: 30,
                              )
                            : const Icon(
                                Icons.check_circle_sharp,
                                color: greenShade,
                                size: 30,
                              ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "@",
                  style: TextStyle(fontSize: 25, color: greenShade),
                ),
                Text(
                  userGeneralData["user_name"].length > 12
                      ? userGeneralData["user_name"].substring(0, 9) + "..."
                      : userGeneralData["user_name"],
                  style: const TextStyle(fontSize: 30),
                ),
                // viewerIsOwner
              ],
            ),
            //
            viewerIsOwner
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                        onTap: () async {
                          // if (viewerIsOwner) {
                          //   if (hitsSave == false) {
                          //     setState(() {
                          //       hitsSave = true;
                          //     });
                          //     await executeQuery(
                          //       "INSERT INTO saved(saver_id,saved_id) VALUES($accountOwnerId,${widget.viewerId});",
                          //     );
                          //   }
                          // } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Settings(),
                            ),
                          );
                          // }
                        },
                        child: const Icon(
                          CupertinoIcons.gear,
                          color: greenShade,
                          size: 32,
                        )),
                  )
                : userGeneralData["verification"] == "verified"
                    ? const Icon(
                        Icons.check_circle_sharp,
                        color: greenShade,
                        size: 30,
                      )
                    : const Icon(
                        Icons.radio_button_checked_sharp,
                        color: Colors.red,
                        size: 30,
                      )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: devHeight * 0.03,
            ),
            SizedBox(
              width: devWidth * 0.99,
              // color: Colors.cyanAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        userGeneralData["first_name"],
                        // "xxxxxxxxxx",
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        getAge(userGeneralData["birth_date"])
                            .toString()
                            .substring(0, 2),
                        style: const TextStyle(fontSize: 30, color: greenShade),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (viewerIsOwner) {
                            await _showInputDialog(context, true);
                            print("height submit to DB  $height");
                            executeQuery(
                                "UPDATE users SET height = '$height' WHERE user_id = '$accountOwnerId';");
                          }
                        },
                        child: Text(
                          //TODO: must be rendered based on viewer/owner ids
                          userGeneralData["height"] == null && height == null
                              ? "قد؟"
                              : ("${userGeneralData["height"].toString()[0]}.${userGeneralData["height"].toString()[1]}${userGeneralData["height"].toString()[2]}"),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: devHeight * 0.006,
                      // ),
                      // const Icon(
                      //   Icons.circle,
                      //   color: greenShade,
                      //   size: 7,
                      // ),
                      // SizedBox(
                      //   height: devHeight * 0.006,
                      // ),
                      // GestureDetector(
                      //   onTap: () async {
                      //     if (viewerIsOwner) {
                      //       await _showInputDialog(context, false);
                      //       print("weight submit to DB");
                      //       executeQuery(
                      //           "UPDATE users SET weight = '$weight' WHERE user_id = '$accountOwnerId';");
                      //     }
                      //   },
                      //   child: Text(
                      //     userGeneralData["weight"] == null && weight == null
                      //         ? "وزن؟"
                      //         : userGeneralData["weight"].toString(),
                      //     style: const TextStyle(
                      //       fontSize: 20,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: devHeight * 0.03,
            ),
            GestureDetector(
              onTap: () {
                //

                if (viewerIsOwner) {
                  _showInputDialogForBio(context);
                } else {}
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 11, right: 11),
                child: Text(
                  userGeneralData["bio"],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            Row(
              children: [
                promptAnswersList.isEmpty
                    ? const Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            "پرامپت ها ",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: devHeight * 0.27,
                  width: promptAnswersList.isNotEmpty
                      ? devWidth * 0.9
                      : devWidth * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: promptAnswersList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          index == 0
                              ? const Center(
                                  child: RotatedBox(
                                    quarterTurns: -1,
                                    child: Text(
                                      "پرامپت ها ",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAnsweredPrompts(
                                      promptId: promptAnswersIndex[index],
                                      promptTitle: promptAnswersList[index],
                                      canEdit: viewerIsOwner,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: devHeight * 0.24,
                                width: devWidth * 0.35,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 52, 52, 52),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      promptAnswersList[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          index == promptAnswersList.length - 1
                              ? viewerIsOwner
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PickPrompts(),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        CupertinoIcons.add,
                                        size: 50,
                                        color: greenShade,
                                      ),
                                    )
                                  : Container()
                              : const Icon(
                                  Icons.circle,
                                  color: greenShade,
                                  size: 10,
                                ),
                        ],
                      );
                    },
                  ),
                ),
                viewerIsOwner
                    ? promptAnswersList.isEmpty
                        ? Row(
                            children: [
                              SizedBox(
                                width: devWidth * 0.24,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PickPrompts(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.add,
                                  size: 50,
                                  color: greenShade,
                                ),
                              ),
                            ],
                          )
                        : Container()
                    : Container()
              ],
            ),
            SizedBox(
              height: devHeight * 0.03,
            ),
            SizedBox(
              height: devHeight * 0.25,
              width: devWidth,
              child: profilePicLinks.isEmpty
                  ? viewerIsOwner
                      ? GestureDetector(
                          onTap: () async {
                            final picker = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (picker != null) {
                              String picLink =
                                  await uploadImage(File(picker.path));
                              print(picLink);
                              executeQuery(
                                  "INSERT INTO profile_pics(owner_id,pic_link) VALUES('$accountOwnerId','$picLink');");
                            } else {
                              null;
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 11.0, left: 5),
                            child: Icon(
                              CupertinoIcons.add,
                              size: 50,
                              color: greenShade,
                            ),
                          ),
                        )
                      : Container()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: profilePicLinks.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                backgroundIsTransparent: true,
                                child: Image.network(
                                  "http://dl.colleger.ir/ftpUser/${profilePicLinks[index]}",
                                ),
                              ),
                            ),
                            viewerIsOwner
                                ? index + 1 == profilePicLinks.length
                                    ? GestureDetector(
                                        onTap: () async {
                                          //TODO: open gallery, upload selected pic
                                          final picker = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          if (picker != null) {
                                            String picLink = await uploadImage(
                                                File(picker.path));
                                            print(picLink);
                                            executeQuery(
                                                "INSERT INTO profile_pics(owner_id,pic_link) VALUES('$accountOwnerId','$picLink');");
                                          } else {
                                            null;
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              right: 11.0, left: 5),
                                          child: Icon(
                                            CupertinoIcons.add,
                                            size: 50,
                                            color: greenShade,
                                          ),
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Icon(
                                          Icons.circle,
                                          color: greenShade,
                                          size: 10,
                                        ),
                                      )
                                : Container()
                          ],
                        );
                      },
                    ),
            ),
            SizedBox(
              height: devHeight * 0.02,
            ),
            viewerIsOwner
                ? GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Money(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        "X UPGRADE X",
                        style: TextStyle(
                          color: greenShade,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          fontFamily: "Silkscreen",
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Function to show the dialog window
  Future<void> _showInputDialog(BuildContext context, bool forHeight) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: forHeight
              ? const Text('قد به سانتی متر\n ')
              : const Text('وزن به کیلو گرم'),
          content: forHeight
              ? SizedBox(
                  height: 200,
                  width: 100,
                  child: WheelChooser.integer(
                    onValueChanged: (s) => setState(() {
                      height = s;
                    }),
                    maxValue: 220,
                    minValue: 120,
                    step: 1,
                  ),
                )
              : SizedBox(
                  height: 200,
                  width: 100,
                  child: WheelChooser.integer(
                    onValueChanged: (s) => setState(() {
                      weight = s;
                    }),
                    maxValue: 200,
                    minValue: 40,
                    step: 1,
                  ),
                ),
        );
      },
    );
  }

  TextEditingController bioController = TextEditingController();

  // Function to show the dialog window
  Future<void> _showInputDialogForBio(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Bio: '),
            content: SizedBox(
              height: 250,
              width: 100,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 3,
                        color: greenShade,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: TextField(
                        controller: bioController,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        maxLines: 6,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        //TODO: submit answer to DB and pop back
                        executeQuery("""
UPDATE users
SET bio = '${bioController.text}'
WHERE user_id = $accountOwnerId;
""");
                        answerController.clear();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.check_circle,
                        color: bioController.text.isNotEmpty
                            ? greenShade
                            : Colors.grey,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            )
            // : SizedBox(
            //     height: 200,
            //     width: 100,
            //     child: WheelChooser.integer(
            //       onValueChanged: (s) => setState(() {
            //         weight = s;
            //       }),
            //       maxValue: 200,
            //       minValue: 40,
            //       step: 1,
            //     ),
            //   ),
            );
      },
    );
  }
}
