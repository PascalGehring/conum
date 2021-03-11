import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
import 'package:conum/core/error/failures.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:conum/features/country_stats/data/models/country_stats_model.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  CountryStatsRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = CountryStatsRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSucess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('stats.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getCountryStats', () {
    final String tCountry = 'Switzerland';
    final tCountryStatsModel =
        CountryStatsModel.fromRemoteJson(json.decode(fixture('stats.json')));

    test(
      '''should perform a GET request on a URL with ?Country as the endpoint 
      and x-rapidapi-key header''',
      () async {
        //arrange
        setUpMockHttpClientSucess200();
        // act
        dataSource.getCountryStats(tCountry);
        // assert
        verify(mockHttpClient.get(
            'https://covid-193.p.rapidapi.com/statistics?country=$tCountry',
            headers: {
              'x-rapidapi-key':
                  '44adf06adamshba38826ba7ceef2p12851djsnacfbc18c4ed7',
            }));
      },
    );
    test(
      'should return CountryStats when the response code is 200 (sucess)',
      () async {
        //arrange
        setUpMockHttpClientSucess200();
        // act
        final result = await dataSource.getCountryStats(tCountry);
        // assert
        expect(result, equals(tCountryStatsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 of other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getCountryStats;
        // assert
        expect(() => call(tCountry), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
