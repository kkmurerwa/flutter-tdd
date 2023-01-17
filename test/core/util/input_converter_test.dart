import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/utils/InputConverter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when string represents an unsigned integer', () {
      const str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });

    test('should return Failure when string is not integer', (){
      const str = '1.0';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return Failure when string is a negative integer', (){
      const str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}