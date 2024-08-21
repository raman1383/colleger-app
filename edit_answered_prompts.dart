import 'package:colleger/main.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';

class EditAnsweredPrompts extends StatefulWidget {
  final String promptId;
  final String promptTitle;
  final bool canEdit;
  const EditAnsweredPrompts(
      {super.key,
      required this.promptId,
      required this.promptTitle,
      required this.canEdit});

  @override
  State<EditAnsweredPrompts> createState() => _EditAnsweredPromptsState();
}

TextEditingController answerController = TextEditingController();

String initialValue = "";

class _EditAnsweredPromptsState extends State<EditAnsweredPrompts> {
  Future getAnswer() async {
    String query =
        "SELECT prompt_answer FROM users_prompt_answers WHERE owner_id='${userObj["user_id"]}' AND prompt_title = '${widget.promptId}'; ";
    var x = await executeQuery(query);
    print(x);
    setState(() {
      answerController.text = x;
      initialValue = x;
    });
  }

  @override
  void initState() {
    // TODO: fetch give answer and assign to controller
    getAnswer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: devWidth,
            height: 20,
          ),
          // Text(widget.promptId),
          Text(
            widget.promptTitle,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Container(
            height: devHeight * 0.2,
            width: devWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 3,
                color: greenShade,
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: widget.canEdit
                    ? TextField(
                        controller: answerController,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        maxLines: 6,
                      )
                    : Text(answerController.text)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
                onTap: () async {
                  if (answerController.text != initialValue) {
                    //TODO: submit answer to DB and pop back
                    executeQuery(
                      "UPDATE  users_prompt_answers SET prompt_answer = '${answerController.text}' WHERE owner_id $locallyFetchedUserId AND prompt_title = ${widget.promptId};",
                    );
                    answerController.clear();
                    Navigator.pop(context);
                  }
                },
                child: widget.canEdit
                    ? Icon(
                        Icons.check_circle,
                        color: answerController.text != initialValue
                            ? greenShade
                            : Colors.grey,
                        size: 40,
                      )
                    : Container()),
          )
        ],
      ),
    );
  }
}
