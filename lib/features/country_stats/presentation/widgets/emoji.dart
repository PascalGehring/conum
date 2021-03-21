import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  final String emojiHex;
  final double size;

  Emoji(this.emojiHex, {@required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      emojiHex,
      style: TextStyle(fontSize: size),
    );
  }
}
