// import 'package:colleger/screens/profile.dart';
// import 'package:colleger/utilities/loadings.dart';
// import 'package:colleger/utilities/sql_queries.dart';
// import 'package:flutter/material.dart';

// class Queue extends StatefulWidget {
//   const Queue({super.key});

//   @override
//   State<Queue> createState() => _QueueState();
// }

// // user_id, profile_pic, name, age
// List<String> othersIds = [];
// List<String> othersPicLinks = [];
// List<String> othersFirstName = [];

// class _QueueState extends State<Queue> {
// //   Future getLikees() async {
// //     String query = """
// // SELECT DISTINCT
// //     l.likee_id,
// //     u.first_name,
// //     pp.pic_link
// // FROM
// //     likes l
// // JOIN
// //     users u ON l.likee_id = u.user_id
// // JOIN
// //     profile_pics pp ON l.likee_id = pp.owner_id
// // WHERE
// //     l.liker_id = $accountOwnerId;

// // """;
// //     var x = await parseLikers(query);
// //     setState(() {
// //       othersIds = x[0];
// //       othersFirstName = x[1];
// //       othersPicLinks = x[2];
// //     });
// //     print("object@@");
// //     print(x);
// //   }

// //   @override
// //   void initState() {
// //     getLikees();
// //     // getLikers();
// //     super.initState();
// //   }

//   @override
//   Widget build(BuildContext context) {
//     var devHeight = MediaQuery.of(context).size.height;
//     var devWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Tab(text: 'X'),
//       ),
//       body: const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("results of those who you added yourself to their queue"),
//           // SizedBox(
//           //   height: devHeight * 0.8,
//           //   child: ListView.builder(
//           //     itemCount: othersIds.length,
//           //     itemBuilder: (context, index) {
//           //       return ContactAvatar(
//           //         othersId: othersIds[0],
//           //         firstName: othersFirstName[0],
//           //         picLink: othersPicLinks[0],
//           //       );
//           //     },
//           //   ),
//           // )
//         ],
//       ),
//     );
//   }
// }

// class ContactAvatar extends StatefulWidget {
//   final String othersId;
//   final String firstName;
//   final String picLink;
//   const ContactAvatar(
//       {super.key,
//       required this.othersId,
//       required this.firstName,
//       required this.picLink});

//   @override
//   State<ContactAvatar> createState() => _ContactAvatarState();
// }

// class _ContactAvatarState extends State<ContactAvatar> {
//   @override
//   Widget build(BuildContext context) {
//     var devHeight = MediaQuery.of(context).size.height;
//     var devWidth = MediaQuery.of(context).size.width;
//     return Container(
//       // profile pic with name overlaid, #rel_stat at bottom, badge for unread messages + number of days in streak
//       child: Padding(
//         padding: const EdgeInsets.only(
//           top: 11.0,
//           left: 11,
//           right: 11,
//         ),
//         child: GestureDetector(
//           onTap: () {
//             print(widget.picLink);
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     //TODO: Pass the contact user to chatroom and render accordingly
//             //     builder: (context) => Profile(
//             //       widget.chatId,
//             //     ),
//             // ),
//             // );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: const Color.fromARGB(66, 127, 127, 127),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   //!
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           //TODO: Pass the contact user to chatroom and render accordingly
//                           builder: (context) => Profile(
//                             viewerId: accountOwnerId,
//                             profileOwnerId: widget.othersId,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Row(
//                       children: [
//                         ClipOval(
//                           child: Image.network(
//                             errorBuilder: (context, child, loadingProgress) =>
//                                 const HeartLoading(),

//                             width: devWidth * 0.2,
//                             height: (devWidth * 0.2),
//                             "http://dl.colleger.ir/ftpUser/${widget.picLink}", //TODO: fetch from DB
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(
//                           width: devWidth * 0.1,
//                         ),
//                         Text(
//                           widget.firstName,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(
//                           width: devWidth * 0.35,
//                         ),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       await giveRose(
//                           context, widget.othersId, widget.firstName);
//                     },
//                     child: SizedBox(
//                       height: 60,
//                       width: devWidth * 0.1,
//                       // color: Colors.blueAccent,
//                       child: Image.asset(
//                           "./assets/Screenshot 2024-03-03 180142 (1) (1).png"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
