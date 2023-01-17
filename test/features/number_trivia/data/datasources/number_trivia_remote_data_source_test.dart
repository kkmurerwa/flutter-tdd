import 'dart:convert';

import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp((){
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should make a GET request with number path URL and json response', () async {
      setUpMockHttpClientSuccess();
      
      dataSource.getConcreteNumberTrivia(tNumber);
      
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return number trivia when response code is 200 (success)', () async {
      setUpMockHttpClientSuccess();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when response code is failure', () async {
      setUpMockHttpClientFailure();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should make a GET request with number path URL and json response', () async {
      setUpMockHttpClientSuccess();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return number trivia when response code is 200 (success)', () async {
      setUpMockHttpClientSuccess();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when response code is failure', () async {
      setUpMockHttpClientFailure();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
