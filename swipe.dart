import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:colleger/main.dart';
import 'package:colleger/screens/match_screen.dart';
import 'package:colleger/screens/money_page.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Swipe extends StatefulWidget {
  const Swipe({super.key});

  @override
  State<Swipe> createState() => voluntarily();
}

//TODO: filter by age and proximity -> premium feature
//TODO: save profiles for later view / on visit , give roses

const double earthRadius = 6371.0; // Earth radius in kilometers
int calcDateDiffInDays(String start, String end) {
  print(start);
  print(end);
  DateTime startDate = DateTime.parse(start);
  print("----");
  print(startDate);
  DateTime endDate = DateTime.parse(end);
  Duration calculateDateTimeDifference(DateTime startDate, DateTime endDate) {
    // Calculate the difference between endDate and startDate
    Duration difference = endDate.difference(startDate);
    return difference;
  }

  Duration difference = calculateDateTimeDifference(startDate, endDate);
  print(difference.inDays);
  return difference.inDays;
}

String getDateAsString(Jalali date) {
  String month = "";
  if (date.month <= 9) {
    month = "0${date.month}";
  } else {
    month = date.month.toString();
  }
  String day = "";
  if (date.day <= 9) {
    day = "0${date.day}";
  } else {
    day = date.day.toString();
  }
  String nowStr =
      "${date.year}-$month-$day ${date.hour}0:${date.minute}0:${date.second}0";
  return nowStr;
}

enum CandidateAddMethod {
  alreadyLikedYou,
  voluntarilyQueued,
  addedBySys,
}

List<(String, CandidateAddMethod)> cardQueue = [
  ("11", CandidateAddMethod.addedBySys),
  ("7", CandidateAddMethod.addedBySys)
]; // list of candidate user_ids, length = swipes remaining

List<String> candidateGeneralData = [];
List<String> candidatePics = [];
//title, answer
List<(String, String)> candidatePrompts = [];
// first get likers, then queue-eds, then fill remaining with sys

class voluntarily extends State<Swipe> {
  List<String> interestsAndHobbies = [
    "کوه نوردی",
    "گیمینگ",
    "برنامه نویسی",
    "باشگاه و بدن سازی",
    "عکاسی",
    "رقص",
    "آشپزی",
    "فیلم و سریال"
  ];

  AppinioSwiperController swipeController = AppinioSwiperController();
  Jalali now = Jalali.now();

  bool likePulse = false;
  bool disLikePulse = false;

  bool hitsSave = false;

  (String, String) currentCandidateLocationx = ("", "");
  (String, String) accOwnerLocationx = ("", "");

  bool hasLocation = false;
  bool hasSubs = false;
  bool genderIsMale = true;
  int remainingDailyLimit = 0;

  Future getCardDataById(String candidateUserId) async {
    String queryForData =
        "SELECT verified,first_name,user_name,birth_date,height,bio FROM users WHERE user_id = '$candidateUserId';";
    String queryForPics =
        "SELECT pic_link FROM profile_pics WHERE owner_id = '$candidateUserId';";
    String queryForPrompt =
        "SELECT p.prompt_title, upa.prompt_answer FROM users_prompt_answers upa JOIN prompts p ON upa.prompt_title = p.prompt_id WHERE upa.owner_id = '$candidateUserId';";

    String queryForCandidateLocation =
        "SELECT latitude,longitude FROM locations WHERE owner_id = '$candidateUserId';";
    var candidLoc = await getLocationSql(queryForCandidateLocation);
    String queryForOwnerLocation =
        "SELECT latitude,longitude FROM locations WHERE owner_id = '$accountOwnerId';";

    var accLoc = await getLocationSql(queryForOwnerLocation);
    setState(() {
      currentCandidateLocationx = candidLoc;
      accOwnerLocationx = accLoc;
      hasLocation = true;
    });

    //
    print("await executeQuery(queryForData) : ");
    var x = await getCandidateGeneralDate(queryForData);
    setState(() {
      candidateGeneralData = x;
    });
    print("##$x");

    List<(String, String)> candidatePromptsList =
        await getPromptTitlesAndAnswers(queryForPrompt);
    setState(() {
      print("candidatePromptsList: ");
      print(candidatePromptsList);
      candidatePrompts = candidatePromptsList;
    });

    var pics = await getPicLinks(queryForPics);
    setState(() {
      candidatePics = pics;
    });
  }

//TODO
  Future getCardsData(String userId) async {
    // general info, interests cloud, prompts, pics
    // CardObj cardObj = getCardsDataSql(userId);
  }

