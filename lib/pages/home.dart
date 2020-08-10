import 'package:ellyvate/pages/list_feed.dart';
import 'package:ellyvate/pages/profile.dart';
import 'package:ellyvate/pages/favorites.dart';
import 'package:ellyvate/pages/feed.dart';
import 'package:ellyvate/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:animated_overflow/animated_overflow.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.white, Colors.black],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 100.0));

  @override
  void initState() {

    pageController = PageController();
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      print("Error signing in: $err");
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print("Error signing in: $err");
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print("User signed in: $account");
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }



  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  Scaffold buildAuthScreen() {
    ImageProvider logo = AssetImage("assetss/images/front_1.png");
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Profile(),
          Favorites(),
          Feed(),
          FeedList(),
          Settings(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person)),
            BottomNavigationBarItem(icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.rss_feed,
              size: 40.0,
            )),
            BottomNavigationBarItem(icon: Icon(Icons.layers)),
            BottomNavigationBarItem(icon: Icon(Icons.settings)),
          ]),
    );
  }

  buildUnAuthScreen() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedOverflow(
            animatedOverflowDirection: AnimatedOverflowDirection.HORIZONTAL,
            child: Container(
              width: 600,
              decoration: const BoxDecoration(
                image: const DecorationImage(
                  image: const AssetImage(
                    "assets/images/front_1.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            maxWidth: width,
            padding: 0.0,
            speed: 25.0,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white.withOpacity(0.5),
              ),
              margin: EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "{ellyvate}",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        shadows: [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-0.1, -0.1),
                              color: Colors.black.withOpacity(0.3)),
                          Shadow(
                              // bottomRight
                              offset: Offset(0.1, -0.1),
                              color: Colors.black.withOpacity(0.3)),
                          Shadow(
                              // topRight
                              offset: Offset(0.1, 0.1),
                              color: Colors.black.withOpacity(0.3)),
                          Shadow(
                              // topLeft
                              offset: Offset(-0.1, 0.1),
                              color: Colors.black.withOpacity(0.3)),
                        ],
                        foreground: Paint()..shader = linearGradient,
                        fontSize: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),

//            AppleSignInButton(onPressed: () {}),
                  AppleSignInButton(
                      onPressed: () {}, style: AppleButtonStyle.black),
//            GoogleSignInButton(onPressed: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  GoogleSignInButton(onPressed: login, darkMode: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
