import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../models/country_stats_model.dart';
import '../models/country_stats_model.dart';

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
    // TODO: implement getLastCountryStats
    final jsonString = sharedPreferences.getString('CACHED_COUNTRY_STATS');
    return Future.value(CountryStatsModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<void> cacheCountryStats(CountryStatsModel countryToCache) {
    // TODO: implement cacheCountryStats
    throw UnimplementedError();
  }
}
