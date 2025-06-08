import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/reel.dart';
import '../../domain/repositories/reels_repository.dart';
import '../datasources/reels_local_data_source.dart';
import '../datasources/reels_remote_data_source.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remoteDataSource;
  final ReelsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  // Keep track of cached reels for pagination
  final List<Reel> _cachedReels = [];
  bool _hasReachedMax = false;

  ReelsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<List<Reel>> getReels({
    required int page,
    required int limit,
    bool refresh = false,
  }) async {
    try {
      // If refresh is requested, clear cached data
      if (refresh) {
        _cachedReels.clear();
        _hasReachedMax = false;
        await localDataSource.clearCache();
      }

      // For first page, try to get cached data first
      if (page == 1 && _cachedReels.isEmpty && !refresh) {
        final isConnected = await networkInfo.isConnected;

        if (!isConnected) {
          // No internet, try to get cached data
          try {
            final cachedReels = await localDataSource.getCachedReels();
            _cachedReels.addAll(cachedReels);
            return Right(cachedReels);
          } catch (e) {
            return const Left(
              NetworkFailure(message: AppConstants.networkFailureMessage),
            );
          }
        }

        // Check if cache is valid and not expired
        final isCacheExpired = await localDataSource.isCacheExpired();
        if (!isCacheExpired) {
          try {
            final cachedReels = await localDataSource.getCachedReels();
            _cachedReels.addAll(cachedReels);
            return Right(cachedReels);
          } catch (e) {
            // Cache error, continue to fetch from remote
          }
        }
      }

      // Check internet connection for remote data
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(
          NetworkFailure(message: AppConstants.networkFailureMessage),
        );
      }

      // If we've reached max and not refreshing, return empty list
      if (_hasReachedMax && !refresh && page > 1) {
        return const Right([]);
      }

      // Fetch from remote
      final remoteReels = await remoteDataSource.getReels(
        page: page,
        limit: limit,
      );

      // Check if we've reached the end
      if (remoteReels.length < limit) {
        _hasReachedMax = true;
      }

      // For first page or refresh, replace cached reels
      if (page == 1 || refresh) {
        _cachedReels.clear();
        _cachedReels.addAll(remoteReels);

        // Cache the first page data
        if (remoteReels.isNotEmpty) {
          await localDataSource.cacheReels(remoteReels);
        }
      } else {
        // For subsequent pages, append to cached reels
        _cachedReels.addAll(remoteReels);
      }

      return Right(remoteReels);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ParseException catch (e) {
      return Left(ParseFailure(message: e.message));
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: '${AppConstants.unexpectedFailureMessage}: $e',
        ),
      );
    }
  }
}
