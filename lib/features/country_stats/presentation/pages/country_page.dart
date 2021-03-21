import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryPage extends StatelessWidget {
  final CountryStats countryStats;

  const CountryPage({@required Key key, this.countryStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: CupertinoColors.white,
      //   elevation: 0,
      // ),

      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Row(
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
                    BlocProvider.of<CountryStatsBloc>(context)
                        .add(ResetStateToEmpty());
                  })),
            ],
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Emoji(
                  '🇨🇭',
                  size: 70,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: FittedBox(
                    child: Text(
                      countryStats.country,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                NumberAndDescription(
                  description: 'Cases',
                  number: countryStats.totalCases,
                  difference: countryStats.newCases,
                ),
                NumberAndDescription(
                  description: 'Deaths',
                  number: countryStats.totalDeaths,
                  difference: countryStats.newDeaths,
                ),
                NumberAndDescription(
                  description: 'Critical',
                  number: countryStats.criticalPatients,
                  difference: null,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

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
          style: TextStyle(fontSize: 20),
        ),
        Text(
          number.toString(),
          style: TextStyle(fontSize: 40),
        ),
        Text(
          _addPrefixOrReturnBlank(difference),
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  _addPrefixOrReturnBlank(int number) {
    if (number == null) {
      return '';
    } else if (number == 0) {
      return '+0';
    } else if (!number.isNegative) {
      return '+$difference';
    }
    return difference.toString();
  }
}
