import 'package:flutter/material.dart';

class BlackBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
            onPressed: (() {
              Navigator.pop(context);
            })),
      ],
    );
  }
}
