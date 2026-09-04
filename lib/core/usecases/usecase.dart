import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Base contract for all business logic use cases.
/// Enforces functional `Either<Failure, T>` return types and single responsibility.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Generic parameter object for use cases requiring no input arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
