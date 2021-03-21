import 'package:conum/features/country_stats/domain/entities/country_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<CountryStats> {
  NavCubit() : super(null);

  void showCountryPage(CountryStats stats) => emit(stats);

  void popToSearch() => emit(null);
}
