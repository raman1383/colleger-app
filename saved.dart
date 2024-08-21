import 'package:colleger/main.dart';
import 'package:colleger/screens/profile.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  List<String> othersIdsX = [];
  List<String> othersPicLinksX = [];
  List<String> othersFirstNameX = [];
  Future getSaveds() async {
    String query = """
SELECT DISTINCT
    l.saved_id,
    u.first_name,
    pp.pic_link
FROM 
      saved l
JOIN 
    users u ON l.saved_id = u.user_id
JOIN 
    profile_pics pp ON l.saved_id = pp.owner_id
WHERE 
    l.saver_id = $accountOwnerId;


""";
    var x = await parseSaved(query);
    setState(() {
      othersIdsX = x[0];
      othersFirstNameX = x[1];
      othersPicLinksX = x[2];
    });
    print("object@@");
    print(x);
  }

  List<String> othersIds = [];
  List<String> othersPicLinks = [];
  List<String> othersFirstName = [];

  Future getLikees() async {
    String query = """
SELECT DISTINCT
    l.likee_id,
    u.first_name,
    pp.pic_link
FROM 
    likes l
JOIN 
    users u ON l.likee_id = u.user_id
JOIN 
    profile_pics pp ON l.likee_id = pp.owner_id
WHERE 
    l.liker_id = $accountOwnerId;


""";
    var x = await parseLikers(query);
    setState(() {
      othersIds = x[0];
      othersFirstName = x[1];
      othersPicLinks = x[2];
    });
    print("object@@");
    print(x);
  }

  @override
  void initState() {
    getSaveds();
    getLikees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Two Tabs Example'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.bookmark,
                  size: 40,
                ),
              ),
              Tab(
                icon: Icon(
                  CupertinoIcons.heart_fill,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Tab 1
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: devHeight * 0.8,
                    child: ListView.builder(
                      itemCount: othersIdsX.length,
                      itemBuilder: (context, index) {
                        return ContactAvatar(
                          othersId: othersIdsX[0],
                          firstName: othersFirstNameX[0],
                          picLink: othersPicLinksX[0],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            // Content for Tab 2
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: devHeight * 0.8,
                    child: ListView.builder(
                      itemCount: othersIds.length,
                      itemBuilder: (context, index) {
                        return ContactAvatar(
                          othersId: othersIds[0],
                          firstName: othersFirstName[0],
                          picLink: othersPicLinks[0],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactAvatar extends StatefulWidget {
  final String othersId;
  final String firstName;
  final String picLink;
  const ContactAvatar(
      {super.key,
      required this.othersId,
      required this.firstName,
      required this.picLink});

  @override
  State<ContactAvatar> createState() => _ContactAvatarState();
}

class _ContactAvatarState extends State<ContactAvatar> {
  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;
    return Container(
      // profile pic with name overlaid, #rel_stat at bottom, badge for unread messages + number of days in streak
      child: Padding(
        padding: const EdgeInsets.only(
          top: 11.0,
          left: 11,
          right: 11,
        ),
        child: GestureDetector(
          onTap: () {
            print(widget.picLink);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     //TODO: Pass the contact user to chatroom and render accordingly
            //     builder: (context) => Profile(
            //       widget.chatId,
            //     ),
            // ),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(66, 127, 127, 127),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //!
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //TODO: Pass the contact user to chatroom and render accordingly
                          builder: (context) => Profile(
                            idOfProfileBeingViewed: widget.othersId,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            errorBuilder: (context, child, loadingProgress) =>
                                const HeartLoading(),

                            width: devWidth * 0.2,
                            height: (devWidth * 0.2),
                            "http://dl.colleger.ir/ftpUser/${widget.picLink}", //TODO: fetch from DB
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: devWidth * 0.1,
                        ),
                        Text(
                          widget.firstName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: devWidth * 0.35,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await giveRose(
                          context, widget.othersId, widget.firstName);
                    },
                    child: SizedBox(
                      height: 60,
                      width: devWidth * 0.1,
                      // color: Colors.blueAccent,
                      child: Image.asset(
                          "./assets/Screenshot 2024-03-03 180142 (1) (1).png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
