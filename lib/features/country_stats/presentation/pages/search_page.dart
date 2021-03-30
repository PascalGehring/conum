import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flash/flash.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatelessWidget {
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
                // HapticFeedback.heavyImpact();
                HapticFeedback.mediumImpact();
                showSnackBar(context, state.message);
                countryStatsBloc.add(ResetStateToEmpty());
              }
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
                      dispatchRandom(context);
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

  void dispatchRandom(BuildContext context) {
    BlocProvider.of<CountryStatsBloc>(context).add(GetStatsForRandomCountry());
  }
}

showSnackBar(BuildContext context, String message) {
  return showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: (context, controller) {
        return Flash.bar(
            controller: controller,
            backgroundColor: Colors.red,
            position: FlashPosition.bottom,
            enableDrag: true,
            margin: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: FlashBar(
                message: Text(
              message,
              style: TextStyle(fontSize: 15, color: Colors.white),
            )));
      });
}
