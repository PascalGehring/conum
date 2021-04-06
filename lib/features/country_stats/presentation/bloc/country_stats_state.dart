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

class RefreshError extends CountryStatsState {
  final String message;
  final CountryStats countryStats;

  RefreshError({@required this.message, @required this.countryStats});

  @override
  List<Object> get props => [message, countryStats];
}

class Refreshed extends CountryStatsState {
  final CountryStats countryStats;
  final String message;

  Refreshed({@required this.countryStats, @required this.message});

  @override
  List<Object> get props => [countryStats, message];
}
