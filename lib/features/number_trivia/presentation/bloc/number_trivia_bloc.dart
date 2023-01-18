import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/utils/InputConverter.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - Please enter a valid number';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter
  }) : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(EmptyState()) {
          on<NumberTriviaEvent> (numberTriviaEventObserver);
        }

  FutureOr<void> numberTriviaEventObserver(event, emit) async {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

      await inputEither.fold(
        (failure) => emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)),
        (integer) async {
          emit(LoadingState());

          final failureOrTrivia = await getConcreteNumberTrivia.execute(Params(number: integer));

          _eitherSuccessorErrorState(emit, failureOrTrivia);
        }
      );
    } else if (event is GetTriviaForRandomNumber) {
      emit(LoadingState());

      final failureOrTrivia = await getRandomNumberTrivia.execute(NoParams());

      _eitherSuccessorErrorState(emit, failureOrTrivia);
    }
  }

  Future<void> _eitherSuccessorErrorState(emit, Either<Failure, NumberTrivia> failureOrTrivia) async {
    emit(failureOrTrivia.fold(
      (failure) => ErrorState(message: mapFailureToMessage(failure)),
      (trivia) => SuccessState(trivia: trivia)
    ));
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure: return SERVER_FAILURE_MESSAGE;
      case CacheFailure: return CACHE_FAILURE_MESSAGE;
      default: return "Unexpected Error";
    }
  }
}
