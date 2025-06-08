class AppConstants {
  // API
  static const String baseUrl = 'https://backend-cj4o057m.fctl.app';
  static const String reelsEndpoint = '/bytes/scroll';
  static const int defaultPageSize = 10;
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Cache
  static const String cachedReelsKey = 'CACHED_REELS';
  static const int cacheExpirationTimeInMinutes = 30;

  // UI
  static const double reelItemAspectRatio = 9 / 16;
  static const int maxCachedReels = 100;

  // Error Messages
  static const String serverFailureMessage = 'Server Failure';
  static const String cacheFailureMessage = 'Cache Failure';
  static const String networkFailureMessage = 'Network Failure';
  static const String unexpectedFailureMessage = 'Unexpected Error Occurred';

  // Success Messages
  static const String reelsFetchedSuccessfully = 'Reels fetched successfully';

  // Video Player
  static const Duration videoPlayerSeekDuration = Duration(seconds: 10);
  static const double videoPlayerAspectRatio = 16 / 9;
}
