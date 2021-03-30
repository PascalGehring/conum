import '../constants/countries.dart';

class GetSuggestions {
  call(String str) {
    if (str != '') {
      List<dynamic> countries = Constants.countries;

      List<dynamic> suggestionsList = countries
          .where(
              (element) => element.toLowerCase().startsWith(str.toLowerCase()))
          .take(5)
          .toList();

      return suggestionsList;
    }
  }
}
