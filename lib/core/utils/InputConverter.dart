import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);

      if (integer >= 0) {
        return Right(int.parse(str));
      } else {
        throw const FormatException();
      }
    } on Exception {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}