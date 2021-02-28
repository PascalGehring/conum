import 'package:conum/core/platform/network_info.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_local_data_source.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:conum/features/country_stats/data/repository/country_stats_repository_impl.dart';
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
}
