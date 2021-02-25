import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/country_stats.dart';

abstract class CountryStatsRepository {
  Future<Either<Failure, CountryStats>> getCountryStats(String country);
}
