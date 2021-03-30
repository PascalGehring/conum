import '../constants/countries.dart';

class GetSuggestions {
  call(String str) {
    if (str != '') {
      List<String> countries = Constants().getcountryList();

      List<dynamic> suggestionsList = countries
          .where(
              (element) => element.toLowerCase().startsWith(str.toLowerCase()))
          .take(5)
          .toList();

      return suggestionsList;
    }
  }
}
