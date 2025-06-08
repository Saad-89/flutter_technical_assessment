import '../../../../core/utils/typedef.dart';
import '../entities/reel.dart';

abstract class ReelsRepository {
  ResultFuture<List<Reel>> getReels({
    required int page,
    required int limit,
    bool refresh = false,
  });
}
