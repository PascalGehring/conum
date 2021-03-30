import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
import 'package:conum/core/util/date_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/country_stats_model.dart';

abstract class CountryStatsRemoteDataSource {
  /// Calls the https://covid-193.p.rapidapi.com/statistics?country={country} endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CountryStatsModel> getCountryStats(String country);
}

// TODO: Extract response map from big Map

class CountryStatsRemoteDataSourceImpl extends CountryStatsRemoteDataSource {
  final http.Client client;

  CountryStatsRemoteDataSourceImpl({@required this.client});
  @override
  Future<CountryStatsModel> getCountryStats(String country) async {
    final String time = DateManager().getDate();

    //print(dateTime);

    final response = await client.get(
        'https://webhooks.mongodb-stitch.com/api/client/v2.0/app/covid-19-qppza/service/REST-API/incoming_webhook/countries_summary?country=$country&min_date=$time&max_date=$time');

    if (response.statusCode == 200) {
      return CountryStatsModel.fromRemoteJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
