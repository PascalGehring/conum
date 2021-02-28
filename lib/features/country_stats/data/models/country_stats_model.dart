import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:flutter/material.dart';

class CountryStatsModel extends CountryStats {
  CountryStatsModel({
    @required String country,
    @required int population,
    @required int totalCases,
    @required int newCases,
    @required int totalDeaths,
    @required int newDeaths,
    @required int criticalPatients,
  }) : super(
            country: country,
            population: population,
            totalCases: totalCases,
            newCases: newCases,
            totalDeaths: totalDeaths,
            newDeaths: newDeaths,
            criticalPatients: criticalPatients);

  factory CountryStatsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> response = json['response'][0];
    return CountryStatsModel(
      country: response['country'],
      population: response['population'],
      totalCases: response['cases']['active'],
      newCases: int.parse(response['cases']['new']),
      totalDeaths: response['deaths']['total'],
      newDeaths: int.parse(response['deaths']['new']),
      criticalPatients: response['cases']['critical'],
    );
  }
}
