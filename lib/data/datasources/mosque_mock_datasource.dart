import '../../core/utils/distance_calculator.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/entities/review.dart';

/// ----------------------------------------------------------
/// Mock data source that replaces all remote API calls.
/// Uses a hardcoded list of 20 mosques across Delhi/NCR with
/// varying GPS coordinates, ratings, and verification status.
///
/// Pagination is simulated at the request level (5 items per
/// page). A 1-second Future.delayed simulates network latency.
/// ----------------------------------------------------------
class MosqueMockDataSource {
  static const int itemsPerPage = 5;

  // ── Hardcoded mosque catalogue ─────────────────────────────────
  static final List<Mosque> _allMosques = [
    const Mosque(
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
          'One of the largest mosques in India, built by Mughal Emperor Shah Jahan '
          'between 1650 and 1656. Features three great gates, four towers, and two 40 m '
          'high minarets. Can accommodate 25,000 worshippers.',
      openingHours: '5:00 AM – 10:00 PM',
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
          'Famous Sufi shrine and mosque complex built in 1325. The dargah is '
          'visited by people of all faiths. Qawwali performances every Thursday evening.',
      openingHours: '5:00 AM – 10:00 PM',
    ),
    const Mosque(
      id: '3',
      name: 'Al-Hilal Mosque',
      nameAr: 'مسجد الهلال',
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
      description:
          'Community mosque with modern facilities in South Delhi. '
          'Fully air-conditioned prayer halls and dedicated women\'s section.',
      openingHours: '4:30 AM – 11:00 PM',
    ),
    const Mosque(
      id: '4',
      name: 'Masjid Rahman',
      nameAr: 'مسجد الرحمن',
      nameUr: 'مسجد رحمان',
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
      description: 'Small neighborhood mosque serving the local community.',
      openingHours: '5:00 AM – 9:00 PM',
    ),
    const Mosque(
      id: '5',
      name: 'Faisal Mosque',
      nameAr: 'مسجد فيصل',
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
          'Large mosque known for its beautiful architecture and community programs. '
          'Features an Islamic library and a café.',
      openingHours: '4:00 AM – 11:30 PM',
    ),
    const Mosque(
      id: '6',
      name: 'Madina Masjid',
      nameUr: 'مدینہ مسجد',
      latitude: 28.6234,
      longitude: 77.2109,
      address: 'Shaheen Bagh, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800',
      rating: 4.0,
      reviewCount: 723,
      isVerified: false,
      isCommunityTrusted: true,
      communityTrustScore: 72,
      amenities: ['wudu_area', 'parking', 'women_section'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Active community mosque with daily Quran classes for children.',
      openingHours: '5:00 AM – 10:00 PM',
    ),
    const Mosque(
      id: '7',
      name: 'Iqbal Masjid',
      nameUr: 'اقبال مسجد',
      latitude: 28.6456,
      longitude: 77.2211,
      address: 'Safdarjung Enclave, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4?w=800',
      rating: 4.2,
      reviewCount: 634,
      isVerified: true,
      isCommunityTrusted: false,
      communityTrustScore: 48,
      amenities: ['wudu_area', 'parking', 'air_conditioned'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
      description: 'Modern mosque with air-conditioned prayer halls.',
      openingHours: '4:30 AM – 10:30 PM',
    ),
    const Mosque(
      id: '8',
      name: 'Noor Masjid',
      nameAr: 'مسجد النور',
      latitude: 28.6300,
      longitude: 77.2150,
      address: 'Hauz Khas, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1547586696-ea22b4d4235d?w=800',
      rating: 4.4,
      reviewCount: 1234,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 85,
      amenities: ['wudu_area', 'parking', 'women_section', 'library', 'cafe'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid'],
      description:
          'Prominent mosque in Hauz Khas with excellent facilities and '
          'a vibrant youth program.',
      openingHours: '4:30 AM – 11:00 PM',
    ),
    const Mosque(
      id: '9',
      name: 'Masjid Al-Falah',
      nameAr: 'مسجد الفلاح',
      latitude: 28.5555,
      longitude: 77.2700,
      address: 'Greater Kailash, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      phone: '+91-11-29234567',
      imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800',
      rating: 4.3,
      reviewCount: 987,
      isVerified: true,
      isCommunityTrusted: false,
      communityTrustScore: 55,
      amenities: ['wudu_area', 'parking'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Well-maintained mosque in the heart of South Delhi commercial area.',
      openingHours: '5:00 AM – 10:00 PM',
    ),
    const Mosque(
      id: '10',
      name: 'Tablighi Markaz Masjid',
      nameUr: 'تبلیغی مرکز مسجد',
      latitude: 28.5861,
      longitude: 77.2535,
      address: 'Nizamuddin, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1589745457396-2e2c0a7f9322?w=800',
      rating: 4.0,
      reviewCount: 543,
      isVerified: false,
      isCommunityTrusted: true,
      communityTrustScore: 68,
      amenities: ['wudu_area', 'parking'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Central markaz of the Tablighi Jamaat in India.',
      openingHours: 'Open 24 hours',
    ),
    const Mosque(
      id: '11',
      name: 'Masjid-e-Quba',
      nameAr: 'مسجد قباء',
      latitude: 28.6100,
      longitude: 77.2800,
      address: 'Noida Sector 15, UP',
      city: 'Noida',
      state: 'Uttar Pradesh',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=800',
      rating: 4.2,
      reviewCount: 765,
      isVerified: true,
      isCommunityTrusted: false,
      communityTrustScore: 50,
      amenities: ['wudu_area', 'parking', 'women_section'],
      prayerTimeTags: ['5_times', 'jumuah', 'eid'],
      description: 'Named after the first mosque in Islam. Serves the Noida community.',
      openingHours: '4:30 AM – 10:30 PM',
    ),
    const Mosque(
      id: '12',
      name: 'Char Minar Masjid',
      latitude: 28.6400,
      longitude: 77.2550,
      address: 'Karol Bagh, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4?w=800',
      rating: 3.9,
      reviewCount: 321,
      isVerified: false,
      isCommunityTrusted: false,
      communityTrustScore: 30,
      amenities: ['wudu_area'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Local mosque in the bustling Karol Bagh market area.',
      openingHours: '5:00 AM – 9:00 PM',
    ),
    const Mosque(
      id: '13',
      name: 'Masjid An-Noor',
      nameAr: 'مسجد النور',
      latitude: 28.5900,
      longitude: 77.3100,
      address: 'Mayur Vihar Phase 1, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1547586696-ea22b4d4235d?w=800',
      rating: 4.5,
      reviewCount: 1456,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 87,
      amenities: ['wudu_area', 'parking', 'women_section', 'air_conditioned'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
      description:
          'Large mosque serving the East Delhi community with excellent facilities.',
      openingHours: '4:00 AM – 11:00 PM',
    ),
    const Mosque(
      id: '14',
      name: 'Gurgaon Central Mosque',
      latitude: 28.4595,
      longitude: 77.0266,
      address: 'Sector 14, Gurgaon',
      city: 'Gurgaon',
      state: 'Haryana',
      country: 'India',
      phone: '+91-124-4081234',
      imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800',
      rating: 4.3,
      reviewCount: 1098,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 82,
      amenities: ['wudu_area', 'parking', 'women_section', 'library'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid'],
      description:
          'Central mosque for the Gurgaon Muslim community. '
          'Well-connected and spacious.',
      openingHours: '4:30 AM – 10:30 PM',
    ),
    const Mosque(
      id: '15',
      name: 'Faridabad Jami Masjid',
      latitude: 28.4112,
      longitude: 77.3140,
      address: 'Sector 16, Faridabad',
      city: 'Faridabad',
      state: 'Haryana',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1589745457396-2e2c0a7f9322?w=800',
      rating: 3.7,
      reviewCount: 289,
      isVerified: false,
      isCommunityTrusted: false,
      communityTrustScore: 22,
      amenities: ['wudu_area'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Community mosque in the industrial city of Faridabad.',
      openingHours: '5:00 AM – 9:00 PM',
    ),
    const Mosque(
      id: '16',
      name: 'Masjid Al-Rahim',
      nameAr: 'مسجد الرحيم',
      latitude: 28.6800,
      longitude: 77.1900,
      address: 'Pitampura, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800',
      rating: 4.0,
      reviewCount: 567,
      isVerified: true,
      isCommunityTrusted: false,
      communityTrustScore: 42,
      amenities: ['wudu_area', 'parking', 'air_conditioned'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Serves the North-West Delhi community.',
      openingHours: '4:30 AM – 10:00 PM',
    ),
    const Mosque(
      id: '17',
      name: 'Ghaziabad Shahi Masjid',
      latitude: 28.6692,
      longitude: 77.4538,
      address: 'Shahibaug, Ghaziabad',
      city: 'Ghaziabad',
      state: 'Uttar Pradesh',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=800',
      rating: 4.1,
      reviewCount: 678,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 75,
      amenities: ['wudu_area', 'parking', 'women_section'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh'],
      description: 'Historical mosque in Ghaziabad with a strong community base.',
      openingHours: '4:30 AM – 10:30 PM',
    ),
    const Mosque(
      id: '18',
      name: 'Khari Baoli Masjid',
      latitude: 28.6530,
      longitude: 77.2280,
      address: 'Khari Baoli, Old Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1578898887932-dce23a595ad4?w=800',
      rating: 3.6,
      reviewCount: 198,
      isVerified: false,
      isCommunityTrusted: false,
      communityTrustScore: 18,
      amenities: ['wudu_area'],
      prayerTimeTags: ['5_times'],
      description:
          'Small mosque in the spice market area of Old Delhi. '
          'Convenient for traders and visitors.',
      openingHours: '5:00 AM – 9:00 PM',
    ),
    const Mosque(
      id: '19',
      name: 'Dwarka Masjid-e-Umar',
      nameUr: 'دوارکا مسجد عمر',
      latitude: 28.5726,
      longitude: 77.0353,
      address: 'Sector 10, Dwarka, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1547586696-ea22b4d4235d?w=800',
      rating: 4.6,
      reviewCount: 1876,
      isVerified: true,
      isCommunityTrusted: true,
      communityTrustScore: 91,
      amenities: ['wudu_area', 'parking', 'women_section', 'library', 'cafe'],
      prayerTimeTags: ['5_times', 'jumuah', 'taraweeh', 'eid', 'classes'],
      description:
          'Modern mosque in Dwarka with excellent facilities, '
          'Islamic school, and community centre.',
      openingHours: '4:00 AM – 11:30 PM',
    ),
    const Mosque(
      id: '20',
      name: 'Shah Alam Dargah Masjid',
      latitude: 28.5500,
      longitude: 77.3000,
      address: 'Okhla, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1589745457396-2e2c0a7f9322?w=800',
      rating: 3.9,
      reviewCount: 432,
      isVerified: false,
      isCommunityTrusted: true,
      communityTrustScore: 62,
      amenities: ['wudu_area', 'parking'],
      prayerTimeTags: ['5_times', 'jumuah'],
      description: 'Serves the Okhla industrial area community.',
      openingHours: '5:00 AM – 10:00 PM',
    ),
    const Mosque(
      id: '21',
      name: 'Badi Masjid Bhiwandi',
      latitude: 28.5200,
      longitude: 77.2200,
      address: 'Sangam Vihar, New Delhi',
      city: 'Delhi',
      state: 'Delhi',
      country: 'India',
      imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800',
      rating: 3.5,
      reviewCount: 189,
      isVerified: false,
      isCommunityTrusted: false,
      communityTrustScore: 20,
      amenities: ['wudu_area'],
      prayerTimeTags: ['5_times'],
      description: 'Local mosque serving the Sangam Vihar community.',
      openingHours: '5:00 AM – 9:00 PM',
    ),
  ];

  // ── Mock reviews for each mosque ───────────────────────────────
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
      Review(
        id: '${mosqueId}_r4',
        mosqueId: mosqueId,
        userName: 'Sana Rahman',
        rating: 3.5,
        comment:
            'Good mosque overall but parking can be difficult during Friday prayers. '
            'Arrive early to find a spot.',
        createdAt: now.subtract(const Duration(days: 12)),
        likesCount: 8,
        isVerifiedUser: false,
        tags: ['parking_issues'],
      ),
      Review(
        id: '${mosqueId}_r5',
        mosqueId: mosqueId,
        userName: 'Yusuf Patel',
        rating: 4.5,
        comment:
            'Excellent community programs and Quran classes for children. '
            'Very welcoming environment.',
        createdAt: now.subtract(const Duration(days: 3)),
        likesCount: 19,
        isVerifiedUser: true,
        tags: ['great_programs', 'family_friendly'],
      ),
    ];
  }

  // ── Public API (mirrors the old MosqueRemoteDataSource) ────────

  /// Fetch paginated mosques near a location.
  ///
  /// * Applies sorting, search, and verified-filter.
  /// * Computes distance from [latitude]/[longitude].
  /// * Returns **[itemsPerPage]** items per page.
  Future<List<Mosque>> getMosques({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? page,
    int? limit,
    String? searchQuery,
    bool? verifiedOnly,
    String? sortBy,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));

    // Start with all mosques
    List<Mosque> results = List<Mosque>.from(_allMosques);

    // ── Filtering ────────────────────────────────────────────
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      results = results.where((m) {
        return m.name.toLowerCase().contains(q) ||
            (m.address?.toLowerCase().contains(q) ?? false) ||
            (m.city?.toLowerCase().contains(q) ?? false) ||
            (m.nameAr?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    if (verifiedOnly == true) {
      results = results.where((m) => m.isVerified).toList();
    }

    // ── Compute distance ─────────────────────────────────────
    results = results.map((m) {
      final dist = DistanceCalculator.calculateDistance(
        lat1: latitude,
        lng1: longitude,
        lat2: m.latitude,
        lng2: m.longitude,
      );
      // Filter by radius if specified
      if (radiusKm != null && dist > radiusKm) return null;
      return m.copyWith(distanceKm: dist);
    }).whereType<Mosque>().toList();

    // ── Sorting ──────────────────────────────────────────────
    switch (sortBy) {
      case 'rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'reviews':
        results.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'distance':
      default:
        results.sort((a, b) =>
            (a.distanceKm ?? double.infinity)
                .compareTo(b.distanceKm ?? double.infinity));
        break;
    }

    // ── Pagination ───────────────────────────────────────────
    final p = page ?? 1;
    final l = limit ?? itemsPerPage;
    final start = (p - 1) * l;
    final end = start + l;

    if (start >= results.length) return [];
    return results.sublist(start, end > results.length ? results.length : end);
  }

  /// Fetch full detail for a single mosque.
  Future<Mosque> getMosqueDetail(String mosqueId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final match = _allMosques.where((m) => m.id == mosqueId).toList();
    if (match.isEmpty) {
      throw Exception('Mosque with id $mosqueId not found');
    }
    return match.first;
  }

  /// Fetch reviews for a mosque.
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

  /// Search mosques by query (delegates to getMosques).
  Future<List<Mosque>> searchMosques({
    required String query,
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    return getMosques(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      searchQuery: query,
    );
  }
}