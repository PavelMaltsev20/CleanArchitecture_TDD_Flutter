import 'package:dartz/dartz.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/features/number_trivia/data/repositories/number_trivia_repositories.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
