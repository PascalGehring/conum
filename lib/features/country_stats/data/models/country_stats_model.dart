import '../../domain/entities/country_stats.dart';
import 'package:flutter/material.dart';

class CountryStatsModel extends CountryStats {
  CountryStatsModel({
    @required String country,
    @required int population,
    @required int totalCases,
    @required int newCases,
    @required int totalDeaths,
    @required int newDeaths,
    @required int recovered,
    @required int newRecovered,
  }) : super(
          country: country,
          population: population,
          totalCases: totalCases,
          newCases: newCases,
          totalDeaths: totalDeaths,
          newDeaths: newDeaths,
          recovered: recovered,
          newRecovered: newRecovered,
        );

  factory CountryStatsModel.fromRemoteJson(List<dynamic> jsonList) {
    final Map<String, dynamic> json = jsonList[0];

    return CountryStatsModel(
        country: json['country'],
        population: json['population'],
        totalCases: json['confirmed'],
        newCases: json['confirmed_daily'],
        totalDeaths: json['deaths'],
        newDeaths: json['deaths_daily'],
        recovered: json['recovered'],
        newRecovered: json['recovered_daily']);
  }

  factory CountryStatsModel.fromLocalJson(Map<String, dynamic> json) {
    return CountryStatsModel(
      country: json['country'],
      population: json['population'],
      totalCases: json['totalCases'],
      newCases: json['newCases'],
      totalDeaths: json['totalDeaths'],
      newDeaths: json['newDeaths'],
      recovered: json['recovered'],
      newRecovered: json['newRecovered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "population": population,
      "totalCases": totalCases,
      "newCases": newCases,
      "totalDeaths": totalDeaths,
      "newDeaths": newDeaths,
      "recovered": recovered,
      "newRecovered": newRecovered,
    };
  }
}
