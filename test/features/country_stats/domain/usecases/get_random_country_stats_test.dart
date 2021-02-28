import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/repositories/country_stats_repository.dart';
import 'package:conum/features/country_stats/domain/usecases/get_concrete_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_random_country_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCountryStatsRepository extends Mock
    implements CountryStatsRepository {}

void main() {
  GetRandomCountryStats usecase;
  MockCountryStatsRepository mockCountryStatsRepository;

  setUp(() {
    mockCountryStatsRepository = MockCountryStatsRepository();
    usecase = GetRandomCountryStats(mockCountryStatsRepository);
  });

  final tCountry = 'Switzerland';
  final tCountryStats = CountryStats(
    country: tCountry,
    population: 800,
    totalCases: 1,
    newCases: 1,
    totalDeaths: 1,
    newDeaths: 1,
    criticalPatients: 1,
  );

  test(
    'should get CountryStats for random country from repository',
    () async {
      // arrange
      when(mockCountryStatsRepository.getCountryStats(any))
          .thenAnswer((_) async => Right(tCountryStats));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tCountryStats));
      verify(mockCountryStatsRepository.getCountryStats(any));
      verifyNoMoreInteractions(MockCountryStatsRepository());
    },
  );
}
