import 'package:conum/core/network/network_info.dart';
import 'package:conum/core/util/input_converter.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_local_data_source.dart';
import 'package:conum/features/country_stats/data/datasources/country_stats_remote_data_source.dart';
import 'package:conum/features/country_stats/data/repository/country_stats_repository_impl.dart';
import 'package:conum/features/country_stats/domain/repositories/country_stats_repository.dart';
import 'package:conum/features/country_stats/domain/usecases/clear_cached_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_concrete_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_last_country_stats.dart';
import 'package:conum/features/country_stats/domain/usecases/get_random_country_stats.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Country Stats
  // Bloc
  sl.registerFactory(() => CountryStatsBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
        last: sl(),
        clear: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetConreteCountryStats(sl()));
  sl.registerLazySingleton(() => GetRandomCountryStats(sl()));
  sl.registerLazySingleton(() => GetLastCountryStats(sl()));
  sl.registerLazySingleton(() => ClearCachedCountryStats(sl()));

  // Repository
  sl.registerLazySingleton<CountryStatsRepository>(() =>
      CountryStatsRepositoryImpl(
          localDataSource: sl(), networkInfo: sl(), remoteDataSource: sl()));

// Data
  sl.registerLazySingleton<CountryStatsRemoteDataSource>(
      () => CountryStatsRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<CountryStatsLocalDataSource>(
      () => CountryStatsLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerSingleton(http.Client());
}
