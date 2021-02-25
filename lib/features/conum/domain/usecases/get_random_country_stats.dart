import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country_stats.dart';
import '../repositories/country_stats_repository.dart';

class GetRandomCountryStats implements UseCase<CountryStats, NoParams> {
  final CountryStatsRepository repository;

  GetRandomCountryStats(this.repository);

  @override
  Future<Either<Failure, CountryStats>> call(NoParams params) async {
    // TODO: generate Random Country out of Country List
    String country = 'Switzerland';

    return await repository.getCountryStats(country);
  }
}
