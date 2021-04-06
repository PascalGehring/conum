import 'package:conum/core/error/failures.dart';
import 'package:conum/core/usecases/usecase.dart';
import 'package:conum/core/util/input_converter.dart';
import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/clear_cached_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_concrete_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_last_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_random_country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConreteCountryStats extends Mock
    implements GetConreteCountryStats {}

class MockGetRandomCountryStats extends Mock implements GetRandomCountryStats {}

class MockGetLastCountryStats extends Mock implements GetLastCountryStats {}

class MockClearCachedCountryStats extends Mock
    implements ClearCachedCountryStats {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  CountryStatsBloc bloc;
  MockGetConreteCountryStats mockGetConreteCountryStats;
  MockGetRandomCountryStats mockGetRandomCountryStats;
  MockGetLastCountryStats mockGetLastCountryStats;
  MockClearCachedCountryStats mockClearCachedCountryStats;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConreteCountryStats = MockGetConreteCountryStats();
    mockGetRandomCountryStats = MockGetRandomCountryStats();
    mockGetLastCountryStats = MockGetLastCountryStats();
    mockClearCachedCountryStats = MockClearCachedCountryStats();
    mockInputConverter = MockInputConverter();

    bloc = CountryStatsBloc(
      concrete: mockGetConreteCountryStats,
      random: mockGetRandomCountryStats,
      inputConverter: mockInputConverter,
      last: mockGetLastCountryStats,
      clear: mockClearCachedCountryStats,
    );
  });

  test('initial State should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetStatsForConcreteCountry', () {
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

    setUpMockInputConverterSucess() {
      when(mockInputConverter.doesCountryExist(any))
          .thenReturn(Right(tCountry));
    }

    test(
      'should call the InputConverter to validate the user input',
      () async {
        setUpMockInputConverterSucess();
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
        await untilCalled(mockInputConverter.doesCountryExist(any));
        // assert
        verify(mockInputConverter.doesCountryExist(tCountry));
      },
    );
    test(
      'should emit [Error] when the inputed country does not exist',
      () async {
        // arrange
        when(mockInputConverter.doesCountryExist(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Error(
            message: INVALID_INPUT_FAILURE_MESSAGE,
          )
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
      },
    );

    test(
      'should get data from the concrete usecase',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConreteCountryStats(any))
            .thenAnswer((_) async => Right(tCountryStats));
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
        await untilCalled(mockGetConreteCountryStats(any));
        // assert
        verify(mockGetConreteCountryStats(Params(country: tCountry)));
      },
    );

    test(
      'should emit [Loading], [Loaded] when the data is gotten sucessfully',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConreteCountryStats(any))
            .thenAnswer((_) async => Right(tCountryStats));
        // assert later
        final expected = [
          Loading(),
          Loaded(countryStats: tCountryStats),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
      },
    );

    test(
      'should emit [Loading], [Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConreteCountryStats(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
      },
    );
    test(
      'should emit [Loading], [Error] with a proper Error message when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConreteCountryStats(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForConcreteCountry(tCountry));
      },
    );
  });

  group('GetStatsForRandomCountry', () {
    final tCountryStats = CountryStats(
      country: 'Switzerland',
      population: 1,
      totalCases: 1,
      newCases: 1,
      totalDeaths: 1,
      newDeaths: 1,
      recovered: 1,
      newRecovered: 1,
    );

    test(
      'should get data from the random usecase',
      () async {
        // arrange
        when(mockGetRandomCountryStats(any))
            .thenAnswer((_) async => Right(tCountryStats));
        // act
        bloc.add(GetStatsForRandomCountry());
        await untilCalled(mockGetRandomCountryStats(any));
        // assert
        verify(mockGetRandomCountryStats(NoParams()));
      },
    );

    test(
      'should emit [Loading], [Loaded] when the data is gotten sucessfully',
      () async {
        // arrange
        when(mockGetRandomCountryStats(any))
            .thenAnswer((_) async => Right(tCountryStats));
        // assert later
        final expected = [
          Loading(),
          Loaded(countryStats: tCountryStats),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForRandomCountry());
      },
    );

    test(
      'should emit [Loading], [Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomCountryStats(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForRandomCountry());
      },
    );
    test(
      'should emit [Loading], [Error] with a proper Error message when getting data fails',
      () async {
        // arrange
        when(mockGetRandomCountryStats(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetStatsForRandomCountry());
      },
    );
  });

  group('GetLastCountry', () {
    test(
      'should emit [Loaded], when there is a country cached',
      () async {
        // arrange

        // act

        // assert
      },
    );
  });
}
