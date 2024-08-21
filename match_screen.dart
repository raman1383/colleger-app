import 'package:colleger/main.dart';
import 'package:colleger/screens/chatroom.dart';
import 'package:colleger/screens/profile.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Match extends StatefulWidget {
  final bool withRose;
  final String candidateId;
  final String candidatesName;
  const Match({
    super.key,
    required this.withRose,
    required this.candidateId,
    required this.candidatesName,
  });

  @override
  State<Match> createState() => _MatchState();
}

//! regular match and Rose match

String ownerProfilePic = "";
String candidateProfilePic = "";

class _MatchState extends State<Match> {
  Future getPics() async {
    String query1 =
        "SELECT pic_link FROM profile_pics WHERE owner_id = '$accountOwnerId' LIMIT 1;";
    String query2 =
        "SELECT pic_link FROM profile_pics WHERE owner_id = '${widget.candidateId}' ;";

    String url1 = await executeQuery(query1);
    String url2 = await executeQuery(query2);
    print(url1);
    print(url2);

    setState(() {
      ownerProfilePic = "http://dl.colleger.ir/ftpUser/$url1";
      candidateProfilePic = "http://dl.colleger.ir/ftpUser/$url2";
    });
  }

  String chatId = "";

  Future createChatRecord() async {
    Jalali now = Jalali.now();
    String nowStr =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
    print("chat_id : ");
    await executeQuery(
        "INSERT INTO chats(participant_A,participant_B,latest_message_datetime)VALUES($accountOwnerId,${widget.candidateId},'$nowStr');");
    var chatIdIn = await executeQuery(
        "SELECT chat_id FROM chats WHERE participant_A = $accountOwnerId AND participant_B=${widget.candidateId} LIMIT 1;");
    setState(() {
      chatId = chatIdIn;
    });
  }

  @override
  void initState() {
    getPics();
    createChatRecord();
    //create chat
    super.initState();
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NewWidget(devWidth: devWidth, devHeight: devHeight, widget: widget),
          SizedBox(
            height: devHeight * 0.07,
          ),
          GestureDetector(
            onTap: () async {
              Jalali now = Jalali.now();
              String nowStr =
                  "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
              print("chat_id : ");
              await executeQuery(
                  "INSERT INTO chats(participant_A,participant_B,latest_message_datetime)VALUES($accountOwnerId,${widget.candidateId},'$nowStr');");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                      othersId: widget.candidateId,
                      othersPicLink: candidateProfilePic,
                      othersFirstName: widget.candidatesName,
                      chatId: chatId),
                ),
              );
            },
            child: Container(
              height: devHeight * 0.09,
              width: devWidth * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: greenShade,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.chat_bubble),
                  Text(
                    " بریم برا چت",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: devHeight * 0.04,
          ),
          GestureDetector(
            onTap: () async {
              final image = await screenshotController.captureFromWidget(
                  NewWidget(
                    devHeight: devWidth,
                    devWidth: devWidth,
                    widget: widget,
                  ),
                  targetSize: Size(devWidth * 0.99, devHeight * 0.77));
              Share.shareXFiles([XFile.fromData(image, mimeType: "png")]);
            },
            child: Container(
              height: devHeight * 0.09,
              width: devWidth * 0.66,
              decoration: BoxDecoration(
                border: Border.all(
                  color: greenShade,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.share),
                  Text(
                    "  به دوستات بگو",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: devHeight * 0.04,
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.devWidth,
    required this.devHeight,
    required this.widget,
  });

  final double devWidth;
  final double devHeight;
  final Match widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "🔥با هم مچ شدین 🔥",
          style: TextStyle(fontSize: 37),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    errorBuilder: (context, child, loadingProgress) =>
                        const HeartLoading(),
                    width: devWidth * 0.3,
                    height: (devWidth * 0.3),
                    candidateProfilePic, //TODO: fetch from DB
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "@ ",
                      style: TextStyle(
                        fontSize: 23,
                        color: greenShade,
                      ),
                    ),
                    Text(
                      widget.candidatesName,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.withRose
                ? SizedBox(
                    height: 60,
                    width: 50,
                    // color: Colors.blueAccent,
                    child: Image.asset(
                        "./assets/Screenshot 2024-03-03 180142 (1) (1).png"),
                  )
                : const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                    size: 50,
                  ),
            Column(
              children: [
                ClipOval(
                  child: Image.network(
                    errorBuilder: (context, child, loadingProgress) =>
                        const HeartLoading(),

                    width: devWidth * 0.3,
                    height: (devWidth * 0.3),
                    ownerProfilePic, //TODO: fetch from DB
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "@ ",
                      style: TextStyle(
                        fontSize: 23,
                        color: greenShade,
                      ),
                    ),
                    Text(
                      userObj["user_name"],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Text(userObj["first_name"]),
          ],
        ),

        // Text(widget.candidateId),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "colleger.ir",
          style: TextStyle(fontSize: 20, color: greenShade),
        )

        //!

        //!
      ],
    );
  }
}
