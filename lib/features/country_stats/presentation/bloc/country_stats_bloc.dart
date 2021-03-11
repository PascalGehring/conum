import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'country_stats_event.dart';
part 'country_stats_state.dart';

class CountryStatsBloc extends Bloc<CountryStatsEvent, CountryStatsState> {
  CountryStatsBloc() : super(Empty());

  @override
  Stream<CountryStatsState> mapEventToState(
    CountryStatsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
