import 'package:conum/core/constants/countries.dart';
import 'package:conum/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, String> doesCountryExist(String str) {
    List<String> countries = Constants().getcountryList();

    if (countries.contains(str)) {
      return Right(str);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
