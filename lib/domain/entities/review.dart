import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Review entity for mosque ratings and feedback
@immutable
class Review extends Equatable {
  final String id;
  final String mosqueId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final bool isVerifiedUser;
  final List<String> tags;

  const Review({
    required this.id,
    required this.mosqueId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.isVerifiedUser = false,
    this.tags = const [],
  });

  Review copyWith({
    String? id,
    String? mosqueId,
    String? userName,
    String? userAvatarUrl,
    double? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    bool? isVerifiedUser,
    List<String>? tags,
  }) {
    return Review(
      id: id ?? this.id,
      mosqueId: mosqueId ?? this.mosqueId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      isVerifiedUser: isVerifiedUser ?? this.isVerifiedUser,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        mosqueId,
        userName,
        userAvatarUrl,
        rating,
        comment,
        createdAt,
        updatedAt,
        likesCount,
        isVerifiedUser,
        tags,
      ];
}
