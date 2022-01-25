import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:flutter/cupertino.dart';

class CountryDisplay extends StatelessWidget {
  final String country;

  const CountryDisplay({Key key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      child: FittedBox(
        child: Text(
          country,
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
      ),
    );
  }
}
