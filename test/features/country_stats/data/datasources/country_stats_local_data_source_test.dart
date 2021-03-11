import 'dart:convert';

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
    final tCountryStatsModel =
        CountryStatsModel.fromJson(json.decode(fixture('stats_cached.json')));
    test(
      'should return CountryStats from SharedPreferences when there is one cached',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('stats_cached.json '));
        // act
        final result = await dataSource.getLastCountryStats();
        // assert
        verify(mockSharedPreferences.getString('CACHED_COUNTRY_STATS'));
        expect(result, equals(tCountryStatsModel));
      },
    );
  });
}
