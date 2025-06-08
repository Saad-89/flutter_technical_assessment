import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseStream<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final bool refresh;

  const PaginationParams({
    required this.page,
    required this.limit,
    this.refresh = false,
  });

  @override
  List<Object> get props => [page, limit, refresh];
}
