import 'package:conum/core/util/get_flag.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/pages/search_page.dart';
import 'package:conum/features/country_stats/presentation/widgets/back_button.dart';
import 'package:conum/features/country_stats/presentation/widgets/country_display.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/number_and_description.dart';
import 'package:conum/features/country_stats/presentation/widgets/stateful_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            showSnackBar(
                context: context, message: state.message, isError: false);
          } else if (state is RefreshError) {
            // HapticFeedback.heavyImpact();
            HapticFeedback.mediumImpact();
            showSnackBar(
                context: context, message: state.message, isError: true);
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
              SizedBox(
                height: 10,

              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.0004,
                    ),
                    BlackBackButton(),
                    Emoji(
                      GetFlag().call(countryStats.country),
                      size: 70,
                    ),
                    CountryDisplay(
                      country: countryStats.country,
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
