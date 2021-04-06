import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/features/country_stats/domain/repositories/country_stats_repository.dart';
import 'package:conum/features/country_stats/domain/usecases/clear_cached_country_stats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCountryStatsRepository extends Mock
    implements CountryStatsRepository {}

void main() {
  ClearCachedCountryStats usecase;
  CountryStatsRepository repository;

  setUp(() {
    repository = MockCountryStatsRepository();
    usecase = ClearCachedCountryStats(repository);
  });

  test(
    'should call clearCachedCountryStats on repository',
    () async {
      // arrange

      // act
      await usecase(NoParams());
      // assert
      verify(repository.clearCachedCountryStats());
      verifyNoMoreInteractions(repository);
    },
  );
}
