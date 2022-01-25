import 'package:conum/core/util/get_flag.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/pages/search_page.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/stateful_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CountryPage extends StatelessWidget {
  final CountryStats countryStats;

  const CountryPage({@required Key key, this.countryStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryStatsBloc = BlocProvider.of<CountryStatsBloc>(context);

    double height = MediaQuery.of(context).size.height;

    return StatefulWrapper(
      onInit: () {
        BlocProvider.of<CountryStatsBloc>(context)
            .add(GetFreshCountryStats(countryStats));
      },
      child: BlocListener(
        cubit: countryStatsBloc,
        listener: (BuildContext context, CountryStatsState state) {
          if (state is Refreshed) {
            HapticFeedback.mediumImpact();
            showSnackBar(context, state.message, false);
          } else if (state is RefreshError) {
            // HapticFeedback.heavyImpact();
            HapticFeedback.mediumImpact();
            showSnackBar(context, state.message, true);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(children: [
              SizedBox(height: height * 0.0004),
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
                        Navigator.pop(context);
                      })),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.0004,
                    ),
                    Emoji(
                      GetFlag().call(countryStats.country),
                      size: 70,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: FittedBox(
                        child: Text(
                          countryStats.country,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: -0.5),
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
                      description: 'Recovered',
                      number: countryStats.recovered,
                      difference: countryStats.newRecovered,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
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
