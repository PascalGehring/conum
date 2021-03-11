import 'package:conum/core/error/exceptions.dart';
import 'package:conum/core/error/failures.dart';
import 'package:conum/core/platform/network_info.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_local_data_source.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:conum/features/country_stats/data/models/country_stats_model.dart';
import 'package:conum/features/country_stats/data/repository/country_stats_repository_impl.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements CountryStatsRemoteDataSource {}

class MockLocalDataSource extends Mock implements CountryStatsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  CountryStatsRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CountryStatsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
  group('getCountryStats', () {
    final tCountry = 'Switzerland';
    final tCountryStatsModel = CountryStatsModel(
      country: 'Switzerland',
      population: 1,
      totalCases: 0,
      newCases: 0,
      totalDeaths: 0,
      newDeaths: 0,
      criticalPatients: 0,
    );
    final CountryStats tCountryStats = tCountryStatsModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getCountryStats(tCountry);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source was sucessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getCountryStats(any))
              .thenAnswer((_) async => tCountryStatsModel);
          // act
          final result = await repository.getCountryStats(tCountry);
          // assert
          verify(mockRemoteDataSource.getCountryStats(tCountry));
          expect(result, equals(Right(tCountryStats)));
        },
      );
      test(
        'should cache CountryStats when the call to remote data source was sucessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getCountryStats(any))
              .thenAnswer((_) async => tCountryStatsModel);
          // act
          await repository.getCountryStats(tCountry);
          // assert
          verify(mockLocalDataSource.cacheCountryStats(tCountryStats));
        },
      );
      test(
        'should return [ServerFailure] when call to remote data source was  unsucessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getCountryStats(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getCountryStats(tCountry);
          // assert
          verify(mockRemoteDataSource.getCountryStats(tCountry));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastCountryStats())
              .thenAnswer((_) async => tCountryStatsModel);
          // act
          final result = await repository.getCountryStats(tCountry);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastCountryStats());
          expect(result, equals(Right(tCountryStats)));
        },
      );
      test(
        'should return CacheFailure when there is no Cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastCountryStats())
              .thenThrow(CacheException());
          final result = await repository.getCountryStats(tCountry);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastCountryStats());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
