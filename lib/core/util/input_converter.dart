import 'package:conum/core/constants/countries.dart';
import 'package:conum/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, String> doesCountryExist(String str) {
    Constants constants = Constants();

    List<String> countries = Constants().countries;

    if (countries.contains(str)) {
      return Right(str);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
