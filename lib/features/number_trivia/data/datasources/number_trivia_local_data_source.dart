import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_example/core/error/exception.dart';
import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTriviaModel? numberTriviaModel);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheNumberTrivia(NumberTriviaModel? numberTriviaModel) {
    return null;
  }

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final cachedNumberTrivia =
        sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (cachedNumberTrivia != null) {
      final numberTrivia =
          NumberTriviaModel.fromJson(json.decode(cachedNumberTrivia));
      return Future.value(numberTrivia);
    } else {
      throw CacheException();
    }
  }
}
