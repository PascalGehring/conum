import 'package:conum/core/util/get_suggestions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GetSuggestions getSuggestions;

  setUp(() {
    getSuggestions = GetSuggestions();
  });

  List<dynamic> tCountryExpectedList = ['Sweden', 'Switzerland'];

  test(
    'should return a list of Strings which begins with [inputStr]',
    () async {
      // arrange
      final String inputStr = 'Sw';
      // act
      final result = getSuggestions(inputStr);
      // assert
      expect(result, tCountryExpectedList);
    },
  );
}
