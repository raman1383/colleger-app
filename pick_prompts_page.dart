import 'package:colleger/main.dart';
import 'package:colleger/screens/answer_picked_prompt.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/material.dart';

class PickPrompts extends StatefulWidget {
  const PickPrompts({super.key});

  @override
  State<PickPrompts> createState() => _PickPromptsState();
}

bool userWantsToAnswerPrompt = false;

List<dynamic> promptTitleList = [];

TextEditingController promptAnswerController = TextEditingController();

List<List<String>> prompt_titles_suggestions = [
  [
    "چیزی سرگرم کننده، آسان و کم تعهد",
    "یک پارتنر بلند مدت",
    "وقت گذرونی و فان",
    "شریک رقص مادام العمر",
    "شارژر گوشیم ... جایی دیدیش؟"
  ],
  [
    "یا دقیقا مثل خودم یا کاملا متضاد خودم",
    "بتونیم باهم دنیارو فتح کنیم",
    "مثل خودم عاشق مهندسی کردن و درست کردن چیزا باشه",
    "با هم خوش بگذرونیم",
  ],
  [
    "غیبت کردن! ایییینقد حال میده",
    "یک فنجان قهوه داغ در یک روز سرد",
    "راه رفتن روی جدول های کنار خیابون",
    "قدم زدن زیر بارون"
  ],
  [
    "پولدارم",
    "حافظه من. هیچ وقت اسم، چهره یا تولدی را فراموش نمی کنم!",
    "من واقعا شنونده فوق العاده ای هستم",
    "دوستام میگن من توصیه های خوبی می کنم",
  ],
  [
    "سردرد و شقی همزمان",
    "خوردن فلفل داغ",
    "روی ترن هوایی بودن",
    "پرنسس بودنه. نمیزارم به هیچی دست بزنی",
  ],
  [
    "مثل یه کوالای تنبل میشم",
    "سخت تلاش میکنم و آیندمو میسازم, مثل بقیه روزا",
    "تا بعد از ظهر میخوابم",
    "...با دوستام میریم بیرون و ",
  ],
  [
    "خودتو بهم ثابت کن, بعد قرارم میریم",
    "میخوام همه چیو برنامه ریزی کنی و بیایی دنبالم. در ماشین رو هم برام باز من",
    "اول به صورت مجازی ازم بپرس سر قرار و اگه ازت خوشم بیاد تو دنیای واقعی میام سر قرار",
    "یه کبوتر پیامرسان بفرست با یک یادداشت و گزینه های بله و خیر",
  ],
  [
    "اینکه ما هر دو در مورد آنچه برای آینده می‌خواهیم توافق داریم.",
    "ارزش ها و باور هامون مثل هم دیگس",
    "دوستی. من می خواهم با بهترین دوستم قرار بگذارم",
    "که با هم خوش بگذرانیم و بخندیم",
  ],
  [
    "ارتباط. به من بگو واقعا چه احساسی داری!",
    "شب های جمعه شب - زمان با کیفیت برام مهمه!",
    "تو آشپزی کن، من تمیز می کنم. هرچی سعی می کنم درست کنم رو می سوزونم",
    "تو باید گربه من را دوست داشته باشی...و کاری کنی که گربه من تو را دوست داشته باشد",
  ],
  [
    "کسی که تو کمتر از یک ساعت ریپلای میده",
    "قاتل سریالی نباشه",
    "کسی که ابتکار به خرج میده و اولین حرکت رو میکنه😉",
    "جلوم میره و درهارو برام باز میکنه",
  ],
  // [
  //   "آیندمون",
  //   "درمورد ایلان ماسک و مریخ رفتن",
  //   "اون روز با دوستام چیکارا کردیم",
  //   "سریال هایی مثل : بریکینگ بد و پیکی بلایندرز",
  // ],
  //!
  [
    "منو بخندونی",
    "پاهامو ماساژ بدی ",
    "شکمم. برام چیزای خوشمزه بخری و درست کنی",
    "علایق و عادت های مشابهی داسته باشیم",
  ],
  [
    "رفتن به باشگاه و پرس سینه و جلو بازو",
    "خوندن یه کتاب خوب",
    "غر زدن. دوستام لایق مدال طلان",
    "تمیز کردن و مرتب کردن",
  ],
  [
    "یه دست گریه و زاری کردن درست حسابی",
    "تیپ میزنم و با دوستام میریم دور دور",
    "دوباره نگاه کردن فیلم موردعلاقم",
    "دربارش غر میزنم",
  ],
  [
    "زندگی کاری و حرفه ای شون",
    "زندگی رومانتیک و عاشقانشون چون من میتونم ذات آدمارو بخونم",
    "فیلم و سریال. خدای فیلم و سریالم",
    "سفر و اینا",
  ],
  [
    "کی ازم میپرسی که بریم سر قرار",
    "چجوری آخر هفته هاتو میگذرونی",
    "چه چیزایی زندگیتو عوض کرده",
    "از اونایی که شبا دیر میخوابه یا صبحا زود بیدار میشه",
  ],
  [
    "ده سال آینده خودمونو کجا میبینیم",
    "هر دوتامون درون گرا هستیم",
    "ایلان ماسک محشره",
    "بچه میخوایم",
  ],
  [
    "از شغلم استعفا دادم که رویاهامو دنبال کنم",
    "نقل مکان کردن به یه شهر وقتی که تمام زندگیمو یه جای دیگه زندگی کردم",
    "به کسی که روش کراش داشتم درخواست رل دادم",
    "خریدن بیت کوین",
  ],
  [
    "از دیوار مدرسه بالا رفتم و فرار کردم",
    "دانلود کردن این برنامه",
    "هیچی خدایی",
    "ناسا رو هک کردم",
  ],
  [
    "توی لحظه زندگی کن",
    "بکن تا توانی",
    "دنیارو به جای بهتری تبدیل کن",
    "زندگی بدون عشق بی معنیه",
  ],
  [
    "از بستنی متنفرم, تو مدرسه خیلی مظلوم بودم, یه امضا از رونالدو دارم",
    "برنده المپیاد ریاضی بودم, یه بار تو باغ وحش شیر گازم گرفت, تو آمریکا به دنیا اومدم",
    "پولدارم, جوانم, لاغرم",
    "یه بچه دارم, یه شاسی بلند دارم, میتونم پرواز کنم",
  ],
  [
    "باز کردن در بطری نوشابه با دریل برقی",
    "مچ نشدن و چت نکردن با تو",
    "دست کم گرفتن تفنگ بادی",
    "موشک خانه ساز!",
  ],
  [
    "یه قرار رمانتیک",
    "تاب تاب ابازی",
    "فرار کردن و قایم شدن با هم",
    "اون چیزه...",
  ],
  [
    "صد کیلو پرس سینه میزنم",
    "میخوام کارایی باهام بکنی که سانسور میشن تو فیلما",
    "من بتمن هستم",
    "تو نیمه ی گمشده منی",
  ],
  [
    "عمر جاودانه, ثروت فراوان, بدن آرنولد",
    "برگرد توی چراغ, کلکه",
    "نیمه ی گمشدم. تمام",
    "کشف راز های هستی, و بیتا و آیدا.😉",
  ],
  [
    "افرادی که می توانند من را بخندانند",
    "هدف و آینده داشته باشه! نه بیکار و عار",
    "مکالمه خوب - بیا ساعت ها بنشینیم و صحبت کنیم",
    "هوش! فکت های سرگرم کننده مورد علاقه خود رو به من بگو",
  ],
];

