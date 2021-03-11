import 'package:conum/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('does country exist', () {
    test(
      'should return the country when the country is in list',
      () async {
        // arrange
        final str = 'Switzerland';
        // act
        final result = inputConverter.doesCountryExist(str);
        // assert
        expect(result, Right('Switzerland'));
      },
    );

    test(
      'should return a [InvalidInputFailure] when country is not in list or is invalid',
      () async {
        // arrange
        final str = 'abcd';
        // act
        final result = inputConverter.doesCountryExist(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