  Future checkGender() async {
    bool genderIsMaleX = await executeQuery(
            "SELECT (gender_is_male) FROM users WHERE user_id=$accountOwnerId;") ==
        "1";
    setState(() {
      genderIsMale = genderIsMaleX;
    });
    print("--- checkGender() --- gender: $genderIsMaleX");
    _setupGender.value = true;
  }

  Future checkIfHasSubscription() async {
    var subsEndDate = await executeQuery(
        "SELECT (subs_end_date) FROM users WHERE user_id = '$accountOwnerId';");
    // no subs or 31 days from subs:

    if (subsEndDate != "") {
      if (calcDateDiffInDays(getDateAsString(now), subsEndDate) > 0) {
        // print(calcDateDiffInDays(getDateAsString(now), subsEndDate));
        setState(() {
          hasSubs = true;
          // print("----- HAS SUBS --------");
        });
      }
    }
    print("--- checkIfHasSubscription() --- hasSubs: $hasSubs");
    _setupSubscription.value = true;
  }

  Future checkAndUpdateDailyLimit() async {
    //get limit_remaining and time_of_last_limit_end(if 1 day age->reset limit)
    if (hasSubs || !genderIsMale) {
      setState(() {
        remainingDailyLimit = 99;
      });
    } else {
      //TODO: get time_of_last_limit_end and if one day age -> reset limit_remaining
      var timeOfLastLimitEnd = await executeQuery(
        "SELECT (time_of_last_limit_end) FROM users WHERE user_id=$accountOwnerId;",
      );

      int diff = calcDateDiffInDays(
        timeOfLastLimitEnd,
        getDateAsString(now),
      );
      if (diff >= 1 && genderIsMale) {
        // reset limit and update to today
        await executeQuery(
            "UPDATE users SET time_of_last_limit_end = '${getDateAsString(now)}' WHERE user_id = $accountOwnerId;");
        await executeQuery(
            "UPDATE users SET limit_remaining = 10 WHERE user_id = $accountOwnerId;");
        setState(() {
          remainingDailyLimit = 10;
        });
      } else {
        int dailyLimitRemainder = int.parse(await executeQuery(
            "SELECT (limit_remaining) FROM users WHERE user_id=$accountOwnerId;"));
        setState(() {
          remainingDailyLimit = dailyLimitRemainder;
        });
      }
    }
    print("--- checkAndUpdateDailyLimit() --- limit: $remainingDailyLimit");
    _setupDailyLimit.value = true;
  }

  Future getProperCardsToShow() async {
    // empty out and prepare for next batch
    setState(() {
      cardQueue.clear();
    });

    int batchLimit = 0;
    if (remainingDailyLimit > 5) {
      batchLimit = 5;
    } else if (remainingDailyLimit <= 5 && remainingDailyLimit >= 1) {
      batchLimit = remainingDailyLimit;
    } else if (remainingDailyLimit == 0) {
      batchLimit = 0;
      // setState(() {
      //   // reached daily limit
      // });
    }

    print(
        "---### hasSubs: $hasSubs remaining limit: $remainingDailyLimit  gender: $genderIsMale ###---");
    // setState(() {
    //   cardQueue.add(("value", CandidateAddMethod.alreadyLikedYou));
    // });

    //!  5 at a time
    //TODO: add likers to beginning fo swipe queue, then fill with sys
    //TODO: for paid-tier: filter by age & proximity,
    //TODO: for free-tier: calc daily-limit(reset-date,gender) get other-gender within 20KM radius, each swipe gets closer to daily limit
    //TODO: exclude the ones already matched with

    //query likers,

    // List<(String, CandidateAddMethod)> alreadyLikedYou = [];

    // String likersQuery =
    //     "SELECT (liker_id) FROM likes WHERE likee_id=$accountOwnerId LIMIT $batchLimit;";
    // List<String> strings = await gettingLikersIdSql(likersQuery);
    // for (var str in strings) {
    //   alreadyLikedYou.add((str, CandidateAddMethod.alreadyLikedYou));
    // }

    // // sys fill
    // List<(String, CandidateAddMethod)> sysFill = [];

    // if (alreadyLikedYou.length < batchLimit) {
    //   //TODO: exclude self from sysFill
    //   // int limit = batchLimit - alreadyLikedYou.length;
    //   String sysFillQuery =
    //       "SELECT (user_id) FROM users WHERE  LIMIT $batchLimit";
    //   List<String> strings = await getBulkSql(sysFillQuery, "user_id");
    //   for (var str in strings) {
    //     sysFill.add((str, CandidateAddMethod.alreadyLikedYou));
    //   }
    // }

    // setState(() {
    //   print("alreadyLikedYou: $alreadyLikedYou  sysFill: $sysFill");
    //   cardQueue.addAll(alreadyLikedYou);
    //   cardQueue.addAll(sysFill);
    // });

    print("--- getProperCardsToShow() ---");
    print(cardQueue);
    print("--- getProperCardsToShow() ---");
  }

