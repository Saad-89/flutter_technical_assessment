import 'package:equatable/equatable.dart';

class Reel extends Equatable {
  var id;
  final String title;
  final String url;
  final String cdnUrl;
  final String thumbCdnUrl;
  var userId;
  final String status;
  final String slug;
  final String encodeStatus;
  var priority;
  var categoryId;
  var totalViews;
  var totalLikes;
  var totalComments;
  var totalShare;
  var totalWishlist;
  var duration;
  final DateTime byteAddedOn;
  final DateTime byteUpdatedOn;
  final String? bunnyStreamVideoId;
  final String? bytePlusVideoId;
  final String language;
  final String orientation;
  var bunnyEncodingStatus;
  final DateTime? deletedAt;
  var videoHeight;
  var videoWidth;
  final String? location;
  var isPrivate;
  var isHideComment;
  final String? description;
  final DateTime? archivedAt;
  final double? latitude;
  final double? longitude;
  final User user;
  final Category category;
  final List<Resolution> resolutions;
  final bool isLiked;
  final bool isWished;
  final bool isFollow;
  final String metaDescription;
  final String metaKeywords;
  final String videoAspectRatio;

  Reel({
    required this.id,
    required this.title,
    required this.url,
    required this.cdnUrl,
    required this.thumbCdnUrl,
    required this.userId,
    required this.status,
    required this.slug,
    required this.encodeStatus,
    required this.priority,
    required this.categoryId,
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShare,
    required this.totalWishlist,
    required this.duration,
    required this.byteAddedOn,
    required this.byteUpdatedOn,
    this.bunnyStreamVideoId,
    this.bytePlusVideoId,
    required this.language,
    required this.orientation,
    required this.bunnyEncodingStatus,
    this.deletedAt,
    required this.videoHeight,
    required this.videoWidth,
    this.location,
    required this.isPrivate,
    required this.isHideComment,
    this.description,
    this.archivedAt,
    this.latitude,
    this.longitude,
    required this.user,
    required this.category,
    required this.resolutions,
    required this.isLiked,
    required this.isWished,
    required this.isFollow,
    required this.metaDescription,
    required this.metaKeywords,
    required this.videoAspectRatio,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    url,
    cdnUrl,
    thumbCdnUrl,
    userId,
    status,
    slug,
    encodeStatus,
    priority,
    categoryId,
    totalViews,
    totalLikes,
    totalComments,
    totalShare,
    totalWishlist,
    duration,
    byteAddedOn,
    byteUpdatedOn,
    bunnyStreamVideoId,
    bytePlusVideoId,
    language,
    orientation,
    bunnyEncodingStatus,
    deletedAt,
    videoHeight,
    videoWidth,
    location,
    isPrivate,
    isHideComment,
    description,
    archivedAt,
    latitude,
    longitude,
    user,
    category,
    resolutions,
    isLiked,
    isWished,
    isFollow,
    metaDescription,
    metaKeywords,
    videoAspectRatio,
  ];
}

class User extends Equatable {
  var userId;
  final String fullname;
  final String username;
  final String profilePicture;
  final String profilePictureCdn;
  final String? designation;
  final bool isSubscriptionActive;
  final bool isFollow;

  User({
    required this.userId,
    required this.fullname,
    required this.username,
    required this.profilePicture,
    required this.profilePictureCdn,
    this.designation,
    required this.isSubscriptionActive,
    required this.isFollow,
  });

  @override
  List<Object?> get props => [
    userId,
    fullname,
    username,
    profilePicture,
    profilePictureCdn,
    designation,
    isSubscriptionActive,
    isFollow,
  ];
}

class Category extends Equatable {
  final String title;

  const Category({required this.title});

  @override
  List<Object> get props => [title];
}

class Resolution extends Equatable {
  final String quality;
  final String url;

  const Resolution({required this.quality, required this.url});

  @override
  List<Object> get props => [quality, url];
}
