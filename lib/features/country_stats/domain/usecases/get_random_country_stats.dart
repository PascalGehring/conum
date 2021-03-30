import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/countries.dart';
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
    List<String> countries = Constants().getcountryList();

    print(countries);

    final _random = Random();
    String country = countries[_random.nextInt(countries.length)];
    return await repository.getCountryStats(country);
  }
}
