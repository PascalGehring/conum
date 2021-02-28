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
    newCases: 1,
    totalDeaths: 1,
    newDeaths: 1,
    criticalPatients: 1,
  );

  test(
    'should be a subclass of CountryStats entity',
    () async {
      // assert
      expect(tCountryStatsModel, isA<CountryStats>());
    },
  );
  group('fromJson', () {
    test(
      'should return a valid model when the JSON has int values',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('stats.json'));
        // act
        final result = CountryStatsModel.fromJson(jsonMap);
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
        final result = CountryStatsModel.fromJson(jsonMap);
        // assert
        expect(result, tCountryStatsModel);
      },
    );
  });
}
