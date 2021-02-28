import 'dart:math';

import 'package:conum/core/constants/countries.dart';
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
    // Generates Random Country
    final _random = Random();
    String country =
        Constants.countries[_random.nextInt(Constants.countries.length)];
    return await repository.getCountryStats(country);
  }
}
