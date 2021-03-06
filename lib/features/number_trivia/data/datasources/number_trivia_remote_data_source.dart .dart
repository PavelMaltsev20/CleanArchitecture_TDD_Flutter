import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel>? getRandomNumberTrivia();
}
