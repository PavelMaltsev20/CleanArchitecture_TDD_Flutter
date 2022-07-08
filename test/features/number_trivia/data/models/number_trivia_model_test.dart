import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");

  test('should be subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
}
