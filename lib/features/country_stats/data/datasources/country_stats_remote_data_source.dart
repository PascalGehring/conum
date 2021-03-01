import '../models/country_stats_model.dart';

abstract class CountryStatsRemoteDataSource {
  /// Calls the https://covid-193.p.rapidapi.com/statistics?country={country} endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CountryStatsModel> getCountryStats(String country);
}
