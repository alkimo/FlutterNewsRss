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

  logout(bool hit) {
    googleSignIn.signOut();
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Colors.teal, Colors.purple],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "EllyVate",
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
                fontSize: 130,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Expanded(
                    child: Container(

                      height: 50,
                      width: 175,
                      child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,

                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.white),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(

                      height: 50,
                      width: 175,

                      child: FlatButton(
                        disabledColor: Color(0xFF353D53),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text("Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "OR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            AppleSignInButton(onPressed: () {}, style: AppleButtonStyle.black),
            GoogleSignInButton(onPressed: login, darkMode: false),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
