import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_local_data_source.dart';
import 'package:conum/features/country_stats/data/models/country_stats_model.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  CountryStatsLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CountryStatsLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });
  group('getLastCountryStats', () {
    final CountryStatsModel tCountryStatsModel =
        CountryStatsModel.fromLocalJson(
            json.decode(fixture('stats_cached.json')));

    test(
      'should return CountryStats from SharedPreferences when there is one cached',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('stats_cached.json'));
        // act
        final result = await dataSource.getLastCountryStats();
        // assert
        verify(mockSharedPreferences.getString(CACHED_COUNTRY_STATS));
        expect(result, tCountryStatsModel);
      },
    );

    test(
      'should throw CacheException when there is nothing cached',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastCountryStats;
        // assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );

    group('cacheCountryStats', () {
      final tcountryStatsModel = CountryStatsModel(
        country: 'Switzerland',
        population: 1,
        totalCases: 1,
        newCases: 1,
        totalDeaths: 1,
        newDeaths: 1,
        recovered: 1,
        newRecovered: 1,
      );
      test(
        'should call SharedPreferences to cache the data',
        () async {
          // act
          dataSource.cacheCountryStats(tCountryStatsModel);
          // assert
          final expectedJsonString = json.encode(tcountryStatsModel);
          verify(mockSharedPreferences.setString(
              CACHED_COUNTRY_STATS, expectedJsonString));
        },
      );
    });
  });
}
