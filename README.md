# 🕌 Smart Mosque Finder

A production-level Flutter application to discover nearby mosques, view details on a map, manage favorites, and support multilingual UI with scalable architecture.

## ✨ Features

### Core Features
- **📍 Location + Distance Calculation** - Real-time distance using Haversine formula, sorted by nearest
- **🗺️ Google Maps Integration** - Markers with custom icons (verified vs normal), bottom sheet on tap
- **📋 Mosque Detail Screen** - Full details, reviews/ratings, directions, favorite toggle
- **❤️ Favorites + Persistence** - Local storage with Hive, reactive UI sync
- **🌐 Multilingual i18n** - English, Hindi, and Urdu using ARB files
- **🔧 API Layer + Repository Pattern** - Clean separation with Dio, offline-first strategy
- **⚡ State Management** - Riverpod with proper StateNotifier pattern
- **🔍 Search + Filter** - Debounced search, sort by distance/rating, verified filter
- **⚡ Performance** - Const widgets, efficient list rendering, pagination

### Bonus Features
- **📄 Pagination (Infinite Scroll)** - Scroll-based loading with page tracking
- **🌙 Dark Mode** - Full light/dark/system theme support
- **🔐 Mock JWT Authentication** - Token generation, login/register
- **💾 Caching (Offline Support)** - Hive-based offline storage with stale detection
- **🏆 Community Trusted Badge** - Trust score system with visual indicators

## 📸 Screenshots

*(Add screenshots here after building)*

## 🏗️ Architecture

```
lib/
├── core/                          # Shared infrastructure
│   ├── constants/                 # App & API constants
│   ├── errors/                    # AppException, Failure classes
│   ├── network/                   # ApiClient (Dio), NetworkInfo
│   ├── theme/                     # AppTheme, AppColors (light/dark)
│   ├── router/                    # GoRouter configuration
│   └── utils/                     # DistanceCalculator, Debouncer
│
├── data/                          # Data layer
│   ├── datasources/               # Remote (API) & Local (Hive) sources
│   ├── models/                    # JSON-serializable models
│   └── repositories/              # Repository implementations
│
├── domain/                        # Domain layer (Pure Dart)
│   ├── entities/                  # Business objects (Mosque, Review, User)
│   ├── repositories/              # Abstract repository interfaces
│   └── usecases/                  # Business logic use cases
│
└── features/                      # Feature modules
    ├── home/                      # Mosque list + map
    ├── mosque_detail/             # Full mosque details
    ├── favorites/                 # Saved mosques
    └── settings/                  # App configuration
```

### Architecture Principles
- **Clean Architecture** with 3 layers (data - domain - presentation)
- **Repository Pattern** for abstracted data access
- **Offline-first** strategy with local caching
- **Dependency Inversion** via abstract repositories
- **Riverpod** for reactive state management
- **GoRouter** for declarative navigation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/mosque_finder.git
cd mosque_finder

# Install dependencies
flutter pub get

# Run build_runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Setup
Copy `.env` file and configure your API keys:

```env
API_BASE_URL=https://api.mosquefinder.dev
GOOGLE_MAPS_API_KEY=your_key_here
```

## 📦 Dependencies

| Category | Package | Purpose |
|----------|---------|---------|
| State Management | `flutter_riverpod` | Reactive state management |
| Navigation | `go_router` | Declarative routing |
| Local Storage | `hive_flutter` | Fast NoSQL local storage |
| Preferences | `shared_preferences` | Key-value preferences |
| Maps | `google_maps_flutter` | Google Maps integration |
| Location | `geolocator` | Device location services |
| Maps Launch | `url_launcher` | Open directions in Google Maps |
| Networking | `dio` | HTTP client with interceptors |
| Connectivity | `connectivity_plus` | Network status detection |
| Images | `cached_network_image` | Image caching |
| Loading | `shimmer` | Loading skeletons |
| Rating | `flutter_rating_bar` | Rating display |
| Equality | `equatable` | Value equality |
| Functional | `dartz` | Either type for error handling |
| JSON | `json_annotation` | JSON serialization |
| Logger | `logger` | Debug logging |
| Env | `flutter_dotenv` | Environment variables |
| Permissions | `permission_handler` | Runtime permissions |
| JWT | `jwt_decoder` | Token decoding |

## 🧪 Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🗺️ Project Roadmap

- [ ] Real Google Maps integration
- [ ] Firebase push notifications
- [ ] Prayer time calculation
- [ ] Qibla direction finder
- [ ] Social features (community reviews)
- [ ] Admin dashboard for mosque management
- [ ] Web version with responsive design

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenStreetMap contributors
- All mosque communities providing data

---

**Built with ❤️ for the Muslim community 🌙**
