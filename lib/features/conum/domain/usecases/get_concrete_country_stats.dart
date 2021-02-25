import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country_stats.dart';
import '../repositories/country_stats_repository.dart';

class GetConreteCountryStats implements UseCase<CountryStats, Params> {
  final CountryStatsRepository repository;

  GetConreteCountryStats(this.repository);

  @override
  Future<Either<Failure, CountryStats>> call(
    Params params,
  ) async {
    return await repository.getCountryStats(params.country);
  }
}

class Params extends Equatable {
  final String country;

  Params({@required this.country});

  @override
  List<Object> get props => [country];
}
