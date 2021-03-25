import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/pages/country_page.dart';
import 'package:conum/features/country_stats/presentation/pages/loading.dart';
import 'package:conum/features/country_stats/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class Home extends StatelessWidget {
  @override
  BlocProvider<CountryStatsBloc> build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<CountryStatsBloc>(),
      child: BlocBuilder<CountryStatsBloc, CountryStatsState>(
        // ignore: missing_return
        builder: (BuildContext context, state) {
          if (state is Empty) {
            return buildSearchPage();
          } else if (state is Loading) {
            return buildLoading();
          } else if (state is Loaded) {
            return buildCountryPage(state.countryStats, key);
          } else if (state is Error) {
            return SearchPage();
          }
        },
      ),
    );
  }
}

Widget buildLoading() {
  return LoadingIndicator();
}

Widget buildSearchPage() {
  return SearchPage();
}

Widget buildCountryPage(CountryStats countryStats, Key key) {
  return CountryPage(
    countryStats: countryStats,
    key: key,
  );
}