  final _setupGender = ValueNotifier<bool?>(null); // initial value is null
  final _setupSubscription =
      ValueNotifier<bool?>(null); // initial value is null
  final _setupDailyLimit = ValueNotifier<bool?>(null); // initial value is null

  Future resolveSetup() async {
    if (_setupGender.value == true &&
        _setupSubscription.value == true &&
        _setupDailyLimit.value == true) {
    } else {
      print("calling setups...");
      await checkGender();
      print("await checkGender()  <DONE>");
      await checkIfHasSubscription();
      print("await checkIfHasSubscription()  <DONE>");
      await checkAndUpdateDailyLimit();
      print("await checkAndUpdateDailyLimit()  <DONE>");
      await getProperCardsToShow();
      print("await getProperCardsToShow()  <DONE>");
    }
  }

  @override
  void initState() {
    resolveSetup();
    super.initState();
  }

  double calcAge(String birthDate) {
    print("in calcAge...");
    //convert to date, get now, calc diff in years
    Jalali now = Jalali.now();
    return (calcDateDiffInDays(birthDate, getDateAsString(now)) / 365);
  }

  // get 2 appropriate user_ids / fetch one after one swipe
  // get card info by user_id and render

  double calculateDistance((String, String) loc1, (String, String) loc2) {
    print("in calculateDistance...");
    double degreesToRadians(double degrees) {
      return degrees * pi / 180;
    }

    double lat1 = double.parse(loc1.$1);
    double lon1 = double.parse(loc1.$2);
    double lat2 = double.parse(loc2.$1);
    double lon2 = double.parse(loc2.$2);

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    double distanceInKm = earthRadius * c;

    // Convert distance to meters
    double distanceInMeters = distanceInKm * 1000;

    return distanceInMeters;
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        shadowColor: greenShade,
        centerTitle: true,
        // backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
//                 await executeQuery(
//                     """INSERT INTO `prompts` VALUES (1,'...Ú†Ù‡ Ù†ÙˆØ¹ Ø±Ø§Ø¨Ø·Ù‡ Ø§ÛŒ Ù…ÛŒØ®ÙˆØ§Ù…'),(2,'...Ù…Ù† Ø¯Ù†Ø¨Ø§Ù„ Ú©Ø³ÛŒ Ù‡Ø³ØªÙ… Ú©Ù‡'),(3,'...Ù„Ø°Øª Ù‡Ø§ÛŒ Ø³Ø§Ø¯Ù‡ Ù…Ù†'),(4,'...Ø¨Ø²Ø±Ú¯ØªØ±ÛŒÙ† Ù‚Ø¯Ø±Øª Ù…Ù†'),(5,'...Ø±Ù„ Ù…Ù† Ø¨ÙˆØ¯Ù† Ù…Ø«Ù„'),(6,'...Ø¢Ø®Ø± Ù‡ÙØªÙ‡ Ù…Ø¹Ù…ÙˆÙ„ÛŒ'),(7,'...Ø¨Ù‡ØªØ±ÛŒÙ† Ø±Ø§Ù‡ Ø¨Ø±Ø§ÛŒ Ø¯Ø±Ø®ÙˆØ§Ø³Øª Ø³Ø± Ù‚Ø±Ø§Ø± Ø§ÙˆÙ…Ø¯Ù† Ø§Ø² Ù…Ù† Ø§ÛŒÙ† Ø§Ø³Øª Ú©Ù‡'),(8,'...Ø¨Ù‡ Ù†Ø¸Ø±Ù… ÙˆÛŒÚ˜Ú¯ÛŒ Ø¨Ø§Ø±Ø² ÛŒÚ© Ø±Ø§Ø¨Ø·Ù‡ Ø®ÙˆØ¨ Ø§ÛŒÙ† Ø§Ø³Øª Ú©Ù‡'),(9,'...Ú†ÛŒØ²ÛŒ Ú©Ù‡ Ø¨Ø±Ø§ÛŒ Ù…Ù† ØºÛŒØ±Ù‚Ø§Ø¨Ù„ Ù…Ø°Ø§Ú©Ø±Ù‡ Ø§Ø³Øª'),(10,'...Ù¾Ø±Ú†Ù… Ù‡Ø§ÛŒ Ø³Ø¨Ø²ÛŒ(ÙˆÛŒÚ˜Ú¯ÛŒ Ù‡Ø§ÛŒ Ø®ÙˆØ¨) Ú©Ù‡ Ø¯Ù†Ø¨Ø§Ù„Ø´ÙˆÙ†Ù…'),(11,'...Ú©Ù„ÛŒØ¯ Ø¨Ù‡ Ù‚Ù„Ø¨ Ù…Ù† Ø§ÛŒÙ† Ø§Ø³Øª'),(12,'...Ù…Ù† Ø®ÙˆØ¯Ù…Ùˆ Ø§Ø² ÛŒÚ© Ø­Ø§Ù„ Ø±ÙˆØ­ÛŒ Ø¨Ø¯ Ø¯Ø±Ù…ÛŒØ§Ø±Ù… Ø¨Ø§'),(13,'...Ú†ÛŒØ²Ø§ÛŒÛŒ Ú©Ù‡ Ø¯ÙˆØ³ØªØ§Ù… Ø¯Ø±Ø¨Ø§Ø±Ø´ Ø§Ø²Ù… Ù†ØµÛŒØ­Øª Ù…ÛŒÙ¾Ø±Ø³Ù†'),(14,'...Ù…Ù† Ø¢Ø±ÙˆÙ… Ù…ÛŒØ´Ù… Ø¨Ø§'),(15,'...ØªÙ†Ù‡Ø§ Ú†ÛŒØ²ÛŒ Ú©Ù‡ Ø¯ÙˆØ³Øª Ø¯Ø§Ø±Ù… Ø¯Ø±Ø¨Ø§Ø±Ù‡ ØªÙˆ Ø¨Ø¯ÙˆÙ†Ù… Ø§ÛŒÙ† Ø§Ø³Øª Ú©Ù‡'),(16,'...Ø¨ÛŒØ§ Ù…Ø·Ù…Ø¦Ù† Ø´ÛŒÙ… Ú©Ù‡ Ø¨Ø§Ù‡Ù… ØªÙˆØ§ÙÙ‚ Ø¯Ø§Ø±ÛŒÙ… Ø¯Ø±Ø¨Ø§Ù‡'),(17,'...Ø¨Ø²Ø±Ú¯ØªØ±ÛŒÙ† Ø±ÛŒØ³Ú© Ù‡Ø§ÛŒÛŒ Ú©Ù‡ Ú©Ø±Ø¯Ù…'),(18,'...Ø®ÙˆØ¯Ø¬ÙˆØ´ ØªØ±ÛŒÙ† Ú©Ø§Ø±ÛŒ Ú©Ù‡ Ø§Ù†Ø¬Ø§Ù… Ø¯Ø§Ø¯Ù…'),(19,'...Ø´Ø¹Ø§Ø± Ø²Ù†Ø¯Ú¯ÛŒ Ù…Ù† Ø§ÛŒÙ†Ù‡ Ú©Ù‡'),(20,'...Ø¯Ùˆ  ØªØ§ Ø­Ù‚ÛŒÙ‚Øª Ùˆ ÛŒÚ© Ø¯Ø±ÙˆØº Ø¯Ø±Ø¨Ø§Ø±Ù‡ Ù…Ù† '),(21,'...Ø¨Ø¯ØªØ±ÛŒÙ† Ø§ÛŒØ¯Ù‡ Ø§ÛŒ Ú©Ù‡ ØªÙˆ Ø¹Ù…Ø±Ù… Ø¯Ø§Ø´ØªÙ…'),(22,'...Ù…Ù† Ø¨Ù‡ØªØ±ÛŒÙ† Ø¬Ø§ÛŒ Ø´Ù‡Ø±Ùˆ Ù…ÛŒØ¯ÙˆÙ†Ù… Ø¨Ø±Ø§ÛŒ'),(23,'...Ú†ÛŒÚ©Ø§Ø± Ù…ÛŒÚ©Ù†ÛŒ Ø§Ú¯Ù‡ Ø¨Ù‡Øª Ø¨Ú¯Ù… Ú©Ù‡'),(24,'...Ø§Ú¯Ù‡ ØºÙˆÙ„ Ú†Ø±Ø§Øº Ø¬Ø§Ø¯Ùˆ Ø³Ù‡ ØªØ§ Ø¢Ø±Ø²Ùˆ Ø¨Ø±Ø§Ù… Ø¨Ø±Ø§ÙˆØ±Ø¯Ù‡ Ù…ÛŒÚ©Ø±Ø¯, Ø³Ù‡ ØªØ§ Ø¢Ø±Ø²ÙˆÙ…'),(25,'...Ù…Ù† Ø¨Ù‡ Ø·Ø±Ø² Ø¹Ø¬ÛŒØ¨ÛŒ Ø¬Ø°Ø¨');
// """);
              },
              child: SizedBox(
                height: devHeight * 0.1,
                width: devWidth * 0.1,
                child: Image.asset(
                  "./assets/logo.jpeg",
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
              height: devHeight * 0.69,
              child: FutureBuilder(
                  future: resolveSetup(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(child: HeartLoading());
                    // }
                    // if (value == null) {
                    //   checkSetup();
                    //   return const HeartLoading();
                    // }
                    return AppinioSwiper(
                      allowUnSwipe: true,
                      onSwipeBegin: (previousIndex, targetIndex, activity) {
                        // if (previousIndex == cardQueue.length - 2) {
                        //   setState(() {
                        //     //: fetch next candidate and append to cardQueue
                        //     cardQueue.add("value");
                        //     print("object");
                        //   });
                        // }
                        setState(() {
                          if (activity.direction == AxisDirection.right) {
                            likePulse = true;
                          }
                          if (activity.direction == AxisDirection.left) {
                            disLikePulse = true;
                          }
                        });
                      },
                      onSwipeEnd: (previousIndex, targetIndex, activity) async {
                        setState(() {
                          if (activity.direction == AxisDirection.right) {
                            likePulse = false;
                          }
                          if (activity.direction == AxisDirection.left) {}
                          disLikePulse = false;
                        });

                        if (activity.direction == AxisDirection.right) {
                          //! check , if none, create, if mutual->delete from likes and create matches record,
                          // var likers = await getBulkSql(
                          //     "SELECT liker_id FROM likes WHERE likee_id = '$accountOwnerId' AND liker_id = '${cardQueue[previousIndex]}';",
                          //     "liker_id");
                          // print("list of likers : ");
                          // print(likers);

                          // if (likers.isEmpty) {
                          //   if (previousIndex != targetIndex + 1) {
                          //     print(targetIndex);
                          //     print(previousIndex);
                          //     executeQuery(
                          //         "INSERT INTO likes(liker_id,likee_id)VALUES('$accountOwnerId','${cardQueue[previousIndex]}');");
                          //   }
                          // }
                          // if (likers.isNotEmpty) {
                          //                                   await executeQuery(
                          //       "INSERT INTO matches(side_a,side_b,cause)VALUES('$accountOwnerId','${cardQueue[previousIndex]}','mutual');");

                          //   //TODO: if addMethod is through like: match, else: insert into likes. ifQueue: notif the acc/rej

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Match(
                                withRose: false,
                                candidateId: cardQueue[previousIndex].$1,
                                candidatesName: candidateGeneralData[2],
                              ),
                            ),
                          );

                          //!  send a message to other side!: fetch candidates phone number and and send a "got match" SMS
                          // }
                        }
                        // if (cardQueue.length > targetIndex + 1) {
                        //   setState(() {
                        //     currentCandidateUserId = cardQueue[targetIndex];
                        //   });
                        // }

                        setState(() {
                          hitsSave = false;
                        });

                        await executeQuery(
                          "UPDATE users SET daily_limit = daily_limit-1 WHERE user_id = $accountOwnerId",
                        );
                      },
                      onEnd: () async {
                        // await getProperCardsToShow();
                      },
                      threshold: 200,
                      duration: const Duration(milliseconds: 500),
                      backgroundCardOffset: const Offset(10, 50),
                      swipeOptions: const SwipeOptions.only(
                        left: true,
                        right: true,
                      ),
                      cardCount: cardQueue.length,
                      backgroundCardCount: 1,
                      controller: swipeController,
                      cardBuilder: (BuildContext context, int indexOfCards) {
                        return FutureBuilder(
                            future: getCardsData(cardQueue[indexOfCards].$1),
                            builder: (context, snapshot) {
                              return GlassContainer.clearGlass(
                                // borderColor: greenShade,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(27)),
                                height: devHeight * 0.7,
                                width: devWidth * 0.95,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),

                                    //TODO: render proper info on card based on candidate ID

                                    child: ListView.builder(
                                      itemCount: max(candidatePics.length,
                                          candidatePrompts.length),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            index == 0
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        color: const Color
                                                            .fromARGB(
                                                            152, 0, 0, 0),
                                                        // height: devHeight * 0.23,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              //! render according to verification status
                                                              child: userObj[
                                                                          "verified"] ==
                                                                      "none"
                                                                  ? const Icon(
                                                                      Icons
                                                                          .radio_button_checked_sharp,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 30,
                                                                    )
                                                                  : userObj["verified"] ==
                                                                          "pending"
                                                                      ? const Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color:
                                                                              Colors.yellow,
                                                                          size:
                                                                              30,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .check_circle_sharp,
                                                                          color:
                                                                              greenShade,
                                                                          size:
                                                                              30,
                                                                        ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  devHeight *
                                                                      0.025,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  candidateGeneralData[
                                                                      1],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      devWidth *
                                                                          0.015,
                                                                ),
                                                                const Icon(
                                                                  Icons.circle,
                                                                  color:
                                                                      greenShade,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      devWidth *
                                                                          0.015,
                                                                ),

                                                                //!

                                                                Text(
                                                                  calcAge(candidateGeneralData[
                                                                          3])
                                                                      .toString()
                                                                      .substring(
                                                                          0, 2),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        25,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            237,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      devWidth *
                                                                          0.015,
                                                                ),
                                                                const Icon(
                                                                  Icons.circle,
                                                                  color:
                                                                      greenShade,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      devWidth *
                                                                          0.015,
                                                                ),
                                                                Text(
                                                                  ("${candidateGeneralData[4][0]}.${candidateGeneralData[4][1]}${candidateGeneralData[4][2]}"),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  devHeight *
                                                                      0.04,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "@",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color:
                                                                            greenShade,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      candidateGeneralData[
                                                                          2],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_searching,
                                                                      color:
                                                                          greenShade,
                                                                    ),
                                                                    // Text(
                                                                    //   hasLocation
                                                                    //       ? calculateDistance(accOwnerLocationx, currentCandidateLocationx)
                                                                    //           .toString()
                                                                    //       : "...",
                                                                    //   style:
                                                                    //       const TextStyle(
                                                                    //     fontSize:
                                                                    //         25,
                                                                    //     color: Colors
                                                                    //         .white,
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: devWidth *
                                                                  0.065,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 15,
                                                                      bottom:
                                                                          15),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (hitsSave ==
                                                                          false) {
                                                                        setState(
                                                                            () {
                                                                          hitsSave =
                                                                              true;
                                                                        });
                                                                        print(userObj[
                                                                            "user_id"]);
                                                                        print(cardQueue[
                                                                            index]);
                                                                        await executeQuery(
                                                                          "INSERT INTO saved(saver_id,saved_id) VALUES(${userObj["user_id"]},${cardQueue[index]});",
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                      hitsSave
                                                                          ? Icons
                                                                              .bookmark_add
                                                                          : Icons
                                                                              .bookmark_add_outlined,
                                                                      color:
                                                                          greenShade,
                                                                      size: 40,
                                                                    ),
                                                                  ),
                                                                  // const Icon(
                                                                  //   CupertinoIcons
                                                                  //       .share,
                                                                  //   color: greenShade,
                                                                  //   size: 40,
                                                                  // ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      // var rosesSendableCount =
                                                                      //     await executeQuery(
                                                                      //         "SELECT roses_sendable_count FROM users WHERE user_id = '$accountOwnerId';");
                                                                      // int rosesSendableCountInt =
                                                                      //     int.parse(
                                                                      //         rosesSendableCount);
                                                                      // // print(int.parse(
                                                                      // //     rosesSendableCount));
                                                                      // if (rosesSendableCountInt >
                                                                      //     0) {
                                                                      //   //delete Like record, create a match record, nav to Match
                                                                      //   await executeQuery(
                                                                      //     "DELETE FROM likes WHERE liker_id='${cardQueue[index]}';",
                                                                      //   );
                                                                      //   await executeQuery(
                                                                      //       "INSERT INTO matches(side_a, side_b, cause)VALUES('$accountOwnerId','${cardQueue[index]}','rose');");
                                                                      //   //TODO:
                                                                      //   Navigator.push(
                                                                      //     context,
                                                                      //     MaterialPageRoute(
                                                                      //       builder:
                                                                      //           (context) =>
                                                                      //               Match(
                                                                      //         withRose:
                                                                      //             true,
                                                                      //         candidateId:
                                                                      //             cardQueue[
                                                                      //                 index],
                                                                      //         candidatesName:
                                                                      //             candidateGeneralData[
                                                                      //                 2],
                                                                      //       ),
                                                                      //     ),
                                                                      //   );
                                                                      // } else {
                                                                      //   Navigator.push(
                                                                      //     context,
                                                                      //     MaterialPageRoute(
                                                                      //       builder:
                                                                      //           (context) =>
                                                                      //               const Money(),
                                                                      //     ),
                                                                      //   );
                                                                      // }

                                                                      //!

                                                                      // await giveRose(
                                                                      //   context,
                                                                      //   cardQueue[
                                                                      //       index],
                                                                      //   candidateGeneralData[
                                                                      //       2],
                                                                      // );

                                                                      swipeController
                                                                          .swipeRight();

                                                                      // Navigator.push(
                                                                      //   context,
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) => const Match(),
                                                                      //   ),
                                                                      // );
                                                                      //                 await executeQuery("""
                                                                      // DELETE FROM users;

                                                                      // """);
                                                                    },
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      // color: Colors.blueAccent,
                                                                      child: Image
                                                                          .asset(
                                                                              "./assets/Screenshot 2024-03-03 180142 (1) (1).png"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                bottom: 11,
                                                                right: 11,
                                                                left: 11,
                                                              ),
                                                              child: Text(
                                                                candidateGeneralData[
                                                                    5],
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            index > candidatePics.length - 1
                                                ? Container()
                                                : index >=
                                                        min(
                                                            candidatePics
                                                                .length,
                                                            candidatePrompts
                                                                .length)
                                                    ? Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 25,
                                                                    bottom: 25),
                                                            child:
                                                                FullScreenWidget(
                                                              disposeLevel:
                                                                  DisposeLevel
                                                                      .Medium,
                                                              child:
                                                                  Image.network(
                                                                "http://dl.colleger.ir/ftpUser/${candidatePics[index]}",
                                                                errorBuilder: (context,
                                                                        child,
                                                                        loadingProgress) =>
                                                                    const HeartLoading(),
                                                                // loadingBuilder: (context,
                                                                //         child,
                                                                //         loadingProgress) =>
                                                                //     const HeartLoading(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : FullScreenWidget(
                                                        disposeLevel:
                                                            DisposeLevel.Medium,
                                                        child: Image.network(
                                                          "http://dl.colleger.ir/ftpUser/${candidatePics[index]}",
                                                          errorBuilder: (context,
                                                                  child,
                                                                  loadingProgress) =>
                                                              const HeartLoading(),
                                                          // loadingBuilder: (context, child,
                                                          //         loadingProgress) =>
                                                          //     const HeartLoading(),
                                                        ),
                                                      ),
                                            index > candidatePrompts.length - 1
                                                ? Container()
                                                : index >=
                                                        min(
                                                            candidatePics
                                                                .length,
                                                            candidatePrompts
                                                                .length)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 25,
                                                                bottom: 25),
                                                        child: Container(
                                                          width:
                                                              devWidth * 0.99,
                                                          color: const Color
                                                              .fromARGB(
                                                              152, 0, 0, 0),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                candidatePrompts[
                                                                        index]
                                                                    .$1,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 22,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                candidatePrompts[
                                                                        index]
                                                                    .$2,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: devWidth * 0.99,
                                                        color: const Color
                                                            .fromARGB(
                                                            152, 0, 0, 0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              candidatePrompts[
                                                                      index]
                                                                  .$1,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 22,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              candidatePrompts[
                                                                      index]
                                                                  .$2,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                            index + 1 ==
                                                    max(candidatePics.length,
                                                        candidatePrompts.length)
                                                ? SizedBox(
                                                    height: devHeight * 0.35,
                                                  )
                                                : Container(),
                                          ],
                                        );

                                        //!
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  })
              // : Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text(" دسترسی به موقعیت مکانی لازم است "),
              //       const SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () async {},
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: greenShade,
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: const Padding(
              //             padding: EdgeInsets.all(25.0),
              //             child: Text(
              //               "اجازه دادن",
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   )
              // : Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text(
              //         "به سقف استفاده روزانه رسیدید",
              //         style: TextStyle(fontSize: 22),
              //       ),
              //       const SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const Money(),
              //             ),
              //           );
              //         },
              //         child: Container(
              //           height: devHeight * 0.1,
              //           width: devWidth * 0.6,
              //           decoration: BoxDecoration(
              //             color: const Color.fromARGB(255, 72, 71, 70),
              //             borderRadius: BorderRadiusDirectional.circular(20),
              //           ),
              //           child: const Center(
              //               child: Text(
              //             "خرید اشتراک و ارتقاء",
              //             style: TextStyle(fontSize: 22),
              //           )),
              //         ),
              //       )
              //     ],
              //   ),
              ),
          SizedBox(height: devHeight * 0.025),
          SizedBox(
            width: devWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  //TODO: onTap show toolTip: says to swipe either slide cards or double tap on icon
                  onTap: () {
                    swipeController.swipeLeft();
                  },
                  child: Icon(
                    disLikePulse
                        ? CupertinoIcons.heart_slash_fill
                        : CupertinoIcons.heart_slash,
                    color: Colors.red,
                    size: 60,
                  ),
                ),
                //TODO: go to te previous card
                GestureDetector(
                  onTap: () async {
                    // bool hasSubs = await executeQuery(
                    //         "SELECT (has_subscription) FROM users WHERE user_id = '$accountOwnerId';") ==
                    //     "1";
                    if (hasSubs) {
                      swipeController.unswipe();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Money(),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    !hasSubs ? Icons.lock_reset : Icons.replay,
                    size: 40,
                  ),
                ),

                // SizedBox(width: devWidth * 0.1),

                GestureDetector(
                  //TODO: onTap show toolTip: says to swipe either slide cards or double tap on icon
                  onTap: () async {
                    // executeQuery(
                    //     "INSERT INTO likes(liker_id,likee_id,last_update) VALUES ($accountOwnerId, $currentCandidateUserId,$now);");
                    swipeController.swipeRight();
                  },
                  child: Icon(
                    likePulse
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: greenShade,
                    size: 63,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
