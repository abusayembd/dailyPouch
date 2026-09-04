import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/error/exceptions.dart';
import 'package:dailypouch/core/error/failures.dart';
import 'package:dailypouch/features/subscription_tracker/data/datasources/subscription_local_datasource.dart';
import 'package:dailypouch/features/subscription_tracker/data/models/subscription_model.dart';
import 'package:dailypouch/features/subscription_tracker/data/repositories/subscription_repository_impl.dart';
import 'package:dailypouch/features/subscription_tracker/domain/entities/subscription_entity.dart';

class MockSubscriptionLocalDataSource extends Mock
    implements SubscriptionLocalDataSource {}

void main() {
  late SubscriptionRepositoryImpl repository;
  late MockSubscriptionLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSubscriptionLocalDataSource();
    repository = SubscriptionRepositoryImpl(localDataSource: mockDataSource);
  });

  const testModel = SubscriptionModel(
    id: 'sub_1',
    name: 'Spotify',
    amount: 9.99,
    currency: '\$',
    billingCycle: 'monthly',
    nextBillingDate: '2026-10-01T00:00:00.000',
    category: 'entertainment',
    remindDaysBefore: 3,
    isActive: true,
  );

  group('getSubscriptions', () {
    test('should return list of subscription entities when datasource succeeds', () async {
      when(() => mockDataSource.getSubscriptions())
          .thenAnswer((_) async => [testModel]);

      final result = await repository.getSubscriptions();

      expect(result, isA<Right<Failure, List<SubscriptionEntity>>>());
      result.fold(
        (failure) => fail('Should not fail'),
        (list) {
          expect(list.length, equals(1));
          expect(list.first.name, equals('Spotify'));
        },
      );
      verify(() => mockDataSource.getSubscriptions()).called(1);
    });

    test('should return DatabaseFailure when datasource throws DatabaseException', () async {
      when(() => mockDataSource.getSubscriptions())
          .thenThrow(DatabaseException('Disk read error'));

      final result = await repository.getSubscriptions();

      expect(result, isA<Left<Failure, List<SubscriptionEntity>>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (list) => fail('Should not succeed'),
      );
    });
  });
}
