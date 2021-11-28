import 'package:flutter/material.dart';

Widget homeGridItems(String name, String image, int color1, int color2) {
  return Container(
    decoration: BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          Color(color1),
          Color(color2),
        ],
        begin: Alignment.centerLeft,
        end: new Alignment(1.0, 1.0),
      ),
    ),
    child: Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
