import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/mosque.dart';

part 'mosque_model.g.dart';

/// Data layer model for Mosque with JSON serialization
@JsonSerializable()
class MosqueModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @JsonKey(name: 'name_ur')
  final String? nameUr;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  @JsonKey(name: 'zip_code')
  final String? zipCode;
  final String? phone;
  final String? website;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final double rating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'is_community_trusted')
  final bool isCommunityTrusted;
  @JsonKey(name: 'community_trust_score')
  final int communityTrustScore;
  final List<String> amenities;
  @JsonKey(name: 'prayer_time_tags')
  final List<String> prayerTimeTags;
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  final String? description;
  @JsonKey(name: 'opening_hours')
  final String? openingHours;

  const MosqueModel({
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

  factory MosqueModel.fromJson(Map<String, dynamic> json) =>
      _$MosqueModelFromJson(json);

  Map<String, dynamic> toJson() => _$MosqueModelToJson(this);

  /// Convert model to domain entity
  Mosque toEntity() {
    return Mosque(
      id: id,
      name: name,
      nameAr: nameAr,
      nameUr: nameUr,
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
      phone: phone,
      website: website,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      isVerified: isVerified,
      isCommunityTrusted: isCommunityTrusted,
      communityTrustScore: communityTrustScore,
      amenities: amenities,
      prayerTimeTags: prayerTimeTags,
      distanceKm: distanceKm,
      isFavorite: isFavorite,
      description: description,
      openingHours: openingHours,
    );
  }

  /// Create model from domain entity
  factory MosqueModel.fromEntity(Mosque mosque) {
    return MosqueModel(
      id: mosque.id,
      name: mosque.name,
      nameAr: mosque.nameAr,
      nameUr: mosque.nameUr,
      latitude: mosque.latitude,
      longitude: mosque.longitude,
      address: mosque.address,
      city: mosque.city,
      state: mosque.state,
      country: mosque.country,
      zipCode: mosque.zipCode,
      phone: mosque.phone,
      website: mosque.website,
      imageUrl: mosque.imageUrl,
      rating: mosque.rating,
      reviewCount: mosque.reviewCount,
      isVerified: mosque.isVerified,
      isCommunityTrusted: mosque.isCommunityTrusted,
      communityTrustScore: mosque.communityTrustScore,
      amenities: mosque.amenities,
      prayerTimeTags: mosque.prayerTimeTags,
      distanceKm: mosque.distanceKm,
      isFavorite: mosque.isFavorite,
      description: mosque.description,
      openingHours: mosque.openingHours,
    );
  }

  /// Create a list of entities from a list of models
  static List<Mosque> toEntityList(List<MosqueModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Create a list of models from a list of entities
  static List<MosqueModel> fromEntityList(List<Mosque> entities) {
    return entities.map((entity) => MosqueModel.fromEntity(entity)).toList();
  }

  /// Generate mock mosque data for development
  static List<MosqueModel> generateMockData() {
    return [
      MosqueModel(
        id: '1',
        name: 'Jama Masjid',
        nameAr: 'مسجد جامع',
        nameUr: 'جامع مسجد',
        latitude: 28.6507,
        longitude: 77.2334,
        address: 'Chandni Chowk, Old Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        phone: '+91-11-23223456',
        imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87',
        rating: 4.7,
        reviewCount: 2340,
        isVerified: true,
        isCommunityTrusted: true,
        communityTrustScore: 92,
        amenities: ['wudu_area', 'parking', 'women_section', 'library'],
        prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
        distanceKm: 1.2,
        description: 'One of the largest mosques in India, built by Mughal Emperor Shah Jahan.',
        openingHours: 'Open 24 hours',
      ),
      MosqueModel(
        id: '2',
        name: 'Hazrat Nizamuddin Dargah',
        latitude: 28.5918,
        longitude: 77.2415,
        address: 'Nizamuddin West, Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa',
        rating: 4.5,
        reviewCount: 1876,
        isVerified: true,
        isCommunityTrusted: true,
        communityTrustScore: 88,
        amenities: ['wudu_area', 'parking'],
        prayerTimeTags: ['5_times', 'jumuah'],
        distanceKm: 3.5,
        description: 'Famous Sufi shrine and mosque complex in Delhi.',
      ),
      MosqueModel(
        id: '3',
        name: 'Lotus Temple (Masjid)',
        latitude: 28.5535,
        longitude: 77.2588,
        address: 'Kalkaji, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        imageUrl: 'https://images.unsplash.com/photo-1547586696-ea22b4d4235d',
        rating: 4.3,
        reviewCount: 3201,
        isVerified: true,
        isCommunityTrusted: false,
        communityTrustScore: 55,
        amenities: ['wudu_area', 'parking', 'women_section'],
        prayerTimeTags: ['5_times', 'jumuah'],
        distanceKm: 5.8,
        description: 'A modern architectural marvel and place of worship.',
      ),
      MosqueModel(
        id: '4',
        name: 'Al-Hilal Mosque',
        nameAr: 'مسجد الهلال',
        latitude: 28.5678,
        longitude: 77.1987,
        address: 'Green Park, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        phone: '+91-11-26567890',
        imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4',
        rating: 4.1,
        reviewCount: 892,
        isVerified: true,
        isCommunityTrusted: false,
        communityTrustScore: 45,
        amenities: ['wudu_area', 'parking', 'women_section', 'air_conditioned'],
        prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid'],
        distanceKm: 4.2,
        description: 'Community mosque with modern facilities in South Delhi.',
      ),
      MosqueModel(
        id: '5',
        name: 'Masjid Rahman',
        nameAr: 'مسجد الرحمن',
        nameUr: 'مسجد رحمان',
        latitude: 28.6123,
        longitude: 77.2345,
        address: 'Lajpat Nagar, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        imageUrl: 'https://images.unsplash.com/photo-1589745457396-2e2c0a7f9322',
        rating: 3.8,
        reviewCount: 456,
        isVerified: false,
        isCommunityTrusted: false,
        communityTrustScore: 25,
        amenities: ['wudu_area'],
        prayerTimeTags: ['5_times', 'jumuah'],
        distanceKm: 2.8,
        description: 'Small neighborhood mosque serving the local community.',
      ),
      MosqueModel(
        id: '6',
        name: 'Faisal Mosque',
        nameAr: 'مسجد فيصل',
        latitude: 28.5981,
        longitude: 77.1895,
        address: 'Vasant Kunj, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        phone: '+91-11-26123456',
        website: 'https://faisalmasjid.com',
        imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769',
        rating: 4.6,
        reviewCount: 1567,
        isVerified: true,
        isCommunityTrusted: true,
        communityTrustScore: 90,
        amenities: ['wudu_area', 'parking', 'women_section', 'library', 'cafe'],
        prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid', 'classes'],
        distanceKm: 6.1,
        description: 'Large mosque known for its beautiful architecture and community programs.',
      ),
      MosqueModel(
        id: '7',
        name: 'Madina Masjid',
        nameUr: 'مدینہ مسجد',
        latitude: 28.6234,
        longitude: 77.2109,
        address: 'Shaheen Bagh, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa',
        rating: 4.0,
        reviewCount: 723,
        isVerified: false,
        isCommunityTrusted: true,
        communityTrustScore: 72,
        amenities: ['wudu_area', 'parking', 'women_section'],
        prayerTimeTags: ['5_times', 'jumuah'],
        distanceKm: 0.8,
        description: 'Active community mosque with daily Quran classes.',
      ),
      MosqueModel(
        id: '8',
        name: 'Iqbal Masjid',
        nameUr: 'اقبال مسجد',
        latitude: 28.6456,
        longitude: 77.2211,
        address: 'Safdarjung Enclave, New Delhi',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4',
        rating: 4.2,
        reviewCount: 634,
        isVerified: true,
        isCommunityTrusted: false,
        communityTrustScore: 48,
        amenities: ['wudu_area', 'parking', 'air_conditioned'],
        prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
        distanceKm: 1.5,
        description: 'Modern mosque with AC prayer halls.',
      ),
    ];
  }
}
