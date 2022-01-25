import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/widgets/emoji.dart';
import 'package:conum/features/country_stats/presentation/widgets/search_bar.dart';
import 'package:conum/features/country_stats/presentation/widgets/stateful_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flash/flash.dart';

import '../../../../injection_container.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countryStatsBloc = BlocProvider.of<CountryStatsBloc>(context);
    final ScrollController scrollController = ScrollController();
    return StatefulWrapper(
      onInit: () {
        BlocProvider.of<CountryStatsBloc>(context).add(GetLastCountry());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocProvider(
            create: (BuildContext context) => sl<CountryStatsBloc>(),
            child: BlocListener(
              cubit: countryStatsBloc,
              listener: (BuildContext context, CountryStatsState state) {
                if (state is Error) {
                  // HapticFeedback.heavyImpact();
                  HapticFeedback.mediumImpact();
                  showSnackBar(
                      context: context, message: state.message, isError: true);
                  countryStatsBloc.add(ResetStateToEmpty());
                }
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 2.8),
                      Emoji(
                        '🌐',
                        size: 80,
                      ),
                      SearchBar(
                        context: context,
                        scrollController: scrollController,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: () {
                            dispatchRandom(context);
                          },
                          child: Text(
                            'Random Country',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.all(20.0),
                      //     child: Text('Powered by: JHU CSSE COVID-19 Data')),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void dispatchRandom(BuildContext context) {
    BlocProvider.of<CountryStatsBloc>(context).add(GetStatsForRandomCountry());
  }
}

showSnackBar(
    {@required BuildContext context,
    @required String message,
    @required bool isError}) {
  return showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: (context, controller) {
        return Flash.bar(
            controller: controller,
            backgroundColor: isError ? Colors.red : Colors.green,
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
