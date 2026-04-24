// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosque_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MosqueModel _$MosqueModelFromJson(Map<String, dynamic> json) => MosqueModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  nameAr: json['name_ar'] as String?,
  nameUr: json['name_ur'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  zipCode: json['zip_code'] as String?,
  phone: json['phone'] as String?,
  website: json['website'] as String?,
  imageUrl: json['image_url'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
  isVerified: json['is_verified'] as bool? ?? false,
  isCommunityTrusted: json['is_community_trusted'] as bool? ?? false,
  communityTrustScore: (json['community_trust_score'] as num?)?.toInt() ?? 0,
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  prayerTimeTags:
      (json['prayer_time_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
  isFavorite: json['is_favorite'] as bool? ?? false,
  description: json['description'] as String?,
  openingHours: json['opening_hours'] as String?,
);

Map<String, dynamic> _$MosqueModelToJson(MosqueModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'name_ur': instance.nameUr,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'zip_code': instance.zipCode,
      'phone': instance.phone,
      'website': instance.website,
      'image_url': instance.imageUrl,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_verified': instance.isVerified,
      'is_community_trusted': instance.isCommunityTrusted,
      'community_trust_score': instance.communityTrustScore,
      'amenities': instance.amenities,
      'prayer_time_tags': instance.prayerTimeTags,
      'distance_km': instance.distanceKm,
      'is_favorite': instance.isFavorite,
      'description': instance.description,
      'opening_hours': instance.openingHours,
    };
