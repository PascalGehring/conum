import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conum/core/error/failures.dart';
import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/core/util/input_converter.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_concrete_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_random_country_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'country_stats_event.dart';
part 'country_stats_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Das eingegebene Land existiert nicht.';

class CountryStatsBloc extends Bloc<CountryStatsEvent, CountryStatsState> {
  final GetConreteCountryStats getConreteCountryStats;
  final GetRandomCountryStats getRandomCountryStats;
  final InputConverter inputConverter;

  CountryStatsBloc({
    @required GetConreteCountryStats concrete,
    @required GetRandomCountryStats random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConreteCountryStats = concrete,
        getRandomCountryStats = random,
        super(Empty());

  @override
  Stream<CountryStatsState> mapEventToState(
    CountryStatsEvent event,
  ) async* {
    if (event is GetStatsForConcreteCountry) {
      final inputEither = inputConverter.doesCountryExist(event.countryString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (string) async* {
        yield Loading();
        final failureOrStats =
            await getConreteCountryStats(Params(country: string));
        yield* _eitherLoadedOrErrorState(failureOrStats);
      });
    } else if (event is GetStatsForRandomCountry) {
      yield Loading();
      final failureOrStats = await getRandomCountryStats(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrStats);
    } else if (event is ResetStateToEmpty) {
      yield Empty();
    }
  }

  Stream<CountryStatsState> _eitherLoadedOrErrorState(
      Either<Failure, CountryStats> failureOrStats) async* {
    yield failureOrStats.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (stats) => Loaded(countryStats: stats));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
