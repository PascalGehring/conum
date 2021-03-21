part of 'country_stats_bloc.dart';

abstract class CountryStatsEvent extends Equatable {
  const CountryStatsEvent();

  @override
  List<Object> get props => [];
}

class GetStatsForConcreteCountry extends CountryStatsEvent {
  final String countryString;

  GetStatsForConcreteCountry(this.countryString);

  @override
  List<Object> get props => [countryString];
}

class GetStatsForRandomCountry extends CountryStatsEvent {}

class ResetStateToEmpty extends CountryStatsEvent {}
