import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberAndDescription extends StatelessWidget {
  final String description;
  final int number;
  final int difference;

  const NumberAndDescription(
      {Key key,
      @required this.description,
      @required this.number,
      @required this.difference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          description,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        ),
        Text(
          _formatNumber(number),
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        Text(
          _addPrefixOrReturnBlank(difference),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: -0.5),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number == 0) {
      return '-';
    }
    final formatter = NumberFormat.decimalPattern('de_ch');
    return formatter.format(number);
  }

  _addPrefixOrReturnBlank(int number) {
    if (number == 0) {
      return '-';
    } else if (!number.isNegative) {
      return '+$difference';
    }
    return difference.toString();
  }
}
