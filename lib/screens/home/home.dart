import 'package:careofbeauty/screens/female%20wearing/femaleWearingHome.dart';
import 'package:careofbeauty/screens/drawer/mainDrawer.dart';
import 'package:careofbeauty/screens/home/homeGridItems.dart';
import 'package:careofbeauty/screens/makeup%20kit/makeUpKitHome.dart';
import 'package:careofbeauty/screens/male%20wearing/maleWearingHome.dart';
import 'package:careofbeauty/screens/problem%20and%20solution/problemAndSolutionHome.dart';
import 'package:careofbeauty/screens/skin%20care/skinCareHome.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     iconSize: 40.0,
        //     onPressed: () {
        //       context.read<AuthenticationService>().signOut();
        //     },
        //   )
        // ],
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
        title: Text('Home'),
      ),
      drawer: MainDrawer(),
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3.0,
        children: [
          //Male Wearing Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaleWearingHome(),
                ),
              );
            },
            child: homeGridItems("Male Wearing", "assets/image/male_pic.jpg",
                0xFF0091EA, 0xFF80D8FF),
          ),

          //Female Wearing Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FemaleWearingHome(),
                ),
              );
            },
            child: homeGridItems("Female Wearing",
                "assets/image/female_pic.jpg", 0xFFC51162, 0XFFFF80AB),
          ),
          //Skin Care Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SkinCareHome(),
                ),
              );
            },
            child: homeGridItems("Skin Care", "assets/image/skincare.jpg",
                0XFFFF6D00, 0XFFFFD180),
          ),
          //Makeup Kit Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MakeUpKitHome(),
                ),
              );
            },
            child: homeGridItems("Makeup Kit", "assets/image/makeupkit.jpg",
                0XFFAA00FF, 0XFFEA80FC),
          ),
          //Problem & Solution Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProblemAndSolutionHome(),
                ),
              );
            },
            child: homeGridItems("Problem & Solution",
                "assets/image/probnsoln.webp", 0XFF64DD17, 0XFFCCFF90),
          ),
        ],
      ),
    );
  }
}
