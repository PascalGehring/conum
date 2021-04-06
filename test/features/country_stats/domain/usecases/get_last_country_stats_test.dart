import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/repositories/country_stats_repository.dart';
import 'package:conum/features/country_stats/domain/usecases/get_last_country_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCountryStatsRepository extends Mock
    implements CountryStatsRepository {}

void main() {
  GetLastCountryStats usecase;
  MockCountryStatsRepository mockCountryStatsRepository;
  setUp(() {
    mockCountryStatsRepository = MockCountryStatsRepository();
    usecase = GetLastCountryStats(mockCountryStatsRepository);
  });

  final tCountry = 'Switzerland';
  final tCountryStats = CountryStats(
      country: tCountry,
      population: 1,
      totalCases: 1,
      newCases: 1,
      totalDeaths: 1,
      newDeaths: 1,
      recovered: 1,
      newRecovered: 1);

  test(
    'should return cached CountryStats from repository',
    () async {
      // arrange
      when(mockCountryStatsRepository.getCachedCountryStats())
          .thenAnswer((_) async => Right(tCountryStats));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tCountryStats));
      verify(mockCountryStatsRepository.getCachedCountryStats());
      verifyZeroInteractions(MockCountryStatsRepository());
    },
  );
}
