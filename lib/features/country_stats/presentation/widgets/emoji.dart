import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  final String emojiHex;

  Emoji(this.emojiHex);

  @override
  Widget build(BuildContext context) {
    return Text(
      emojiHex,
      style: TextStyle(fontSize: 80),
    );
  }
}
