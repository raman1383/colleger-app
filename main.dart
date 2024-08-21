import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:colleger/screens/chats.dart';
import 'package:colleger/screens/login_or_signup.dart';
import 'package:colleger/screens/profile.dart';
import 'package:colleger/screens/swipe.dart';
import 'package:colleger/utilities/loadings.dart';
import 'package:colleger/utilities/sql_queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const greenShade = Color.fromARGB(255, 9, 222, 5);
int? locallyFetchedUserId;
String? locallyFetchedPassHash;
String? accountOwnerId;

//TODO: each login check for latest update version from DB and prompt user to update
const int appVersion = 1;

Map<String, dynamic> userObj = {};

void main() {
  runApp(
    const MyApp(),
  );
}

// in MyApp take care of routeing to homepage or login : shared-pref, routing
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _notifierForUserId =
      ValueNotifier<bool?>(null); // initial value is null

  Future checkAndRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("user_id");
    String? passwordHash = prefs.getString("password_hash");
    // print(userId);
    // print(passwordHash);

    if (userId != null && passwordHash != null) {
      // bool checksOutWithDB = await sqlAutoLogIn(userId, passwordHash);
      // print("-> $userId and $checksOutWithDB");

      if (true) {
        setState(() {
          accountOwnerId = userId.toString();
        });
        _notifierForUserId.value = true;
        var x = await fillUserObj(userId);
        setState(() {
          userObj = x;
        });
      } else {
        _notifierForUserId.value = false;
      }
    } else {
      _notifierForUserId.value = false;
    }
    //-> if valid then give user_id to mother widgets & update locations
    //-> if not, then route to login/sign-up
    print("await fillUserObj(userId!)...");
    print("out of checkAndRoute(): $userId   and  $passwordHash");
  }

  @override
  void initState() {
    checkAndRoute();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        colorScheme: const ColorScheme.dark(
          primary: greenShade,
          background: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FlutterSplashScreen.fadeIn(
        animationDuration: const Duration(milliseconds: 2500),
        // backgroundColor: Colors.black,
        onInit: () {
          //! check is app is latest version if not nav to website to download latest
          debugPrint("On Init");
        },
        // onEnd: () {
        //   debugPrint("On End");
        // },
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                "./assets/logo.jpeg",
              ),
            ),
          ],
        ),
        // onAnimationEnd: () {
        //   debugPrint("On Fade In End");
        // } ,

        //TODO: render based on retrived shared_prefs user_id
        nextScreen: ValueListenableBuilder(
          valueListenable: _notifierForUserId,
          builder: (context, value, child) {
            print(value);
            if (value != null) {
              if (value == true) {
                print("routing to MyHomePage()...");
                return const MyHomePage();
              } else {
                print("routing to Login()...");
                return const Login();
              }
            } else {
              checkAndRoute();
              return const Scaffold(body: Center(child: HeartLoading()));
            }
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: const TabBar(tabs: [
          Tab(
            icon: Icon(
              CupertinoIcons.play_arrow,
              size: 35,
            ),
          ),
          Tab(
            icon: Icon(
              CupertinoIcons.chat_bubble,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              CupertinoIcons.person,
              size: 30,
            ),
          ),
        ]),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Swipe(),
            // NotificationsPage(),
            const Chat(),
            Profile(
              idOfProfileBeingViewed: accountOwnerId!,
            ),
          ],
        ),
      ),
    );
  }
}
