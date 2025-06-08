import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reel_model.dart';

abstract class ReelsLocalDataSource {
  Future<List<ReelModel>> getCachedReels();
  Future<void> cacheReels(List<ReelModel> reels);
  Future<void> clearCache();
  Future<bool> isCacheExpired();
}

class ReelsLocalDataSourceImpl implements ReelsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReelsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ReelModel>> getCachedReels() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.cachedReelsKey,
      );

      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map(
              (jsonItem) =>
                  ReelModel.fromJson(jsonItem as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw const CacheException(message: 'No cached reels found');
      }
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException(message: 'Failed to get cached reels: $e');
    }
  }

  @override
  Future<void> cacheReels(List<ReelModel> reels) async {
    try {
      // Limit cache size to prevent memory issues
      final reelsToCache = reels.length > AppConstants.maxCachedReels
          ? reels.take(AppConstants.maxCachedReels).toList()
          : reels;

      final jsonString = json.encode(
        reelsToCache.map((reel) => reel.toJson()).toList(),
      );

      await sharedPreferences.setString(
        AppConstants.cachedReelsKey,
        jsonString,
      );
      await sharedPreferences.setInt(
        '${AppConstants.cachedReelsKey}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache reels: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.cachedReelsKey);
      await sharedPreferences.remove(
        '${AppConstants.cachedReelsKey}_timestamp',
      );
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> isCacheExpired() async {
    try {
      final timestamp = sharedPreferences.getInt(
        '${AppConstants.cachedReelsKey}_timestamp',
      );

      if (timestamp == null) {
        return true;
      }

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(cachedTime);

      return difference.inMinutes > AppConstants.cacheExpirationTimeInMinutes;
    } catch (e) {
      // If there's any error checking cache expiration, consider it expired
      return true;
    }
  }
}
