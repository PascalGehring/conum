import 'package:conum/core/constants/countries.dart';

class GetFlag {
  String call(String country) {
    Map<String, String> countryMap = Constants().countryMap;

    String countryCode = countryMap[country];

    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    return flag;
  }
}
