import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/review.dart';

part 'review_model.g.dart';

/// Data layer model for Review with JSON serialization
@JsonSerializable()
class ReviewModel {
  final String id;
  @JsonKey(name: 'mosque_id')
  final String mosqueId;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'user_avatar_url')
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'is_verified_user')
  final bool isVerifiedUser;
  final List<String> tags;

  const ReviewModel({
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

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  Review toEntity() {
    return Review(
      id: id,
      mosqueId: mosqueId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likesCount: likesCount,
      isVerifiedUser: isVerifiedUser,
      tags: tags,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      mosqueId: review.mosqueId,
      userName: review.userName,
      userAvatarUrl: review.userAvatarUrl,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      likesCount: review.likesCount,
      isVerifiedUser: review.isVerifiedUser,
      tags: review.tags,
    );
  }

  /// Generate mock reviews for development
  static List<ReviewModel> generateMockData(String mosqueId) {
    final now = DateTime.now();
    return [
      ReviewModel(
        id: 'r1',
        mosqueId: mosqueId,
        userName: 'Ahmed Khan',
        userAvatarUrl: null,
        rating: 5.0,
        comment: 'Beautiful mosque with peaceful atmosphere. The architecture is stunning!',
        createdAt: now.subtract(const Duration(days: 2)),
        likesCount: 24,
        isVerifiedUser: true,
        tags: ['family_friendly', 'clean'],
      ),
      ReviewModel(
        id: 'r2',
        mosqueId: mosqueId,
        userName: 'Fatima Bi',
        rating: 4.0,
        comment: 'Well-maintained mosque. Women section is clean and spacious.',
        createdAt: now.subtract(const Duration(days: 5)),
        likesCount: 15,
        isVerifiedUser: false,
        tags: ['women_friendly'],
      ),
      ReviewModel(
        id: 'r3',
        mosqueId: mosqueId,
        userName: 'Mohammed Ali',
        rating: 5.0,
        comment: 'Imam gives excellent Friday sermons. Very knowledgeable.',
        createdAt: now.subtract(const Duration(days: 7)),
        likesCount: 31,
        isVerifiedUser: true,
        tags: ['great_imam'],
      ),
      ReviewModel(
        id: 'r4',
        mosqueId: mosqueId,
        userName: 'Sana Rahman',
        rating: 3.5,
        comment: 'Good mosque but parking can be difficult during peak hours.',
        createdAt: now.subtract(const Duration(days: 12)),
        likesCount: 8,
        isVerifiedUser: false,
        tags: ['parking_issues'],
      ),
    ];
  }
}
