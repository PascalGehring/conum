import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../models/country_stats_model.dart';

const CACHED_COUNTRY_STATS = 'CACHED_COUNTRY_STATS';

abstract class CountryStatsLocalDataSource {
  /// Gets the cached [CountryStatsModel] which was gotten the last time
  /// the user had an interne connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<CountryStatsModel> getLastCountryStats();

  Future<void> cacheCountryStats(CountryStatsModel countryToCache);
}

class CountryStatsLocalDataSourceImpl implements CountryStatsLocalDataSource {
  final SharedPreferences sharedPreferences;

  CountryStatsLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<CountryStatsModel> getLastCountryStats() {
    final jsonString = sharedPreferences.getString(CACHED_COUNTRY_STATS);

    if (jsonString != null) {
      return Future.value(
          CountryStatsModel.fromLocalJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCountryStats(CountryStatsModel countryToCache) {
    return sharedPreferences.setString(
      CACHED_COUNTRY_STATS,
      json.encode(countryToCache /*.toJson()*/),
    );
  }
}
