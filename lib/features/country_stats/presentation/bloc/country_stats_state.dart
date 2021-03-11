part of 'country_stats_bloc.dart';

abstract class CountryStatsState extends Equatable {
  const CountryStatsState();

  @override
  List<Object> get props => [];
}

class Empty extends CountryStatsState {}

class Loading extends CountryStatsState {}

class Loaded extends CountryStatsState {
  final CountryStats countryStats;

  Loaded({@required this.countryStats});

  @override
  List<Object> get props => [countryStats];
}

class Error extends CountryStatsState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
