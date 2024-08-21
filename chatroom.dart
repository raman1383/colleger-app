import 'package:colleger/main.dart';
import 'package:colleger/screens/profile.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';

//TODO: dissapearing messages and dissable screenshots

//TODO: send a profile and ask friend to rate her, group chats and anonomus rating

//TODO: as list of question: conversation srarters

//TODO: group polls of cards(profiles) that your friend shared

//TODO: send a request to a group of indivs for someone with some description and they can candidate
// someone in their social graph



/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<List<Message>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureMessages = _fetchMessages();
  }

  Future<List<Message>> _fetchMessages() async {
    final response = await http.get(Uri.parse('https://your-php-backend.com/messages'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Message> messages = jsonData.map((json) => Message.fromJson(json)).toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: FutureBuilder(
        future: _futureMessages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messages = snapshot.data;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].text),
                  subtitle: Text(messages[index].username),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Message {
  final int id;
  final String text;
  final String username;

  Message({this.id, this.text, this.username});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      username: json['username'],
    );
  }
}

/!

<?php
// connect to database
$conn = mysqli_connect("localhost", "username", "password", "database_name");

// check connection
if (!$conn) {
    die("Connection failed: ". mysqli_connect_error());
}

// retrieve messages from database
$sql = "SELECT * FROM chat_messages ORDER BY created_at DESC";
$result = mysqli_query($conn, $sql);

// create an array to store the messages
$messages = array();

// fetch and store the messages
while ($row = mysqli_fetch_assoc($result)) {
    $messages[] = array(
        "id" => $row["id"],
        "text" => $row["text"],
        "username" => $row["username"],
        "created_at" => $row["created_at"]
    );
}

// close the database connection
mysqli_close($conn);

// output the messages in JSON format
header("Content-Type: application/json");
echo json_encode($messages);

?>
*/


//TODO: use ValueChangeListener on init and 5 sec intervals to check for latest messages

class ChatRoom extends StatefulWidget {
  final String othersId;
  final String othersPicLink;
  final String othersFirstName;

  final String chatId;
  const ChatRoom({
    super.key,
    required this.othersId,
    required this.othersPicLink,
    required this.othersFirstName,
    required this.chatId,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

TextEditingController _textEditingController = TextEditingController();

List<(bool, String)> messages = [];

class _ChatRoomState extends State<ChatRoom> {
  Future getMessages(int limit) async {
    String query =
        "SELECT sender_id, message_content FROM messages WHERE chat_id_it_belongs_to = ${widget.chatId} LIMIT $limit";
    List<(bool, String)> messagesSql = await getMessagesSql(query);
    setState(() {
      messages = messagesSql;
    });
    print("messages------------");
    print(messages);
  }

  @override
  void initState() {
    getMessages(11);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
        //       await getMessages(11);
        //     },
        //     child: const Padding(
        //       padding: EdgeInsets.only(right: 11.0),
        //       child: Icon(
        //         Icons.replay,
        //         color: greenShade,
        //       ),
        //     ),
        //   ),
        // ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
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
                      widget.othersPicLink,
                      errorBuilder: (context, child, loadingProgress) =>
                          const HeartLoading(),
                      width: devWidth * 0.13,
                      height: (devWidth * 0.13),
                      //TODO: fetch from DB
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: devWidth * 0.03,
                  ),
                  Text(
                    widget.othersFirstName,
                    style: const TextStyle(
                      fontSize: 27,
                    ),
                  ),
                ],
              ),
            ),
            // const Row(
            //   children: [
            //     Icon(
            //       CupertinoIcons.ellipsis_vertical,
            //       size: 35,
            //       color: greenShade,
            //     ),
            //   ],
            // )
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            // color: Colors.amberAccent,
            height: devHeight * 0.75,
            width: devWidth * 0.99,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: messages[index].$1
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: messages[index].$1
                              ? greenShade
                              : const Color.fromARGB(66, 127, 127, 127),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            messages[index].$2,
                            style: TextStyle(
                              fontSize: 22,
                              color: messages[index].$1
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            // height: devHeight * 0.1,
            width: devWidth * 0.99,
            // color: Colors.red,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: devWidth * 0.8,
                // height: devHeight * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: greenShade, width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: devWidth * 0.025,
              ),
              GestureDetector(
                onTap: () async {
                  //TODO: send message, reset textfield

                  await executeQuery(
                      "INSERT INTO messages(chat_id_it_belongs_to,sender_id,message_content) VALUES (${widget.chatId},$accountOwnerId,'${_textEditingController.text}');");
                  _textEditingController.clear();
                  await getMessages(10);
                },
                child: const Icon(
                  Icons.send_rounded,
                  size: 33,
                  color: greenShade,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
