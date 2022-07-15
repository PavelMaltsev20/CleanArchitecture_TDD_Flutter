import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTriviaModel? numberTriviaModel);
}
