// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['id'] as String,
  mosqueId: json['mosque_id'] as String,
  userName: json['user_name'] as String,
  userAvatarUrl: json['user_avatar_url'] as String?,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
  isVerifiedUser: json['is_verified_user'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mosque_id': instance.mosqueId,
      'user_name': instance.userName,
      'user_avatar_url': instance.userAvatarUrl,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'likes_count': instance.likesCount,
      'is_verified_user': instance.isVerifiedUser,
      'tags': instance.tags,
    };
