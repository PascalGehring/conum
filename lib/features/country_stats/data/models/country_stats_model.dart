import '../../domain/entities/country_stats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/country_stats.dart';

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
      totalCases:
          response['cases']['active'] != null ? response['cases']['active'] : 0,
      newCases: response['cases']['new'] != null
          ? int.parse(response['cases']['new'])
          : 0,
      totalDeaths:
          response['deaths']['total'] != null ? response['deaths']['total'] : 0,
      newDeaths: response['deaths']['new'] != null
          ? int.parse(response['deaths']['new'])
          : 0,
      criticalPatients: response['cases']['critical'] != null
          ? response['cases']['critical']
          : 0,
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
      "criticalPatients": criticalPatients
    };
  }
}
