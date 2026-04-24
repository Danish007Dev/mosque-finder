// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isEmailVerified: json['is_email_verified'] as bool? ?? false,
  isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  token: json['token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  favoriteMosqueIds:
      (json['favorite_mosque_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  preferences:
      (json['preferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'is_email_verified': instance.isEmailVerified,
  'is_phone_verified': instance.isPhoneVerified,
  'created_at': instance.createdAt.toIso8601String(),
  'last_login_at': instance.lastLoginAt?.toIso8601String(),
  'token': instance.token,
  'refresh_token': instance.refreshToken,
  'favorite_mosque_ids': instance.favoriteMosqueIds,
  'preferences': instance.preferences,
};
