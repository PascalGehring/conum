import 'dart:convert';

import 'package:conum/features/country_stats/data/models/country_stats_model.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCountryStatsModel = CountryStatsModel(
    country: 'Switzerland',
    population: 1,
    totalCases: 1,
    newCases: -1,
    totalDeaths: 1,
    newDeaths: 1,
    criticalPatients: 1,
  );

  final tCountryStatsNullModel = CountryStatsModel(
    country: 'Switzerland',
    population: 1,
    totalCases: 0,
    newCases: 0,
    totalDeaths: 0,
    newDeaths: 0,
    criticalPatients: 0,
  );

  test(
    'should be a subclass of CountryStats entity',
    () async {
      // assert
      expect(tCountryStatsModel, isA<CountryStats>());
    },
  );
  group('fromRemoteJson', () {
    test(
      'should return a valid model when the JSON has int values (with prefix)',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('stats.json'));
        // act
        final result = CountryStatsModel.fromRemoteJson(jsonMap);
        // assert
        expect(result, tCountryStatsModel);
      },
    );
    test(
      'should return a valid model when the JSON has null values',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('stats_null.json'));
        // act
        final result = CountryStatsModel.fromRemoteJson(jsonMap);
        // assert
        expect(result, tCountryStatsNullModel);
      },
    );
  });

  group('fromCachedJson', () {
    test(
      'should return a valid Model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('stats_cached.json'));
        // act
        final result = CountryStatsModel.fromLocalJson(jsonMap);
        // assert
        expect(result, tCountryStatsModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tCountryStatsModel.toJson();
        // assert
        final expectedMap = {
          "country": "Switzerland",
          "population": 1,
          "totalCases": 1,
          "newCases": -1,
          "totalDeaths": 1,
          "newDeaths": 1,
          "criticalPatients": 1
        };
        expect(result, expectedMap);
      },
    );
  });
}
