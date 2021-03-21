import 'package:conum/core/constants/countries.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final countryStatsBloc = BlocProvider.of<CountryStatsBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (BuildContext context) => sl<CountryStatsBloc>(),
          child: BlocListener(
            cubit: countryStatsBloc,
            listener: (BuildContext context, CountryStatsState state) {
              if (state is Error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
              //countryStatsBloc.add(ResetStateToEmpty());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Emoji(
                  '🌐',
                  size: 80,
                ),
                SearchBar(
                  blocContext: context,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      print('Random Stats');
                      dispatchRandom();
                    },
                    child: Text(
                      'Random Country',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void dispatchRandom() {
    BlocProvider.of<CountryStatsBloc>(context).add(GetStatsForRandomCountry());
  }

  void dispatchConcrete(String str) {
    print('dispatchedConcrete with $str');
    BlocProvider.of<CountryStatsBloc>(context)
        .add(GetStatsForConcreteCountry(str));
  }
}
