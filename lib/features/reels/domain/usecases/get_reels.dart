import 'package:dartz/dartz.dart';
import 'package:flutter_developer_technical_assessment/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/reel.dart';
import '../repositories/reels_repository.dart';

class GetReels implements UseCase<List<Reel>, PaginationParams> {
  final ReelsRepository repository;

  GetReels(this.repository);

  @override
  Future<Either<Failure, List<Reel>>> call(PaginationParams params) async {
    return await repository.getReels(
      page: params.page,
      limit: params.limit,
      refresh: params.refresh,
    );
  }
}
