import 'package:conum/core/error/exceptions.dart';
import 'package:conum/core/platform/network_info.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_local_data_source.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/country_stats.dart';
import '../../domain/repositories/country_stats_repository.dart';

class CountryStatsRepositoryImpl implements CountryStatsRepository {
  final CountryStatsRemoteDataSource remoteDataSource;
  final CountryStatsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CountryStatsRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, CountryStats>> getCountryStats(String country) async {
    bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteStats = await remoteDataSource.getCountryStats(country);
        localDataSource.cacheCountryStats(remoteStats);
        return Right(remoteStats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localStats = await localDataSource.getLastCountryStats();
        return Right(localStats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
