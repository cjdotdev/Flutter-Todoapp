# Flutter Todo App

A Flutter todo application with offline-first architecture, local persistence via Isar, and state management with Cubit.

## Features

- Create, complete, and delete tasks
- Tasks grouped by date with section headers
- Detail view via bottom sheet
- Offline-first (Isar local database)
- Light/dark theme toggle
- Swipe-left to delete with animation
- Staggered list animations
- Pink accent theme with Poppins/Inter fonts

## Architecture

```
lib/
├── cubit/          # TaskCubit + TaskCubitState (sealed class)
├── model/          # Task entity (Isar @collection)
├── repository/     # TaskRepository (interface + Isar impl)
├── screens/        # HomeScreen (BlocConsumer)
├── theme/          # Colors, fonts, sizes, styles, light/dark themes
├── utils/          # GetIt DI setup (setupLocator)
└── widgets/        # TaskCard, AddTaskPopup, TaskDetailPopup, EmptyState
```

- **State management:** flutter_bloc (Cubit with BlocConsumer/BlocProvider)
- **Local DB:** isar_community (offline-first, stream-based queries)
- **DI:** get_it
- **Animations:** flutter_slidable, flutter_staggered_animations
- **Testing:** bloc_test, mocktail (cubit) + real Isar in-memory (repository)

## Getting Started

```bash
flutter pub get
flutter run
```

For tests (symlink required for Isar native library):

```bash
flutter test
```

## Firebase Sync

The repository interface (`TaskRepository`) is designed for dual-backend sync. An optional `FirestoreTaskRepository` + `SyncTaskRepository` wrapper can be added to sync local Isar data with Firestore.

## Tests

- **Repository tests:** 10 tests (real Isar in-memory)
- **Cubit tests:** 8 tests (bloc_test + mocktail)