class _PickPromptsState extends State<PickPrompts> {
  @override
  void initState() {
    //TODO: fetch prompt titles & fill promptTitleList
    getPromptTitles();
    super.initState();
  }

  Future getPromptTitles() async {
    String query = "SELECT prompt_title FROM prompts;";
    var x = await getPromptTitlesSql(query);
    setState(() {
      promptTitleList = x;
    });

    print(promptTitleList.length);
    print(prompt_titles_suggestions.length);
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("پرامپت مورعلاقتو جواب بده"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: devHeight * 0.8,
          width: devWidth * 0.99,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promptTitleList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 52, 52, 52),
                  ),
                  height: devHeight * 0.77,
                  width: devWidth * 0.88,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          // color: Colors.blue,
                        ),
                        height: devHeight * 0.2,
                        // width: devWidth * 0.88,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            promptTitleList[index],
                            style: const TextStyle(fontSize: 25),
                          ),
                        )),
                      ),
                      const Divider(
                        color: greenShade,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(255, 33, 243, 103),
                            ),
                        // height: devHeight * 0.48,
                        // width: devWidth * 0.88,
                        child: Center(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(11),
                              child: Column(
                                children: [
                                  const Text(
                                    " : جواب بعضی کاربرا  " "\n",
                                    style: TextStyle(
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "${prompt_titles_suggestions[index][0]}\n",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${prompt_titles_suggestions[index][1]}\n",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${prompt_titles_suggestions[index][2]}\n",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${prompt_titles_suggestions[index][3]}\n",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnswerPickedPromptPage(
                                  promptIdInDB: index + 1),
                            ),
                          );
                        },
                        child: userWantsToAnswerPrompt == false
                            ? const Icon(
                                Icons.mode_edit_outline,
                                size: 45,
                                color: greenShade,
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
