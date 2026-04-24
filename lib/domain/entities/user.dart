import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// User entity for authentication and profile
@immutable
class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? token;
  final String? refreshToken;
  final List<String> favoriteMosqueIds;
  final Map<String, String> preferences; // e.g., {'language': 'en', 'theme': 'light'}

  const AppUser({
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

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? token,
    String? refreshToken,
    List<String>? favoriteMosqueIds,
    Map<String, String>? preferences,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      favoriteMosqueIds: favoriteMosqueIds ?? this.favoriteMosqueIds,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatarUrl,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        lastLoginAt,
        token,
        refreshToken,
        favoriteMosqueIds,
        preferences,
      ];
}
