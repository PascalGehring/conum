import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:conum/features/country_stats/data/models/country_stats_model.dart';
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

  String tCountry = 'Switzerland';
  String tTime = '2021-03-29T00:00:00.000Z';

  String url =
      'https://webhooks.mongodb-stitch.com/api/client/v2.0/app/covid-19-qppza/service/REST-API/incoming_webhook/countries_summary?country=$tCountry&min_date=$tTime&max_date=$tTime';

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
