import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colleger/main.dart';
import 'package:colleger/screens/match_screen.dart';
import 'package:colleger/screens/money_page.dart';
import 'package:colleger/screens/signup.dart';
import 'package:colleger/utilities/card_obj.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

Future giveRose(
    BuildContext context, String receiverId, String receiverName) async {
  //TODO: check if has rose to give, ir does then reduce one and nav to Match, if not nav to Money
  var rosesSendableCount = await executeQuery(
      "SELECT roses_sendable_count FROM users WHERE user_id = '$accountOwnerId';");
  int rosesSendableCountInt = int.parse(rosesSendableCount);
  if (rosesSendableCountInt > 0) {
    String decreaseOneRose =
        "UPDATE users SET roses_sendable_count = roses_sendable_count-1 WHERE user_id = '$accountOwnerId';";
    await executeQuery(decreaseOneRose);
    String createMatchRecord =
        "INSERT INTO matches(side_a, side_b, cause)VALUES('$accountOwnerId',$receiverId,'rose');";
    await executeQuery(createMatchRecord);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Match(
            withRose: true,
            candidateId: receiverId,
            candidatesName: receiverName),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Money(),
      ),
    );
  }
}

Future<String> executeQuery(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/main.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying main.php executeQuery...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // If you expect some response from the PHP script, you can handle it here
      print("!");
      print(response.body);
      print("!");
      return response.body;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return response.body;
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return "ERR";
  }
}

/*
DB Name:  college6_main
DB User:  college6_main
Password: QJXxbpy4aCW78xtaj6PH
*/

Future<String> uploadImage(File imageFile) async {
  print("IN uploadImage(File imageFile...");
  var uri = Uri.parse('http://dl.colleger.ir/FTP_up.php');
  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    // Read the response stream and convert it to a string
    String responseString = await response.stream.bytesToString();
    return responseString;
  } else {
    throw Exception('Failed to upload image');
  }
}

Future sqlSignUp(
  String firstName,
  // String lastName,
  String userName,
  String phoneNumber,
  Jalali birthDate,
  bool genderIsMale,
  String password,
  File profilePic,
  (String, String) location,
) async {
  Jalali now = Jalali.now();

  // print(firstName);
  // print(lastName);
  // print(userName);
  // print(phoneNumber);
  String birthDateCompiled =
      "${birthDate.year}-${birthDate.month}-${birthDate.day}";

  Jalali prevDay = Jalali.now().add(days: -1);

  String prevDayStr =
      "${prevDay.year}-${prevDay.month}-${prevDay.day} ${prevDay.hour}:${prevDay.minute}:${prevDay.second}";

  // print(birthDateCompiled);
  // print(genderIsMale);
  // print(password);
  // print(location);
  // print(BCrypt.checkpw(pass_field.text, password));
  String accountCreated =
      "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
  String lastLogin =
      "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
  // print(lastLogin);
  // print(accountCreated);

  String secureUsername = userName;
  String secureFirstname = firstName;

  String sql = "";
  if (is_male) {
    sql =
        "INSERT INTO users(user_name,first_name,birth_date,gender_is_male,phone_number,password_hash,account_created,last_login, limit_remaining, time_of_last_limit_end)VALUES('$secureUsername','$secureFirstname','$birthDateCompiled',TRUE,'$phoneNumber','$password','$accountCreated','$lastLogin','10','$prevDayStr');";
  } else {
    sql =
        "INSERT INTO users(user_name,first_name,birth_date,gender_is_male,phone_number,password_hash,account_created,last_login,limit_remaining, time_of_last_limit_end)VALUES('$secureUsername','$secureFirstname','$birthDateCompiled',FALSE,'$phoneNumber','$password','$accountCreated','$lastLogin','100','$prevDayStr');";
  }
  await executeQuery(sql);

  //Fetch user_id and assign to first of tuple
  String getUserId =
      "SELECT user_id FROM users WHERE user_name = '$secureUsername';";
  String x = await executeQuery(getUserId);
  print("-$x-");
  int userId = int.parse(x.trim());

  //Fetch password_hash and assign to second of tuple
  String getPassHash =
      "SELECT password_hash FROM users WHERE user_name = '$secureUsername';";
  String passHash = await executeQuery(getPassHash);

  String picLink = await uploadImage(profilePic);
  print("profile pic link: $picLink");

  String sqlForProfilePic =
      "INSERT INTO profile_pics(owner_id,pic_link) VALUES($x,$picLink);";
  executeQuery(sqlForProfilePic);

  String lat = location.$1;
  String long = location.$2;
  String sqlForLocations = "INSERT INTO locations()VALUES();";
  executeQuery(sqlForLocations);

  //TODO: insert into locations

  return (userId, passHash);
}

