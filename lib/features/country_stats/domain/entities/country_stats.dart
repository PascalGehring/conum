import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CountryStats extends Equatable {
  final String country;
  final int population;
  final int totalCases;
  final int newCases;
  final int totalDeaths;
  final int newDeaths;
  final int recovered;
  final int newRecovered;

  CountryStats({
    @required this.country,
    @required this.population,
    @required this.totalCases,
    @required this.newCases,
    @required this.totalDeaths,
    @required this.newDeaths,
    @required this.recovered,
    @required this.newRecovered,
  });

  @override
  List<Object> get props => [
        country,
        population,
        totalCases,
        newCases,
        totalDeaths,
        newDeaths,
        recovered,
        newRecovered,
      ];
}
