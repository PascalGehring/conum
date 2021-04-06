import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conum/core/error/failures.dart';
import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/core/util/input_converter.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/clear_cached_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_concrete_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_last_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_random_country_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'country_stats_event.dart';
part 'country_stats_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'The country does not exist.';
const String OFFLINE_FAILURE_MESSAGE = 'You seem to be offline.';
const String SUCESSFULLY_REFRESHED_MESSAGE = 'Everthing is up to date.';

class CountryStatsBloc extends Bloc<CountryStatsEvent, CountryStatsState> {
  final GetConreteCountryStats getConreteCountryStats;
  final GetRandomCountryStats getRandomCountryStats;
  final GetLastCountryStats getLastCountryStats;
  final ClearCachedCountryStats clearCachedCountryStats;
  final InputConverter inputConverter;

  CountryStatsBloc({
    @required GetConreteCountryStats concrete,
    @required GetRandomCountryStats random,
    @required GetLastCountryStats last,
    @required ClearCachedCountryStats clear,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(last != null),
        assert(inputConverter != null),
        getConreteCountryStats = concrete,
        getRandomCountryStats = random,
        getLastCountryStats = last,
        clearCachedCountryStats = clear,
        super(Empty());

  @override
  Stream<CountryStatsState> mapEventToState(
    CountryStatsEvent event,
  ) async* {
    if (event is GetStatsForConcreteCountry) {
      yield* _handleGetStatsForConcreteNumber(event);
    } else if (event is GetStatsForRandomCountry) {
      yield* _handleGetStatsForRandomNumber(event);
    } else if (event is ResetStateToEmpty) {
      yield* _handleResetStateToEmpty(event);
    } else if (event is GetLastCountry) {
      yield* _handleGetLastCountry(event);
    } else if (event is GetFreshCountryStats) {
      yield* _handlegetFreshCountryStats(event);
    }
  }

  Stream<CountryStatsState> _handleGetStatsForConcreteNumber(
      GetStatsForConcreteCountry event) async* {
    final inputEither = inputConverter.doesCountryExist(event.countryString);

    yield* inputEither.fold((failure) async* {
      yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
    }, (string) async* {
      yield Loading();
      final failureOrStats =
          await getConreteCountryStats(Params(country: string));
      yield* _eitherLoadedOrErrorState(failureOrStats);
    });
  }

  Stream<CountryStatsState> _handleGetStatsForRandomNumber(
      GetStatsForRandomCountry event) async* {
    yield Loading();
    final failureOrStats = await getRandomCountryStats(NoParams());
    yield* _eitherLoadedOrErrorState(failureOrStats);
  }

  Stream<CountryStatsState> _handleResetStateToEmpty(
      ResetStateToEmpty event) async* {
    clearCachedCountryStats(NoParams());
    yield Empty();
  }

  Stream<CountryStatsState> _handleGetLastCountry(GetLastCountry event) async* {
    final failureOrCached = await getLastCountryStats(NoParams());
    yield* failureOrCached.fold((failure) async* {
      yield Empty();
    }, (stats) async* {
      yield Loaded(countryStats: stats);
    });
  }

  Stream<CountryStatsState> _handlegetFreshCountryStats(
      GetFreshCountryStats event) async* {
    final failureOrStats = await getConreteCountryStats(
        Params(country: event.countryStats.country));
    yield* failureOrStats.fold((failure) async* {
      yield RefreshError(
          message: _mapFailureToMessage(failure),
          countryStats: event.countryStats);
    }, (stats) async* {
      yield Refreshed(
          countryStats: stats, message: SUCESSFULLY_REFRESHED_MESSAGE);
    });
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
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
