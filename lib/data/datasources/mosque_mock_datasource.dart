import '../../domain/entities/mosque.dart';
import '../../domain/entities/review.dart';

/// ----------------------------------------------------------
/// Mock data source that replaces all remote API calls.
///
/// Generates exactly 5 hardcoded Mosque objects with varying
/// GPS coordinates across Delhi/NCR, dummy reviews, ratings,
/// and verified statuses so the Google Maps widget has data
/// to plot.  Delegates pagination to the repository layer.
/// ----------------------------------------------------------
class MosqueMockDataSource {
  static const int itemsPerPage = 5;

  // ── 5 hardcoded mosques with deliberately varied coords ──
  static final List<Mosque> _allMosques = [
    const Mosque(
      id: '1',
      name: 'Jama Masjid',
      nameAr: '\u0645\u0633\u062C\u062F \u062C\u0627\u0645\u0639',
      nameUr: '\u062C\u0627\u0645\u0639 \u0645\u0633\u062C\u062F',
      latitude: 28.6507,
      longitude: 77.2334,
      address: 'Chandni Chowk, Old Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      phone: '+91-11-23223456',
      website: 'https://jamamasjid.in',
      imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800',
      rating: 4.7,
      reviewCount: 2340,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 92,
      amenities: ['wudu_area', 'parking', 'women_section', 'library'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
      description:
          'One of the largest mosques in India, built by Mughal Emperor Shah Jahan. '
          'Can accommodate 25,000 worshippers.',
      openingHours: '5:00 AM - 10:00 PM',
    ),
    const Mosque(
      id: '2',
      name: 'Hazrat Nizamuddin Dargah',
      latitude: 28.5918,
      longitude: 77.2415,
      address: 'Nizamuddin West, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800',
      rating: 4.5,
      reviewCount: 1876,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 88,
      amenities: ['wudu_area', 'parking'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description:
          'Famous Sufi shrine and mosque complex built in 1325. '
          'Qawwali performances every Thursday evening.',
      openingHours: '5:00 AM - 10:00 PM',
    ),
    const Mosque(
      id: '3',
      name: 'Al-Hilal Mosque',
      nameAr: '\u0645\u0633\u062C\u062F \u0627\u0644\u0647\u0644\u0627\u0644',
      latitude: 28.5678,
      longitude: 77.1987,
      address: 'Green Park, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      phone: '+91-11-26567890',
      imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4?w=800',
      rating: 4.1,
      reviewCount: 892,
      isVerified: true,
      isCommunityTrusted: false,
      communityTrustScore: 45,
      amenities: ['wudu_area', 'parking', 'women_section', 'air_conditioned'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid'],
      description: 'Fully air-conditioned prayer halls and dedicated women\'s section.',
      openingHours: '4:30 AM - 11:00 PM',
    ),
    const Mosque(
      id: '4',
      name: 'Masjid Rahman',
      nameAr: '\u0645\u0633\u062C\u062F \u0627\u0644\u0631\u062D\u0645\u0646',
      nameUr: '\u0645\u0633\u062C\u062F \u0631\u062D\u0645\u0627\u0646',
      latitude: 28.6123,
      longitude: 77.2345,
      address: 'Lajpat Nagar, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1589745457396-2e2c0a7f9322?w=800',
      rating: 3.8,
      reviewCount: 456,
      isVerified: false,
      isCommunityTrusted: false,
      communityTrustScore: 25,
      amenities: ['wudu_area'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Small neighbourhood mosque serving the local community.',
      openingHours: '5:00 AM - 9:00 PM',
    ),
    const Mosque(
      id: '5',
      name: 'Faisal Mosque',
      nameAr: '\u0645\u0633\u062C\u062F \u0641\u06CC\u0635\u0644',
      latitude: 28.5981,
      longitude: 77.1895,
      address: 'Vasant Kunj, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      phone: '+91-11-26123456',
      website: 'https://faisalmasjid.in',
      imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=800',
      rating: 4.6,
      reviewCount: 1567,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 90,
      amenities: ['wudu_area', 'parking', 'women_section', 'library', 'cafe'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid', 'classes'],
      description:
          'Large mosque known for its beautiful architecture and community programs.',
      openingHours: '4:00 AM - 11:30 PM',
    ),
  ];

  // ── Dummy reviews per mosque ──────────────────────────────
  static final Map<String, List<Review>> _reviewsByMosqueId = {
    for (final m in _allMosques)
      m.id: _generateReviews(m.id),
  };

  static List<Review> _generateReviews(String mosqueId) {
    final now = DateTime.now();
    return [
      Review(
        id: '${mosqueId}_r1',
        mosqueId: mosqueId,
        userName: 'Ahmed Khan',
        rating: 5.0,
        comment:
            'Beautiful mosque with peaceful atmosphere. The architecture is stunning '
            'and the facilities are top-notch.',
        createdAt: now.subtract(const Duration(days: 2)),
        likesCount: 24,
        isVerifiedUser: true,
        tags: ['family_friendly', 'clean'],
      ),
      Review(
        id: '${mosqueId}_r2',
        mosqueId: mosqueId,
        userName: 'Fatima Bi',
        rating: 4.0,
        comment:
            'Well-maintained mosque. Women\'s section is clean and spacious. '
            'My family loves coming here.',
        createdAt: now.subtract(const Duration(days: 5)),
        likesCount: 15,
        isVerifiedUser: false,
        tags: ['women_friendly'],
      ),
      Review(
        id: '${mosqueId}_r3',
        mosqueId: mosqueId,
        userName: 'Mohammed Ali',
        rating: 5.0,
        comment:
            'Imam gives excellent Friday sermons. Very knowledgeable and '
            'always addresses contemporary issues.',
        createdAt: now.subtract(const Duration(days: 7)),
        likesCount: 31,
        isVerifiedUser: true,
        tags: ['great_imam'],
      ),
    ];
  }

  // ── Public API ────────────────────────────────────────────

  /// Returns all 5 mosques.  Pagination is handled by the
  /// repository layer, not here.
  Future<List<Mosque>> getAllMosques() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<Mosque>.from(_allMosques);
  }

  /// Returns a single mosque by id.
  Future<Mosque> getMosqueDetail(String mosqueId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final match = _allMosques.where((m) => m.id == mosqueId).toList();
    if (match.isEmpty) {
      throw Exception('Mosque with id $mosqueId not found');
    }
    return match.first;
  }

  /// Returns reviews for a given mosque.
  Future<List<Review>> getMosqueReviews(
    String mosqueId, {
    int? page,
    int? limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final all = _reviewsByMosqueId[mosqueId] ?? [];
    final p = page ?? 1;
    final l = limit ?? all.length;
    final start = (p - 1) * l;
    final end = start + l;
    if (start >= all.length) return [];
    return all.sublist(start, end > all.length ? all.length : end);
  }
}