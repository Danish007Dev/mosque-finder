import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Core Mosque entity used throughout the domain layer
@immutable
class Mosque extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final String? nameUr;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? phone;
  final String? website;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final bool isCommunityTrusted;
  final int communityTrustScore;
  final List<String> amenities;
  final List<String> prayerTimeTags;
  final double? distanceKm; // Computed dynamically based on user location
  final bool isFavorite;
  final String? description;
  final String? openingHours;

  const Mosque({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameUr,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.phone,
    this.website,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.isCommunityTrusted = false,
    this.communityTrustScore = 0,
    this.amenities = const [],
    this.prayerTimeTags = const [],
    this.distanceKm,
    this.isFavorite = false,
    this.description,
    this.openingHours,
  });

  /// Copy with modified fields
  Mosque copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? nameUr,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? phone,
    String? website,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    bool? isCommunityTrusted,
    int? communityTrustScore,
    List<String>? amenities,
    List<String>? prayerTimeTags,
    double? distanceKm,
    bool? isFavorite,
    String? description,
    String? openingHours,
  }) {
    return Mosque(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      nameUr: nameUr ?? this.nameUr,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      isCommunityTrusted: isCommunityTrusted ?? this.isCommunityTrusted,
      communityTrustScore: communityTrustScore ?? this.communityTrustScore,
      amenities: amenities ?? this.amenities,
      prayerTimeTags: prayerTimeTags ?? this.prayerTimeTags,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        nameUr,
        latitude,
        longitude,
        address,
        city,
        state,
        country,
        zipCode,
        phone,
        website,
        imageUrl,
        rating,
        reviewCount,
        isVerified,
        isCommunityTrusted,
        communityTrustScore,
        amenities,
        prayerTimeTags,
        distanceKm,
        isFavorite,
        description,
        openingHours,
      ];

  @override
  String toString() => 'Mosque(id: $id, name: $name, distance: ${distanceKm?.toStringAsFixed(1)}km)';
}
