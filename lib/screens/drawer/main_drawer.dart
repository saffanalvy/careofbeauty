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
  const MainDrawer({Key? key}) : super(key: key);
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
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text(
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
              const Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Male Wearing
              ListTile(
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text(
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
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text(
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
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text(
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
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text(
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
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text(
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
              const Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Set Skin Tone
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: const Text(
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
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: const Text(
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
              const Divider(
                height: 0.5,
                color: Colors.black,
              ),
              //Username: email or guest
              ListTile(
                title: FirebaseAuth.instance.currentUser!.email != null
                    ? Text(
                        "Logged in as : " +
                            FirebaseAuth.instance.currentUser!.email.toString(),
                        style: const TextStyle(
                          fontSize: 10.0,
                        ),
                      )
                    : const Text(
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
