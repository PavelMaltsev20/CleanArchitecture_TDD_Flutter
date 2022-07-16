import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_example/core/error/exception.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("Get last number trivia from shared preferences", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));

    test(
        "should return NumberTrivia from SharedPreference when there is one in the cache",
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture("trivia_cached.json"));

      final result = await dataSource.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));

      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw cacheException when there is not a cached value.",
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  /* Todo implement this test
    group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () {
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });

   */
}
