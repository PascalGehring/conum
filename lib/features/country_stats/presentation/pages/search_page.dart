import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (BuildContext context) => sl<CountryStatsBloc>(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Emoji('🌐'),
              SearchBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    print('Random Stats');
                  },
                  child: Text(
                    'Get random stats',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
