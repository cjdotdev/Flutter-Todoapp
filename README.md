# Flutter Todo App

A Flutter todo application with offline-first architecture, local persistence via Isar, Firebase Firestore sync, Cubit state management, and a pink-accented UI inspired by Dribbble.

## Features

- Create, complete, and delete tasks
- Tasks grouped by date with section headers ("Tasks - N", "Completed - M")
- Detail view via bottom sheet (title, date, status, description)
- Swipe-left to delete with `flutter_slidable` animation
- Staggered list entry animations (`flutter_staggered_animations`)
- Light/dark theme toggle via AppBar button
- Pink accent theme with Poppins (headings) and Inter (body) fonts
- Offline-first — fully functional without internet
- Firebase Firestore sync when online
- Error states shown as floating SnackBars
- Real-time validation on task creation (disabled save button until title is non-empty)

## Architecture

```
lib/
├── cubit/          # TaskCubit + TaskCubitState (sealed class via Equatable)
├── model/          # Task entity (Isar @collection with copyWith, props, dateFormatee)
├── repository/     # TaskRepository (abstract interface) + 3 implementations
│   ├── task_repository.dart          # Abstract interface
│   ├── task_repository_impl.dart     # Isar local implementation
│   ├── firestore_task_repository.dart # Firestore remote implementation
│   └── sync_task_repository.dart     # Local-first sync wrapper
├── screens/        # HomeScreen (BlocConsumer with date-grouped ListView)
├── theme/          # AppColors, AppSizes, AppFonts, AppStyles, AppTheme (light + dark)
├── utils/          # GetIt DI setup (setupLocator)
└── widgets/        # TaskCard, AddTaskPopup, TaskDetailPopup, EmptyState
```

```
test/
├── repository/     # 10 tests — real Isar in-memory instance
└── cubit/          # 10 tests — bloc_test + mocktail
```

### Data Flow

```
UI (BlocConsumer) → TaskCubit → SyncTaskRepository
                                   ├── TaskRepositoryImpl (Isar — always)
                                   └── FirestoreTaskRepository (if online)
```

- **State management:** flutter_bloc (Cubit via BlocProvider + BlocConsumer)
- **Local DB:** isar_community (offline-first, stream-based reactive queries)
- **Remote DB:** Cloud Firestore via `cloud_firestore`
- **Sync strategy:** Write to Isar first (offline-safe), then Firestore if online. Errors from Firestore are silently caught — never block the user.
- **DI:** get_it (all deps injected through locator)
- **Toggle behavior:** `toggleStatus` deletes the old task and creates a new one (new Isar ID). Firestore handles this by deleting the old doc (by `isarId` lookup) and saving the new one.

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `isar_community` | ^3.3.2 | Local embedded database |
| `isar_community_flutter_libs` | ^3.3.2 | Native Isar binaries |
| `firebase_core` | ^4.11.0 | Firebase initialization |
| `cloud_firestore` | ^6.6.0 | Remote Firestore database |
| `flutter_bloc` | ^9.1.1 | State management (Cubit) |
| `get_it` | ^9.2.1 | Dependency injection |
| `connectivity_plus` | ^7.1.1 | Network status detection |
| `flutter_slidable` | ^4.0.3 | Swipe-to-delete |
| `flutter_staggered_animations` | ^1.1.1 | List entry animations |
| `equatable` | ^2.0.8 | Value equality for states |
| `intl` | ^0.20.2 | Date formatting |
| `path_provider` | ^2.1.6 | App documents directory |
| `logger` | ^2.7.0 | Structured logging |

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate Isar code (required after model changes)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Firebase Setup

1. Add your `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) to the project
2. Enable Firestore in the Firebase Console
3. The app initializes Firebase in `lib/main.dart` and connects automatically

### Running Tests

```bash
# Symlink Isar native library (required once)
ln -sf ~/.pub-cache/hosted/pub.dev/isar_community_flutter_libs-3.3.2/linux/libisar.so libisar.so

# Run all tests
flutter test
```

The symlink is needed because Isar loads `libisar.so` via FFI at runtime. The repository tests open a real Isar in-memory instance; cubit tests use mocktail mocks.

## CI

GitHub Actions (`.github/workflows/tests.yml`):

- Triggered on push/PR to `main`
- Steps: `pub get` → build_runner → `flutter analyze` → `flutter test`
- All 20 tests must pass for CI to succeed

## Tests

| Suite | Count | Approach |
|---|---|---|
| Repository | 10 | Real Isar in-memory, covers save/delete/getById/watchAllTasks/toggleStatus with happy paths + edge cases |
| Cubit | 10 | `bloc_test` + `mocktail`, covers all 5 public methods with happy paths + error cases |

## Theme

All visual constants live in `lib/theme/`:

- **AppColors** — Pink accent (`#EC4899`), neutrals, semantic colors (success/error/warning)
- **AppSizes** — Spacing scale (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48) + radii + icon sizes
- **AppFonts** — Poppins (headings) and Inter (body) with Regular/Medium/Bold weights
- **AppStyles** — Pre-built TextStyle getters (headline, title, body, label) + common padding
- **AppTheme** — `light` and `dark` ThemeData with Material 3, pink seed color, custom FAB/input/card themes

## Key Design Decisions

- `isar_community` fork used instead of upstream Isar for Dart 3.12 compatibility
- `Task` model avoids `Equatable` inheritance (conflicts with Isar generator); manual `==`/`hashCode`
- Cubit methods (`saveTask`, `deleteTask`, etc.) do NOT emit on success — the `watchAllTasks` stream subscription handles UI updates reactively
- `SyncTaskRepository` writes to Isar first, then Firestore (offline-safe); Firestore errors are silently caught
- `FirestoreTaskRepository` uses auto-generated doc IDs + an `isarId` field for lookups (decouples Firestore doc ID from Isar ID)
- `toggleStatus` in Isar uses delete+put (new task instance, new ID); sync repo handles Firestore cleanup
- Private constructors (`AppColors._()`) prevent instantiation of utility classes
