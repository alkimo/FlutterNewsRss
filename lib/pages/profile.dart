import 'package:flutter/material.dart';
import 'package:ellyvate/pages/home.dart';

@override
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        child: RaisedButton(
          color: Colors.redAccent,
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            googleSignIn.signOut();
          },
        ),
      ),
    );
  }
}
