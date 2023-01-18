part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class EmptyState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class SuccessState extends NumberTriviaState {
  final NumberTrivia trivia;

  const SuccessState({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class ErrorState extends NumberTriviaState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
