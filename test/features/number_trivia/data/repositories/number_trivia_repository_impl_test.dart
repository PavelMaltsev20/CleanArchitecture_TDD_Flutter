import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/error/exception.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/core/network//network_info.dart';
import 'package:tdd_example/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:tdd_example/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart%20.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group("Device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("Device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((invocation) async => false);
      });

      body();
    });
  }

  group("Get concrete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "Should return remote data when the call to remote data source is successful",
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "Should cache data locally when the call to remote data source is successful",
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "Should return server failure when the call to remote data source is unsuccessful",
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test("should return last locally cached data when cached data is present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("Get random number trivia", () {
    final tNumberTriviaModel =
    NumberTriviaModel(text: "Test trivia", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "Should return remote data when the call to remote data source is successful",
              () async {
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();

            verify(() => mockRemoteDataSource.getRandomNumberTrivia());

            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          "Should cache data locally when the call to remote data source is successful",
              () async {
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            await repository.getRandomNumberTrivia();

            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          "Should return server failure when the call to remote data source is unsuccessful",
              () async {
            when(() => mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            final result = await repository.getRandomNumberTrivia();
            verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
    });

    runTestsOffline(() {
      test("should return last locally cached data when cached data is present",
              () async {
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            expect(result, Right(tNumberTrivia));
          });

      test("should return CacheFailure when there is no cached data present",
              () async {
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repository.getRandomNumberTrivia();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}
