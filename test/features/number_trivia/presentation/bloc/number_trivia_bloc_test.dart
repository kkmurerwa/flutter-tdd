import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/utils/InputConverter.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>()
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc bloc;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  
  test('initial state should be empty', () {
    expect(bloc.state, equals(EmptyState()));
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "Test trivia", number: tNumberParsed);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test('should call InputConverter to convert input string to unsigned integer', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia.execute(any));

      verify(mockGetConcreteNumberTrivia.execute(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Success] when concrete number data is gotten successfully', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [
        LoadingState(),
        const SuccessState(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting concrete number data fails', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Left(ServerFailure("")));

      final expected = [
        LoadingState(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with proper error message when getting concrete number data fails', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Left(CacheFailure("")));

      final expected = [
        LoadingState(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('getTriviaForRandomNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "Test trivia", number: tNumberParsed);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia.execute(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia.execute(any));

      verify(mockGetRandomNumberTrivia.execute(NoParams()));
    });

    test('should emit [Loading, Success] when random number data is gotten successfully', () async {
      when(mockGetRandomNumberTrivia.execute(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [
        LoadingState(),
        const SuccessState(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting random number data fails', () async {
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia.execute(any))
          .thenAnswer((_) async => const Left(ServerFailure("")));

      final expected = [
        LoadingState(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with proper error message when getting random number data fails', () async {
      when(mockGetRandomNumberTrivia.execute(any))
          .thenAnswer((_) async => const Left(CacheFailure("")));

      final expected = [
        LoadingState(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}