import 'package:dartz/dartz.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/core/usecases/usecase.dart';
import 'package:tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class GetRandomTrivia extends UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;

  GetRandomTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia?>> call(NoParams params) async{
    return await repository.getRandomNumberTrivia();
  }
}