Future<bool> checkUsernameAvailability(String candidateUsername) async {
  String secured = candidateUsername;
  String query =
      "SELECT COUNT(*) AS count FROM users WHERE user_name = '$secured';";

  String res = await executeQuery(query);
  if (res.contains("1")) {
    return true;
  } else {
    return false;
  }
}

Future<List<(bool, String)>> getMessagesSql(String query) async {
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying to get messages (in test.php)...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      List<(bool, String)> messages = [];

      //if sender_id = accownerid then bool TRUE else FALSE

      for (var item in parsedJson) {
        if (item["sender_id"] == accountOwnerId) {
          messages.add((false, item["message_content"]));
        }
        if (item["sender_id"] != accountOwnerId) {
          messages.add((true, item["message_content"]));
        }
      }

      return messages;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<(List<String>, List<String>)> getChatIdAndOthersIdsSql(
    String query) async {
  //
  return ([""], [""]);
}

Future<(List<String>, List<String>)> getOthersPicLinksAndFirstNamesSql(
    String query) async {
  //
  return ([""], [""]);
}

Future parseChats(String query) async {
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying to parse chats (in test.php)...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      print(parsedJson);

      List<String> chatIds = [];
      List<String> othersIds = [];
      List<String> othersPicLinks = [];
      List<String> othersFirstName = [];

      for (var item in parsedJson) {
        chatIds.add(item['chat_id']);
        othersIds.add(item['other_participant_id']);
        othersFirstName.add(item['other_participant_name']);
        othersPicLinks.add(item['other_participant_pic']);
      }

      List<List<String>> list = [
        chatIds,
        othersIds,
        othersFirstName,
        othersPicLinks,
      ];

      return list;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future parseLikers(String query) async {
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying to parse likees (in test.php)...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      print(parsedJson);

      List<String> othersIds = [];
      List<String> othersPicLinks = [];
      List<String> othersFirstName = [];

      for (var item in parsedJson) {
        othersIds.add(item['likee_id']);
        othersFirstName.add(item['first_name']);
        othersPicLinks.add(item['pic_link']);
      }

      List<List<String>> list = [
        othersIds,
        othersFirstName,
        othersPicLinks,
      ];

      return list;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future parseSaved(String query) async {
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying to parse saveds (in test.php)...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      print(parsedJson);

      List<String> othersIds = [];
      List<String> othersPicLinks = [];
      List<String> othersFirstName = [];

      for (var item in parsedJson) {
        othersIds.add(item['saved_id']);
        othersFirstName.add(item['first_name']);
        othersPicLinks.add(item['pic_link']);
      }

      List<List<String>> list = [
        othersIds,
        othersFirstName,
        othersPicLinks,
      ];

      return list;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<String>> getPicLinks(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php) getPicLinks...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> picLinks = [];

      for (var item in parsedJson) {
        picLinks.add(item['pic_link']);
      }

      return picLinks;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<(String, String)>> getPromptTitlesAndAnswers(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php) getPromptTitlesAndAnswers...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> titles = [];
      List<String> answers = [];

      print(response.body);

      for (var item in parsedJson) {
        titles.add(item['prompt_title']);
        answers.add(item['prompt_answer']);
      }

      print("prompts and answers");
      print(titles);
      print(answers);

      final collection = List<(String, String)>.filled(titles.length, ("", ""));
      for (var i = 0; i < titles.length; i++) {
        print("assigning to collection: ");
        collection[i] = (titles[i], answers[i]);
        print(collection[i]);
      }

      return collection;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<dynamic>> getPromptTitlesSql(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying  (in test.php) getPromptTitlesSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // List<dynamic> parsedJson = json.decode(response.body);
      // List<dynamic> promptTitles = [];

      List<String> parsedStrings = parsePersianText(response.body);
      for (var i = 0; i < parsedStrings.length; i++) {
        print(parsedStrings[i]);
        print("\n");
      }

      return parsedStrings;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<String>> getUsersPromptTitlesSql(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php) getUsersPromptTitlesSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> picLinks = [];

      for (var item in parsedJson) {
        picLinks.add(item["prompt_title"]);
      }

      return picLinks;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<String>> gettingCandidatesSql(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php) gettingCandidatesSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> candidateIds = [];

      for (var item in parsedJson) {
        candidateIds.add(item["user_id"]);
      }

      return candidateIds;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<(String, String)> getLocationSql(String query) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php) getLocationSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> parsedJson = json.decode(response.body);
      (String, String) candidateCoords = ("", "");

      for (var item in parsedJson) {
        candidateCoords = (item["latitude"], item["longitude"]);
      }

      return candidateCoords;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return ("", "");
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return ("", "");
  }
}

Future<List<String>> gettingLikersIdSql(String query) async {
  print(query);
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying (in test.php)  gettingLikersIdSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);
    print("in gettingLikersIdSql after post ${response.body}");
    // Check if the request was successful
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> candidateIds = [];

      for (var item in parsedJson) {
        candidateIds.add(item["liker_id"]);
        print(item);
      }

      return candidateIds;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<List<String>> getBulkSql(String query, String fieldName) async {
// URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying  test.php getBulkSql...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> parsedJson = json.decode(response.body);
      List<String> fieldNameList = [];

      for (var item in parsedJson) {
        fieldNameList.add(item[fieldName]);
      }
      print(fieldName);
      print(fieldNameList);
      return fieldNameList;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

List<String> parsePersianText(String jsonString) {
  List<dynamic> jsonList = jsonDecode(jsonString);
  List<String> parsedStrings = [];

  for (var item in jsonList) {
    String promptTitle = item['prompt_title'];
    String decodedString = _decodeUnicode(promptTitle);
    parsedStrings.add(decodedString);
  }

  return parsedStrings;
}

String _decodeUnicode(String input) {
  String decodedString = input.replaceAllMapped(RegExp(r'\\u(\w{4})'), (match) {
    int code = int.parse(match.group(1)!, radix: 16);
    return String.fromCharCode(code);
  });

  return decodedString;
}

// /// when shared_prefs does'nt has sufficient credentials
// Future<String> SqlLogIn(String userName, String password) async {
//   //TODO: hash the password
//   //TODO: update last_login
//   //TODO: security mesures : double-dashes, single/double quotes
//   String passHash = "";

//   String sql =
//       "SELECT user_id FROM users WHERE user_name = $userName AND password_hash = $passHash;";

//   //TODO: return user_id as sign of success and to save in shared_prefs
// }

/// when shared_prefs has sufficient credentials
Future<bool> sqlAutoLogIn(int userId, String passwordHash) async {
  //TODO: update last_login

  String sql =
      "SELECT COUNT(*) FROM users WHERE user_id = '$userId' AND password_hash = '$passwordHash';";

  String res = await executeQuery(sql);
  // print(res);
  if (res.contains("1")) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> fillUserObj(int userId) async {
  String query = "SELECT * FROM users WHERE user_id = '$userId';";

  // URL of your PHP script
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying test.php fillUserObj...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data = [];
      List<dynamic> jsonData = jsonDecode(response.body);
      data = jsonData.cast<Map<String, dynamic>>();
      Map<String, dynamic> x = data[0];

      print("${x['user_id']}");
      print("${data[0]['user_name']}");
      print("${data[0]['birth_date']}");
      print("${data[0]['first_name']}");
      print("${data[0]['weight']}");
      print("${data[0]['bio']}");
      print("${data[0]['verified']}");

      return x;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      Map<String, dynamic> data = {};
      return data;
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    Map<String, dynamic> data = {};
    return data;
  }
}

Future<List<String>> getCandidateGeneralDate(String query) async {
  // verified,first_name,user_name,birth_date,height,
  String url = 'https://colleger.ir/test.php';

  // Data to be sent in the HTTP POST request
  Map<String, String> data = {
    'query': query,
  };

  try {
    print("trying test.php  getCandidateGeneralDate...");
    // Send POST request
    var response = await http.post(Uri.parse(url), body: data);

    // Check if the request was successful
    if (response.statusCode == 200) {
      final data = List<String>.filled(6, "");

      print("------ generals ------------");
      print(response.body);
      print("------ generals ------------");
      List<dynamic> parsedJson = json.decode(response.body);
      print(parsedJson);
      print("------ generals ------------");
      // int i = 0;
      List<String> titList = [
        "verified",
        "first_name",
        "user_name",
        "birth_date",
        "height",
        "bio",
      ];
      for (var i = 0; i < 6; i++) {
        for (var item in parsedJson) {
          data[i] = item[titList[i]];
          // i += 1;
          print(i);
          print(item[titList[i]]);
        }
      }
      print("------ 0, 2, 4, 5 ------------");

      print(data[0]);
      print(data[2]);
      print(data[4]);
      print(data[5]);
      //TODO: parse resuls
      return data;
    } else {
      // Handle error if request fails
      print(' > > > > >Error: ${response.body}');
      return [];
    }
  } catch (e) {
    // Handle other types of errors
    print('Error (executeQuery): $e');
    return [];
  }
}

Future<CardObj> getCardsDataSql(String userId) async {
  String url = 'https://colleger.ir/test.php';

  String queryForGenerals =
      "SELECT verified,first_name,user_name,birth_date,height,weight,bio FROM users WHERE user_id = '$userId';";
  String queryForInterests = "";
  String queryForPicLinks =
      "SELECT pic_link FROM profile_pics WHERE owner_id = '$userId';";
  String queryForPrompts =
      "SELECT p.prompt_title, upa.prompt_answer FROM users_prompt_answers upa JOIN prompts p ON upa.prompt_title = p.prompt_id WHERE upa.owner_id = '$userId';";

  String compinedQuery = """
SELECT u.verified, u.first_name, u.user_name, u.birth_date, u.height, u.weight, u.bio, pp.pic_link, p.prompt_title, upa.prompt_answer
FROM users u
JOIN profile_pics pp ON u.user_id = pp.owner_id
JOIN users_prompt_answers upa ON u.user_id = upa.owner_id
JOIN prompts p ON upa.prompt_title = p.prompt_id
WHERE u.user_id = '$userId';
""";

  //process generals
  try {} catch (e) {}
  //process pics
  try {} catch (e) {}
  //process prompts
  try {} catch (e) {}

  return CardObj(
    verified: "none",
    firstName: "firstName",
    userName: "userName",
    birthDate: "12",
    height: "0",
    weight: "0",
    bio: "bio",
    interests: [],
    picLinks: [],
    prompts: [],
    latitude: "0",
    longitude: "0",
  );
}

// Future<String> SqlUpdateVerificationStatus(String newStatus) async {
//   //TODO: to check for succ execution, get the updated status from sql and compare to newStatus
// }

/// add 1 to roses_gotten_count
// Future<String> SqlUpdateRoesGottenCount() async {}

/// add(buy) or subtract(send) 1 from roses_sendable_count
// Future<String> SqlUpdateRoesSendableCount(bool addOne) async {}

// increase(buy boost) or decrease(end boost) visibility_score
Future SqlUpdateVisibilityScore(int delta) async {}

Future SqlUpdateWeight(int weight) async {}

Future SqlUpdateHeight(int height) async {}

Future SqlUpdateLocation(
  int userId,
//location
) async {}
