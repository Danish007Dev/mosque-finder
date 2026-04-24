# Smart Mosque Finder

A production-grade Flutter application to discover nearby mosques, explore details on a map, manage favorites, and more -- all with a fully mock data layer (no live API needed).

[![Flutter 3.9.2](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart 3.9.2](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-7B1FA2)](https://riverpod.dev)
[![GoRouter](https://img.shields.io/badge/GoRouter-14.8.1-FF6F00)](https://pub.dev/packages/go_router)
[![Clean Architecture](https://img.shields.io/badge/Clean_Architecture-success)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![MIT License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Route Structure](#route-structure)
- [State Management](#state-management)
- [Data Flow](#data-flow)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)
- [Project Roadmap](#project-roadmap)
- [License](#license)

---

## Features

### Core Features

| Feature | Description |
|---------|-------------|
| Mosque Discovery | Browse mosques with distance calculation (Haversine formula) sorted by nearest |
| Google Maps View | Interactive map with color-coded markers (green = verified, orange = normal, blue = selected) and info windows |
| Mosque Details | Full detail screen with description, amenities, prayer time tags, and action buttons |
| Reviews & Ratings | Community reviews with star ratings, user names, tags, and like counts |
| Favorites | Save mosques locally with Hive for offline access, reactive UI sync |
| Search | Debounced search across name, address, city, and Arabic/Urdu names |
| Filters | Sort by distance/rating, filter by verified-only |
| Pagination | Infinite scroll (5 per page) + explicit "Load More" button when list fits on screen |
| Multilingual i18n | English, Hindi, and Urdu support with ARB localization files |
| Dark Mode | Light/Dark/System theme toggle with Material 3 theming |
| Community Trust Badges | Verified badges, community trust scores, visual trust indicators |

### Technical Highlights

| Feature | Implementation |
|---------|---------------|
| Architecture | Clean Architecture (3 layers: data - domain - presentation) |
| State Management | Riverpod with StateNotifier / StateNotifierProvider |
| Navigation | GoRouter with StatefulShellRoute.indexedStack for bottom nav |
| Data Layer | Fully mocked with 21 mosques across Delhi/NCR - no live API needed |
| Error Handling | dartz Either<Failure, T> pattern throughout repository layer |
| Local Storage | Hive for mosque caching, SharedPreferences for settings |
| Code Generation | json_serializable for models, riverpod_generator for providers |
| Location | Haversine-based distance calculation, default location (Delhi) |
| Maps | google_maps_flutter with BitmapDescriptor color-coded markers |
| Pagination | Both scroll-triggered (via NotificationListener) and button-triggered |

---

## Screenshots

<p align="center">
  <img src="screenshots/Screenshot%202026-04-24%20203958.png" width="180" alt="Screenshot 1">
  <img src="screenshots/Screenshot%202026-04-24%20204050.png" width="180" alt="Screenshot 2">
  <img src="screenshots/Screenshot%202026-04-24%20204107.png" width="180" alt="Screenshot 3">
  <img src="screenshots/Screenshot%202026-04-24%20204124.png" width="180" alt="Screenshot 4">
  <img src="screenshots/Screenshot%202026-04-24%20205735.png" width="180" alt="Screenshot 5">
</p>

---

## Architecture

The app follows **Clean Architecture** with three distinct layers, ensuring separation of concerns, testability, and maintainability.

```
┌──────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (Flutter Widgets, Pages, Providers, StateNotifiers)         │
│                                                              │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │  Pages       │  │  Providers   │  │  Widgets           │  │
│  │  (Screens)   │  │  (Riverpod)  │  │  (Reusable UI)     │  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬───────────┘  │
│         │                  │                    │              │
├─────────┼──────────────────┼────────────────────┼──────────────┤
│         ▼                  ▼                    ▼              │
│                     DOMAIN LAYER                              │
│  (Pure Dart - No Flutter dependencies)                        │
│                                                              │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │  Entities    │  │  Repositories│  │  Use Cases         │  │
│  │  (Mosque,    │  │  (Abstract   │  │  (Business Logic)  │  │
│  │   Review,    │  │   Interfaces)│  │                    │  │
│  │   User)      │  │              │  │                    │  │
│  └─────────────┘  └──────────────┘  └────────────────────┘  │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│                      DATA LAYER                               │
│  (Implementation, I/O, External Services)                    │
│                                                              │
│  ┌──────────────────┐  ┌───────────────┐  ┌──────────────┐  │
│  │  Data Sources     │  │  Models       │  │  Repositories │  │
│  │  ┌──────────────┐ │  │  (JSON        │  │  (Impl.)      │  │
│  │  │ Mock (21     │ │  │   Serializable│  │               │  │
│  │  │ mosques)     │ │  │   + .g.dart)  │  │               │  │
│  │  ├──────────────┤ │  │               │  │               │  │
│  │  │ Hive Local   │ │  │               │  │               │  │
│  │  │ (Cache)      │ │  │               │  │               │  │
│  │  └──────────────┘ │  │               │  │               │  │
│  └──────────────────┘  └───────────────┘  └──────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Layer Details

#### Data Layer (`lib/data/`)
- **Datasources:** `MosqueMockDataSource` (21 hardcoded mosques, 5 reviews each, 1s simulated latency), `MosqueLocalDataSource` (Hive caching for offline)
- **Models:** JSON-serializable classes with `json_serializable` + `json_annotation`
- **Repositories:** Concrete implementations that delegate to data sources, handle `Either<Failure, T>` error wrapping

#### Domain Layer (`lib/domain/`)
- **Entities:** Pure Dart objects (`Mosque`, `Review`, `User`) with `Equatable` for value equality
- **Repository Interfaces:** Abstract contracts that data layer implements, enabling DI and test mocks
- **Use Cases:** Business logic orchestrators (`GetMosques`, `GetMosqueDetail`, `SearchMosques`, `ToggleFavorite`)

#### Presentation Layer (`lib/features/`)
- **Pages:** Full-screen widgets for each feature (Home, MosqueDetail, Favorites, Settings)
- **Providers:** Riverpod `StateNotifier`/`StateNotifierProvider` for reactive state management
- **Widgets:** Reusable UI components (MosqueCard, MosqueMapWidget, SearchBar, FilterChips)

---

## Route Structure

Using **GoRouter** with `StatefulShellRoute.indexedStack` for persistent bottom navigation:

```
/                  ─── HomePage (Mosque List tab)     ← Bottom Nav
/map               ─── HomePage (Map tab)             ← Bottom Nav
/favorites         ─── FavoritesPage                  ← Bottom Nav
/settings          ─── SettingsPage                   ← Full screen (no bottom nav)
/mosque/:id        ─── MosqueDetailPage               ← Full screen (no bottom nav)
```

```dart
// Route configuration
StatefulShellRoute.indexedStack(
  branches: [
    StatefulShellBranch(routes: [GoRoute(path: '/', ...)]),        // List
    StatefulShellBranch(routes: [GoRoute(path: '/map', ...)]),     // Map
    StatefulShellBranch(routes: [GoRoute(path: '/favorites', ...)]),// Favs
  ],
)
// Full-screen routes (outside shell)
GoRoute(path: '/settings', ...)
GoRoute(path: '/mosque/:id', ...)
```

---

## State Management

The app uses **Riverpod** as its state management solution with the following provider hierarchy:

```
┌──────────────────────────────────────────────────────────┐
│                    Provider Hierarchy                     │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  mosqueRepositoryProvider (Provider)                     │
│    └─ Creates MosqueRepositoryProvider instance          │
│       └─ Wraps MosqueRepositoryImpl                     │
│          ├─ MosqueMockDataSource (21 mosques, cached)   │
│          └─ MosqueLocalDataSource (Hive cache)          │
│                                                          │
│  mosqueListProvider (StateNotifierProvider)              │
│    └─ MosqueListNotifier                                 │
│       ├─ loadMosques()   → Initial fetch (page 1)       │
│       ├─ loadNextPage()  → Pagination                   │
│       ├─ refresh()       → Pull-to-refresh              │
│       ├─ setSortBy()     → Change sort order            │
│       └─ toggleVerifiedOnly() → Filter toggle            │
│                                                          │
│  mosqueDetailProvider (FutureProvider.family)            │
│    └─ Fetches single mosque by ID                       │
│                                                          │
│  searchProvider (StateNotifierProvider)                  │
│    └─ SearchNotifier with debouncer                     │
│                                                          │
│  mapProvider (ChangeNotifierProvider)                    │
│    └─ MapNotifier with zoom, selected mosque            │
│                                                          │
│  favoritesProvider (StateNotifierProvider)               │
│    └─ FavoritesNotifier with Hive persistence           │
│                                                          │
│  settingsProvider (StateNotifierProvider)                │
│    └─ SettingsNotifier with SharedPreferences           │
│                                                          │
│  goRouterProvider (Provider)                             │
│    └─ Creates GoRouter instance                         │
│                                                          │
│  locationProvider (Provider)                             │
│    └─ UserLocation (default: Delhi, 28.7041, 77.1025)   │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Loading Mosques (with Pagination)

```
User opens app
      │
      ▼
HomePage.initState() → loadMosques(refresh: false)
      │
      ▼
MosqueListNotifier.loadMosques()
      │
      ├─ Sets state: isLoading=true, currentPage=1
      │
      ▼
MosqueRepositoryProvider.getMosques(page: 1, limit: 5)
      │
      ▼
MosqueRepositoryImpl.getMosques()
      │
      ├─ Calls mockDataSource.getMosques(page: 1)  ← 1s simulated delay
      │
      ├─ Calls localDataSource.cacheMosques()      ← Cache page 1
      │
      ▼
Returns Either<Failure, List<Mosque>>
      │
      ▼
MosqueRepositoryProvider wraps into {mosques, hasMore}
      │
      ▼
MosqueListNotifier updates state: mosques=[5 items], hasReachedEnd=false
      │
      ▼
UI rebuilds → shows 5 mosque cards + "Load More" button
      │
      ├─ User taps "Load More" → loadNextPage()
      │  └─ Fetches page 2, appends to list
      │
      └─ User scrolls to bottom → NotificationListener fires
         └─ loadNextPage() called automatically
```

### Search Flow

```
User types in search bar
      │
      ▼
SearchNotifier._debouncer (500ms delay)
      │
      ▼
loadMosques(refresh: true, searchQuery: "jama")
      │
      ▼
MosqueListNotifier.loadMosques()
      │
      ├─ Persists searchQuery in state
      │
      ▼
mockDataSource.getMosques(searchQuery: "jama")
      │
      ├─ Filters by name/address/city/nameAr containing "jama"
      │
      ▼
Returns filtered, sorted, paginated results
```

---

## Project Structure

```
lib/
├── main.dart                                  # App entry point, dotenv init
├── app.dart                                   # MaterialApp.router with Riverpod
│
├── core/                                      # Shared infrastructure
│   ├── constants/
│   │   ├── api_constants.dart                 # Endpoints, headers, cache keys
│   │   └── app_constants.dart                 # Pagination limit, default location
│   ├── errors/
│   │   ├── app_exception.dart                 # Custom exception hierarchy
│   │   └── failures.dart                      # Failure types (Server, Cache, Network)
│   ├── network/
│   │   ├── api_client.dart                    # Dio HTTP client (legacy, unused)
│   │   └── network_info.dart                  # Connectivity checker (legacy, unused)
│   ├── router/
│   │   ├── app_router.dart                    # GoRouter config + Shell + Error page
│   │   └── route_names.dart                   # Route name/path constants
│   ├── theme/
│   │   ├── app_colors.dart                    # Color palette (light + dark)
│   │   └── app_theme.dart                     # Material 3 themes
│   └── utils/
│       ├── debouncer.dart                     # Search debounce utility
│       └── distance_calculator.dart           # Haversine formula
│
├── data/                                      # Data layer
│   ├── datasources/
│   │   ├── mosque_mock_datasource.dart        # 21 hardcoded mosques, pagination, sorting
│   │   ├── mosque_local_datasource.dart       # Hive caching for offline
│   │   ├── mosque_remote_datasource.dart      # Live API (replaced by mock)
│   │   └── auth_local_datasource.dart         # Auth token storage
│   ├── models/
│   │   ├── mosque_model.dart + .g.dart        # JSON-serializable Mosque model
│   │   ├── review_model.dart + .g.dart        # JSON-serializable Review model
│   │   └── user_model.dart + .g.dart          # JSON-serializable User model
│   └── repositories/
│       ├── mosque_repository_impl.dart        # Concrete impl using mock datasource
│       ├── favorites_repository_impl.dart     # Favorites with Hive
│       └── auth_repository_impl.dart          # Auth with mock JWT
│
├── domain/                                    # Domain layer (pure Dart)
│   ├── entities/
│   │   ├── mosque.dart                        # Mosque entity with copyWith, Equatable
│   │   ├── review.dart                        # Review entity
│   │   └── user.dart                          # User entity
│   ├── repositories/
│   │   ├── mosque_repository.dart             # Abstract interface
│   │   ├── favorites_repository.dart          # Abstract interface
│   │   └── auth_repository.dart               # Abstract interface
│   └── usecases/                              # Business logic
│       ├── get_mosques.dart
│       ├── get_mosque_detail.dart
│       ├── search_mosques.dart
│       ├── get_favorites.dart
│       ├── toggle_favorite.dart
│       └── login.dart
│
└── features/                                  # Feature modules
    ├── home/                                  # Main screen
    │   └── presentation/
    │       ├── pages/home_page.dart           # TabBar (List/Map) + Search + Filters
    │       ├── providers/
    │       ├── providers/
    │       │   ├── mosque_list_provider.dart  # Pagination, search, sort, filter
    │       │   ├── map_provider.dart          # Zoom, selected mosque
    │       │   └── search_provider.dart       # Debounced search
    │       ├── repositories/
    │       │   └── mosque_repository_provider.dart  # Wrapper with hasMore
    │       └── widgets/
    │           ├── mosque_list.dart           # ListView + "Load More" button
    │           ├── mosque_card.dart           # Card with image, rating, distance
    │           ├── mosque_map_widget.dart     # GoogleMap with color markers
    │           ├── search_bar_widget.dart     # Search input with debounce
    │           └── filter_widget.dart         # Sort/filter chips
    │
    ├── mosque_detail/                         # Detail screen
    │   └── presentation/
    │       ├── pages/mosque_detail_page.dart  # Full detail with reviews
    │       ├── providers/mosque_detail_provider.dart  # Fetch single mosque
    │       └── widgets/
    │           ├── action_buttons.dart        # Directions, Share, Website
    │           ├── mosque_bottom_sheet.dart   # Bottom sheet on map tap
    │           ├── mosque_info_section.dart   # Info, amenities, description
    │           └── review_card.dart           # Individual review display
    │
    ├── favorites/                             # Saved mosques
    │   └── presentation/
    │       ├── pages/favorites_page.dart      # List of saved mosques
    │       └── providers/favorites_provider.dart  # Hive-backed persistence
    │
    └── settings/                              # App configuration
        └── presentation/
            ├── pages/settings_page.dart       # Theme, language, about
            ├── providers/
            │   ├── settings_provider.dart     # SharedPreferences
            │   └── locale_provider.dart       # Locale change logic
            └── widgets/
                └── language_selector.dart     # EN/HI/UR selector
```

> Note: files marked with * were modified during pagination/refactoring work

---

## Getting Started

### Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | `^3.9.2` |
| Dart SDK | `^3.9.2` |
| Android Studio / VS Code | Latest |
| Git | Any recent version |

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Danish007Dev/mosque-finder.git
cd mosque-finder

# 2. Install dependencies
flutter pub get

# 3. Run build_runner for code generation (models, providers)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run

# For a specific platform:
flutter run -d chrome     # Web
flutter run -d android    # Android
flutter run -d ios        # iOS (requires macOS + Xcode)
```

### Google Maps API Key

To use the interactive map, configure your Google Maps API key:

<details>
<summary><strong>Android</strong> — <code>android/app/src/main/AndroidManifest.xml</code></summary>

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```
</details>

<details>
<summary><strong>iOS</strong> — <code>ios/Runner/AppDelegate.swift</code></summary>

```swift
import GoogleMaps

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```
</details>

<details>
<summary><strong>Web</strong> — <code>web/index.html</code></summary>

```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY_HERE"></script>
```
</details>

<details>
<summary><strong>Environment File</strong> — <code>assets/.env</code></summary>

```env
API_BASE_URL=https://api.mosquefinder.dev
GOOGLE_MAPS_API_KEY=your_key_here
```
</details>

> **Note:** The app uses a **fully mock data source** with 21 hardcoded mosques. No live API key is required for the data layer. Google Maps only needs the API key for the map renderer.

---

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run a specific test file
flutter test test/widget_test.dart
```

---

## Dependencies

### State & Navigation

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.6.1 | Reactive state management |
| `riverpod_annotation` | ^2.6.1 | Code generation for providers |
| `go_router` | ^14.8.1 | Declarative routing with shell |

### UI & Maps

| Package | Version | Purpose |
|---------|---------|---------|
| `google_maps_flutter` | ^2.12.0 | Google Maps widget integration |
| `cached_network_image` | ^3.4.1 | Image caching & loading |
| `shimmer` | ^3.0.0 | Loading skeleton effects |
| `flutter_rating_bar` | ^4.0.1 | Star rating display |

### Storage & Preferences

| Package | Version | Purpose |
|---------|---------|---------|
| `hive_flutter` | ^1.1.0 | Fast NoSQL local DB (favorites, cache) |
| `hive` | ^2.2.3 | Hive core |
| `shared_preferences` | ^2.5.3 | Key-value preferences (settings) |
| `path_provider` | ^2.1.5 | File system paths |

### Location & Maps

| Package | Version | Purpose |
|---------|---------|---------|
| `geolocator` | ^13.0.2 | Device GPS location |
| `geocoding` | ^3.0.0 | Reverse geocoding |
| `url_launcher` | ^6.3.1 | Open directions in Google Maps app |

### Networking (Legacy — not used for mosque data)

| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | ^5.7.0 | HTTP client (replaced by mock) |
| `http` | ^1.3.0 | Simple HTTP (replaced by mock) |
| `connectivity_plus` | ^6.1.4 | Network status detection |

### Localization

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_localizations` | SDK | Material localization |
| `intl` | ^0.20.2 | i18n & pluralization |

### Utilities

| Package | Version | Purpose |
|---------|---------|---------|
| `equatable` | ^2.0.7 | Value equality for entities |
| `dartz` | ^0.10.1 | `Either` for error handling |
| `json_annotation` | ^4.9.0 | Model serialization annotations |
| `logger` | ^2.5.0 | Debug logging |
| `flutter_dotenv` | ^5.2.1 | Environment variables |
| `permission_handler` | ^11.3.1 | Runtime permissions |
| `jwt_decoder` | ^2.0.1 | Token decoding |
| `crypto` | ^3.0.6 | Hashing utilities |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.4.15 | Code generation runner |
| `json_serializable` | ^6.9.4 | JSON model generator |
| `riverpod_generator` | ^2.6.3 | Riverpod provider generator |
| `mockito` / `mocktail` | Latest | Unit testing mocks |
| `flutter_launcher_icons` | ^0.14.3 | App icon generation |

---

## Project Roadmap

- [x] Mock data layer (no live API dependency)
- [x] Mosque list with pagination
- [x] Google Maps integration with markers
- [x] Mosque detail screen with reviews
- [x] Favorites with Hive persistence
- [x] Dark mode & multilingual (EN/HI/UR)
- [ ] **Real Google Maps API key** (configure platform files)
- [ ] **Geolocator integration** (live GPS instead of default Delhi coords)
- [ ] Firebase push notifications
- [ ] Prayer time calculation
- [ ] Qibla direction finder
- [ ] Social features (community reviews)
- [ ] Admin dashboard for mosque management
- [ ] Web version with responsive design

---

## Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** the project
2. Create your feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit** your changes:
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. **Push** to the branch:
   ```bash
   git push origin feature/amazing-feature
   ```
5. Open a **Pull Request**

### Coding Standards

- Follow [Flutter's style guide](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` before committing
- Write tests for new features
- Keep Clean Architecture separation (domain layer must be pure Dart)

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Flutter team for the amazing framework
- Google Maps Flutter plugin
- All mosque communities providing data
- OpenStreetMap contributors


