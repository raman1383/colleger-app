import 'package:colleger/main.dart';
import 'package:colleger/screens/chatroom.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: easy to share profile cards and in grougs and ask others openions

//TODO: lost&found channel -> 10KT per message, geo constrained

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

List<String> chatIds = [];
List<String> othersIds = [];
List<String> othersPicLinks = [];
List<String> othersFirstName = [];

class _ChatState extends State<Chat> {
  Future getChatContacts() async {
// SELECT c.chat_id,
//        CASE
//            WHEN c.participant_a = '$accountOwnerId' THEN c.participant_b
//            ELSE c.participant_a
//        END AS other_participant_id,
//        u.first_name AS other_participant_name,
//        p.pic_link AS other_participant_pic
// FROM chats c
// JOIN users u ON (c.participant_a = u.user_id OR c.participant_b = u.user_id)
// LEFT JOIN profile_pics p ON (
//     CASE
//         WHEN c.participant_a = '$accountOwnerId' THEN c.participant_b
//         ELSE c.participant_a
//     END = p.owner_id
// )
// WHERE (c.participant_a = '$accountOwnerId' OR c.participant_b = '$accountOwnerId')
//   AND u.user_id != '$accountOwnerId';
    String query = """
SELECT 
    c.chat_id,
    CASE
        WHEN c.participant_a = '$accountOwnerId' THEN c.participant_b
        ELSE c.participant_a
    END AS other_participant_id,
    u.first_name AS other_participant_name,
    MAX(p.pic_link) AS other_participant_pic
FROM 
    chats c
JOIN 
    users u ON (c.participant_a = u.user_id OR c.participant_b = u.user_id)
LEFT JOIN 
    profile_pics p ON (
        CASE
            WHEN c.participant_a = '$accountOwnerId' THEN c.participant_b
            ELSE c.participant_a
        END = p.owner_id
    )
WHERE 
    (c.participant_a = '$accountOwnerId' OR c.participant_b = '$accountOwnerId')
    AND u.user_id != '$accountOwnerId'
GROUP BY 
    c.chat_id, other_participant_id, other_participant_name;

""";
    var x = await parseChats(query);
    setState(() {
      chatIds = x[0];
      othersIds = x[1];
      othersFirstName = x[2];
      othersPicLinks = x[3];
    });
    print(x);
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatContacts();
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            //TODO: able to search for and chat with other users by ID

            Container(
              width: devWidth * 0.7,
              height: devHeight * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: greenShade, width: 2),
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  decoration:
                      InputDecoration(hintText: "Search... colleger id"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await getChatContacts();
              },
              child: const Icon(
                Icons.search,
                size: 33,
                color: greenShade,
              ),
            )
          ]),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  CupertinoIcons.chat_bubble,
                  size: 30,
                ),
              ),
              Tab(
                  icon: Icon(
                Icons.explore_outlined,
                size: 30,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Tab 1
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: devWidth,
                    height: devHeight * 0.01,
                  ),
                  Container(
                    color: Colors.blueAccent,
                    height: devHeight * 0.7,
                    // width: devWidth * 0.5,
                    // child: ListView(
                    //   children: const [
                    //     //TODO: tell community the most popular ones(most up voted) get added to chat suggestions/ by name of author
                    //     ContactAvatar(
                    //       title: "پیکاپ لاین های باحال",
                    //     ),

                    //     //TODO: tell community the most popular ones(most up voted) get added to prompts/ by name of author
                    //     ContactAvatar(
                    //       title: "پرامپت های باحال",
                    //     ),
                    //     ContactAvatar(
                    //       title: "sana",
                    //     ),
                    //     ContactAvatar(
                    //       title: "hana",
                    //     ),
                    //     ContactAvatar(
                    //       title: "nana",
                    //     ),
                    //   ],
                    // ),
                    child: ListView.builder(
                      itemCount: chatIds.length,
                      itemBuilder: (context, index) {
                        return ContactAvatar(
                          chatId: chatIds[index],
                          othersId: othersIds[index],
                          picLink: othersPicLinks[index],
                          firstName: othersFirstName[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Content for Tab 2
            Center(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        String queryForGenerals =
                            "SELECT verified,first_name,user_name,birth_date,height,bio FROM users WHERE user_id = 7;";
                        String queryForPicLinks =
                            "SELECT pic_link FROM profile_pics WHERE owner_id = 7;";
                        String queryForPrompts =
                            "SELECT p.prompt_title, upa.prompt_answer FROM users_prompt_answers upa JOIN prompts p ON upa.prompt_title = p.prompt_id WHERE upa.owner_id = 9;";

                        String compinedQuery = """
SELECT u.verified, u.first_name, u.user_name, u.birth_date, u.height, u.bio, pp.pic_link, p.prompt_title, upa.prompt_answer
FROM users u
JOIN profile_pics pp ON u.user_id = pp.owner_id
JOIN users_prompt_answers upa ON u.user_id = upa.owner_id
JOIN prompts p ON upa.prompt_title = p.prompt_id
WHERE u.user_id = 9;
""";
                        var strings = await executeQuery(queryForPicLinks);
                        print("in chats hitting Icons.no_sim");
                        print(strings);
                      },
                      child: const Icon(Icons.no_sim)),
                  const Text(
                      "show cool prompts, profile pics and interest clouds,..."),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //  Scaffold(
    //   appBar: AppBar(
    //     title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    //       //TODO: able to search for and chat with other users by ID

    //       Container(
    //         width: devWidth * 0.7,
    //         height: devHeight * 0.06,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(30),
    //           border: Border.all(color: greenShade, width: 2),
    //         ),
    //         child: const Padding(
    //           padding: EdgeInsets.only(
    //             left: 15,
    //             right: 15,
    //           ),
    //           child: TextField(
    //             decoration: InputDecoration(hintText: "Search... colleger id"),
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         onTap: () async {
    //           await getChatContacts();
    //         },
    //         child: const Icon(
    //           Icons.search,
    //           size: 33,
    //           color: greenShade,
    //         ),
    //       )
    //     ]),
    //   ),
    //   extendBody: true,

    //   //TODO: each rel_tag will have a horizontal list of contacts under it
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         width: devWidth,
    //         height: devHeight * 0.01,
    //       ),
    //       SizedBox(
    //         height: devHeight * 0.8,
    //         // width: devWidth * 0.5,
    //         // child: ListView(
    //         //   children: const [
    //         //     //TODO: tell community the most popular ones(most up voted) get added to chat suggestions/ by name of author
    //         //     ContactAvatar(
    //         //       title: "پیکاپ لاین های باحال",
    //         //     ),

    //         //     //TODO: tell community the most popular ones(most up voted) get added to prompts/ by name of author
    //         //     ContactAvatar(
    //         //       title: "پرامپت های باحال",
    //         //     ),
    //         //     ContactAvatar(
    //         //       title: "sana",
    //         //     ),
    //         //     ContactAvatar(
    //         //       title: "hana",
    //         //     ),
    //         //     ContactAvatar(
    //         //       title: "nana",
    //         //     ),
    //         //   ],
    //         // ),
    //         child: ListView.builder(
    //           itemCount: chatIds.length,
    //           itemBuilder: (context, index) {
    //             return ContactAvatar(
    //               chatId: chatIds[index],
    //               othersId: othersIds[index],
    //               picLink: othersPicLinks[index],
    //               firstName: othersFirstName[index],
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class ContactAvatar extends StatefulWidget {
  final String chatId;
  final String othersId;
  final String firstName;
  final String picLink;
  const ContactAvatar(
      {super.key,
      required this.chatId,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                //TODO: Pass the contact user to chatroom and render accordingly
                builder: (context) => ChatRoom(
                  othersId: widget.othersId,
                  othersPicLink:
                      "http://dl.colleger.ir/ftpUser/${widget.picLink}",
                  othersFirstName: widget.firstName,
                  chatId: widget.chatId,
                ),
              ),
            );
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
                  // const Icon(
                  //   Icons.more_vert,
                  //   size: 30,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
