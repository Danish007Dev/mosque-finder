import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Data layer model for AppUser with JSON serialization
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final bool isPhoneVerified;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  final String? token;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'favorite_mosque_ids')
  final List<String> favoriteMosqueIds;
  final Map<String, String> preferences;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.lastLoginAt,
    this.token,
    this.refreshToken,
    this.favoriteMosqueIds = const [],
    this.preferences = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  AppUser toEntity() {
    return AppUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      token: token,
      refreshToken: refreshToken,
      favoriteMosqueIds: favoriteMosqueIds,
      preferences: preferences,
    );
  }

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      isEmailVerified: user.isEmailVerified,
      isPhoneVerified: user.isPhoneVerified,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      token: user.token,
      refreshToken: user.refreshToken,
      favoriteMosqueIds: user.favoriteMosqueIds,
      preferences: user.preferences,
    );
  }
}
