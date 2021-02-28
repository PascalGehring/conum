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
