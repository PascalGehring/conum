import 'dart:convert';

import 'package:conum/core/error/exceptions.dart';
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
    final response = await client.get(
        'https://covid-193.p.rapidapi.com/statistics?country=$country',
        headers: {
          'x-rapidapi-key':
              '44adf06adamshba38826ba7ceef2p12851djsnacfbc18c4ed7',
        });

    if (response.statusCode == 200) {
      return CountryStatsModel.fromRemoteJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
