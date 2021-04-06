import 'package:conum/core/error/failures.dart';
import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/repositories/country_stats_repository.dart';
import 'package:dartz/dartz.dart';

class GetLastCountryStats implements UseCase<CountryStats, NoParams> {
  final CountryStatsRepository repository;

  GetLastCountryStats(this.repository);

  @override
  Future<Either<Failure, CountryStats>> call(NoParams params) async {
    return await repository.getCachedCountryStats();
  }
}
