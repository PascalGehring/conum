import 'package:conum/core/constants/countries.dart';

class GetSuggestions {
  final String str;

  GetSuggestions(this.str);

  call() {
    List<dynamic> countries = Constants.countries;

    List<dynamic> suggestionsList = countries
        .where((element) => element.toLowerCase().startsWith(str.toLowerCase()))
        .toList();

    return suggestionsList;
  }
}
