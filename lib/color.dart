import 'package:flutter/material.dart';

const appBgColor = Color(0xFF000000);
const primary = Color(0xFFFC2D55);
const secondary =  Color(0xFF19D5F1);
const white =  Color(0xFFFFFFFF);
const black =  Color(0xFF000000);

class TikTokIcons{
  TikTokIcons._();

  static const _fontFamily = 'TikTokIcons';

  static const IconData chat_bubble = const IconData(0xe808, fontFamily: _fontFamily);
  static const IconData create = const IconData(0xe809, fontFamily: _fontFamily);
  static const IconData heart = const IconData(0xe80a, fontFamily: _fontFamily);
  static const IconData home = const IconData(0xe80b, fontFamily: _fontFamily);
  static const IconData messages = const IconData(0xe80c, fontFamily: _fontFamily);
  static const IconData profile = const IconData(0xe80d, fontFamily: _fontFamily);
  static const IconData reply = const IconData(0xe80e, fontFamily: _fontFamily);
  static const IconData search = const IconData(0xe80f, fontFamily: _fontFamily);
}



Widget getIcons(icon, count, size) {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(icon, color: white, size: size),
        SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: TextStyle(
              color: white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}

Widget getProfile() {
  return Container(
    color: Colors.white10,
    width: 50,
    height: 60,
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
            bottom: 3,
            left: 18,
            child: Container(
              width: 20,
              height: 20,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: primary),
              child: Center(
                  child: Icon(
                    Icons.add,
                    color: white,
                    size: 15,
                  )),
            ))
      ],
    ),
  );
}