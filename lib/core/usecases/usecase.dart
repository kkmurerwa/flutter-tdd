import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd/core/error/failures.dart';

abstract class UseCase<Type, Param> {
  Future<Either<Failure, Type>> execute(Param params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}