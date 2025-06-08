import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/reel.dart';

@JsonSerializable(explicitToJson: true)
class ReelModel extends Reel {
  ReelModel({
    required super.id,
    required super.title,
    required super.url,
    required super.cdnUrl,
    required super.thumbCdnUrl,
    required super.userId,
    required super.status,
    required super.slug,
    required super.encodeStatus,
    required super.priority,
    required super.categoryId,
    required super.totalViews,
    required super.totalLikes,
    required super.totalComments,
    required super.totalShare,
    required super.totalWishlist,
    required super.duration,
    required super.byteAddedOn,
    required super.byteUpdatedOn,
    super.bunnyStreamVideoId,
    super.bytePlusVideoId,
    required super.language,
    required super.orientation,
    required super.bunnyEncodingStatus,
    super.deletedAt,
    required super.videoHeight,
    required super.videoWidth,
    super.location,
    required super.isPrivate,
    required super.isHideComment,
    super.description,
    super.archivedAt,
    super.latitude,
    super.longitude,
    required super.user,
    required super.category,
    required super.resolutions,
    required super.isLiked,
    required super.isWished,
    required super.isFollow,
    required super.metaDescription,
    required super.metaKeywords,
    required super.videoAspectRatio,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: _parseInt(json['id']),
      title: _parseString(json['title']),
      url: _parseString(json['url']),
      cdnUrl: _parseString(json['cdn_url']),
      thumbCdnUrl: _parseString(json['thumb_cdn_url']),
      userId: _parseInt(json['user_id']),
      status: _parseString(json['status']),
      slug: _parseString(json['slug']),
      encodeStatus: _parseString(json['encode_status']),
      priority: _parseInt(json['priority']),
      categoryId: _parseInt(json['category_id']),
      totalViews: _parseInt(json['total_views']),
      totalLikes: _parseInt(json['total_likes']),
      totalComments: _parseInt(json['total_comments']),
      totalShare: _parseInt(json['total_share']),
      totalWishlist: _parseInt(json['total_wishlist']),
      duration: _parseInt(json['duration']),
      byteAddedOn: _parseDateTime(json['byte_added_on']),
      byteUpdatedOn: _parseDateTime(json['byte_updated_on']),
      bunnyStreamVideoId: _parseStringOrNull(json['bunny_stream_video_id']),
      bytePlusVideoId: _parseStringOrNull(json['byte_plus_video_id']),
      language: _parseString(json['language']),
      orientation: _parseString(json['orientation']),
      bunnyEncodingStatus: _parseInt(json['bunny_encoding_status']),
      deletedAt: _parseDateTimeOrNull(json['deleted_at']),
      videoHeight: _parseInt(json['video_height']),
      videoWidth: _parseInt(json['video_width']),
      location: _parseStringOrNull(json['location']),
      isPrivate: _parseInt(json['is_private']),
      isHideComment: _parseInt(json['is_hide_comment']),
      description: _parseStringOrNull(json['description']),
      archivedAt: _parseDateTimeOrNull(json['archived_at']),
      latitude: _parseDoubleOrNull(json['latitude']),
      longitude: _parseDoubleOrNull(json['longitude']),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>? ?? {},
      ),
      resolutions:
          (json['resolutions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ResolutionModel.fromJson(e as Map<String, dynamic>? ?? {}),
              )
              .toList() ??
          [],
      isLiked: _parseBool(json['is_liked']),
      isWished: _parseBool(json['is_wished']),
      isFollow: _parseBool(json['is_follow']),
      metaDescription: _parseString(json['meta_description']),
      metaKeywords: _parseString(json['meta_keywords']),
      videoAspectRatio: _parseString(json['video_aspect_ratio']),
    );
  }

  // Helper methods for safe type conversion
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String? _parseStringOrNull(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static double? _parseDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    if (value is int) return value == 1;
    return false;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static DateTime? _parseDateTimeOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'cdn_url': cdnUrl,
      'thumb_cdn_url': thumbCdnUrl,
      'user_id': userId,
      'status': status,
      'slug': slug,
      'encode_status': encodeStatus,
      'priority': priority,
      'category_id': categoryId,
      'total_views': totalViews,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'total_share': totalShare,
      'total_wishlist': totalWishlist,
      'duration': duration,
      'byte_added_on': byteAddedOn.toIso8601String(),
      'byte_updated_on': byteUpdatedOn.toIso8601String(),
      'bunny_stream_video_id': bunnyStreamVideoId,
      'byte_plus_video_id': bytePlusVideoId,
      'language': language,
      'orientation': orientation,
      'bunny_encoding_status': bunnyEncodingStatus,
      'deleted_at': deletedAt?.toIso8601String(),
      'video_height': videoHeight,
      'video_width': videoWidth,
      'location': location,
      'is_private': isPrivate,
      'is_hide_comment': isHideComment,
      'description': description,
      'archived_at': archivedAt?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'user': (user as UserModel).toJson(),
      'category': (category as CategoryModel).toJson(),
      'resolutions': resolutions
          .map((e) => (e as ResolutionModel).toJson())
          .toList(),
      'is_liked': isLiked,
      'is_wished': isWished,
      'is_follow': isFollow,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
      'video_aspect_ratio': videoAspectRatio,
    };
  }
}

@JsonSerializable()
class UserModel extends User {
  UserModel({
    required super.userId,
    required super.fullname,
    required super.username,
    required super.profilePicture,
    required super.profilePictureCdn,
    super.designation,
    required super.isSubscriptionActive,
    required super.isFollow,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: ReelModel._parseInt(json['user_id']),
      fullname: ReelModel._parseString(json['fullname']),
      username: ReelModel._parseString(json['username']),
      profilePicture: ReelModel._parseString(json['profile_picture']),
      profilePictureCdn: ReelModel._parseString(json['profile_picture_cdn']),
      designation: ReelModel._parseStringOrNull(json['designation']),
      isSubscriptionActive: ReelModel._parseBool(
        json['is_subscription_active'],
      ),
      isFollow: ReelModel._parseBool(json['is_follow']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'fullname': fullname,
      'username': username,
      'profile_picture': profilePicture,
      'profile_picture_cdn': profilePictureCdn,
      'designation': designation,
      'is_subscription_active': isSubscriptionActive,
      'is_follow': isFollow,
    };
  }
}

@JsonSerializable()
class CategoryModel extends Category {
  const CategoryModel({required super.title});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(title: ReelModel._parseString(json['title']));
  }

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}

@JsonSerializable()
class ResolutionModel extends Resolution {
  const ResolutionModel({required super.quality, required super.url});

  factory ResolutionModel.fromJson(Map<String, dynamic> json) {
    return ResolutionModel(
      quality: ReelModel._parseString(json['quality']),
      url: ReelModel._parseString(json['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'quality': quality, 'url': url};
  }
}
