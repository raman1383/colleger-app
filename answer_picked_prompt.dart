import 'package:colleger/main.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';

class AnswerPickedPromptPage extends StatefulWidget {
  final int promptIdInDB;

  const AnswerPickedPromptPage({super.key, required this.promptIdInDB});

  @override
  State<AnswerPickedPromptPage> createState() => _AnswerPickedPromptPageState();
}

String promptTitle = "-";
TextEditingController answerController = TextEditingController();

class _AnswerPickedPromptPageState extends State<AnswerPickedPromptPage> {
  @override
  void initState() {
    //! fetch prompt
    print("object--> ${widget.promptIdInDB}");
    fetchPromptTitleById();
    super.initState();
  }

  Future fetchPromptTitleById() async {
    String query =
        "SELECT prompt_title FROM prompts WHERE prompt_id = '${widget.promptIdInDB}';";
    String x = await executeQuery(query);
    setState(() {
      promptTitle = x;
    });

    print(x);
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Text(
                promptTitle,
                style: const TextStyle(
                  fontSize: 25,
                ),
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
                child: TextField(
                  controller: answerController,
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
                  executeQuery(
                    "INSERT INTO users_prompt_answers(owner_id,prompt_title,prompt_answer) VALUES(${userObj["user_id"]},${widget.promptIdInDB},'${answerController.text}');",
                  );
                  answerController.clear();
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.check_circle,
                  color: answerController.text.isNotEmpty
                      ? greenShade
                      : Colors.grey,
                  size: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
