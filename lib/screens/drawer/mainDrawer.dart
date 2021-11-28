import 'package:careofbeauty/screens/authenticate/signin.dart';
import 'package:careofbeauty/screens/female%20wearing/femaleWearingHome.dart';
import 'package:careofbeauty/screens/home/home.dart';
import 'package:careofbeauty/screens/makeup%20kit/makeUpKitHome.dart';
import 'package:careofbeauty/screens/male%20wearing/maleWearingHome.dart';
import 'package:careofbeauty/screens/problem%20and%20solution/problemAndSolutionHome.dart';
import 'package:careofbeauty/screens/skin%20care/skinCareHome.dart';
import 'package:careofbeauty/screens/skintone/skintone.dart';
import 'package:careofbeauty/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.amber,
        child: SafeArea(
          child: ListView(
            children: [
              //Home
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
              Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Male Wearing
              ListTile(
                leading: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: Text(
                  "Male Wearing",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaleWearingHome()));
                },
              ),
              //Female Wearing
              ListTile(
                leading: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: Text(
                  "Female Wearing",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FemaleWearingHome()));
                },
              ),
              //Skin Care
              ListTile(
                leading: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: Text(
                  "Skin Care",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SkinCareHome()));
                },
              ),
              //Makeup Kit
              ListTile(
                leading: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: Text(
                  "Makeup Kit",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MakeUpKitHome()));
                },
              ),
              //Problem & Solution
              ListTile(
                leading: Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: Text(
                  "Problem & Solution",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProblemAndSolutionHome()));
                },
              ),
              Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Set Skin Tone
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: Text(
                  "Set Skin Tone",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SkinTone()));
                },
              ),
              //Logout
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onTap: () {
                  //Closing all scaffolds and returning to SignIn page
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.read<AuthenticationService>().signOut();
                },
              ),
              Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Username: email or guest
              ListTile(
                title: FirebaseAuth.instance.currentUser.email != null
                    ? Text(
                        "Logged in as : " +
                            FirebaseAuth.instance.currentUser.email,
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      )
                    : Text(
                        "Logged in as : Guest",
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
