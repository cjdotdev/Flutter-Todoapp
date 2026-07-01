# Flutter Todo App

Application Flutter de gestion de tâches avec architecture offline-first, base de données locale Isar, synchronisation Firestore, gestion d'état Cubit et thème rose inspiré de Dribbble.

## Fonctionnalités

- Créer, compléter et supprimer des tâches
- Tâches groupées par date avec en-têtes de section ("Tâches - N", "Terminées - M")
- Vue détaillée en bottom sheet (titre, date, statut, description)
- Balayer vers la gauche pour supprimer avec animation `flutter_slidable`
- Animations d'entrée staggered (`flutter_staggered_animations`)
- Basculer thème clair/sombre via le bouton dans l'AppBar
- Thème rose avec polices Poppins (titres) et Inter (corps)
- Entièrement fonctionnel hors ligne
- Synchronisation Firebase Firestore en ligne
- Erreurs affichées en SnackBar flottante
- Validation en temps réel à la création (bouton désactivé tant que le titre est vide)

## Architecture

```
lib/
├── cubit/          # TaskCubit + TaskCubitState (sealed class via Equatable)
├── model/          # Entité Task (Isar @collection avec copyWith, props, dateFormatee)
├── repository/     # TaskRepository (interface abstraite) + 3 implémentations
│   ├── task_repository.dart          # Interface abstraite
│   ├── task_repository_impl.dart     # Implémentation locale Isar
│   ├── firestore_task_repository.dart # Implémentation distante Firestore
│   └── sync_task_repository.dart     # Wrapper de synchronisation local-first
├── screens/        # HomeScreen (BlocConsumer avec ListView groupée par date)
├── theme/          # AppColors, AppSizes, AppFonts, AppStyles, AppTheme (clair + sombre)
├── utils/          # Configuration DI GetIt (setupLocator)
└── widgets/        # TaskCard, AddTaskPopup, TaskDetailPopup, EmptyState
```

```
test/
├── repository/     # 10 tests — instance Isar en mémoire réelle
└── cubit/          # 10 tests — bloc_test + mocktail
```

### Flux de données

```
UI (BlocConsumer) → TaskCubit → SyncTaskRepository
                                   ├── TaskRepositoryImpl (Isar — toujours)
                                   └── FirestoreTaskRepository (si en ligne)
```

- **Gestion d'état :** flutter_bloc (Cubit via BlocProvider + BlocConsumer)
- **BD locale :** isar_community (offline-first, requêtes réactives par stream)
- **BD distante :** Cloud Firestore via `cloud_firestore`
- **Stratégie de synchronisation :** Écriture d'abord dans Isar (sûr hors ligne), puis Firestore si en ligne. Les erreurs Firestore sont silencieusement ignorées — ne bloquent jamais l'utilisateur.
- **DI :** get_it (toutes les dépendances injectées via le locator)
- **Comportement toggle :** `toggleStatus` supprime l'ancienne tâche et en crée une nouvelle (nouvel ID Isar). Firestore supprime l'ancien doc (par `isarId`) et enregistre le nouveau.

## Dépendances

| Package | Version | Rôle |
|---|---|---|
| `isar_community` | ^3.3.2 | Base de données locale embarquée |
| `isar_community_flutter_libs` | ^3.3.2 | Binaires natifs Isar |
| `firebase_core` | ^4.11.0 | Initialisation Firebase |
| `cloud_firestore` | ^6.6.0 | Base de données distante Firestore |
| `flutter_bloc` | ^9.1.1 | Gestion d'état (Cubit) |
| `get_it` | ^9.2.1 | Injection de dépendances |
| `connectivity_plus` | ^7.1.1 | Détection de connexion réseau |
| `flutter_slidable` | ^4.0.3 | Balayer pour supprimer |
| `flutter_staggered_animations` | ^1.1.1 | Animations d'entrée de liste |
| `equatable` | ^2.0.8 | Égalité value pour les états |
| `intl` | ^0.20.2 | Formatage de dates |
| `path_provider` | ^2.1.6 | Répertoire des documents de l'app |
| `logger` | ^2.7.0 | Journalisation structurée |

## Premiers pas

```bash
# Installer les dépendances
flutter pub get

# Générer le code Isar (nécessaire après modification du modèle)
dart run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

### Configuration Firebase

1. Ajoutez votre `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) au projet
2. Activez Firestore dans la console Firebase
3. L'application initialise Firebase dans `lib/main.dart` et se connecte automatiquement

### Exécuter les tests

```bash
# Lier la bibliothèque native Isar (nécessaire une fois)
ln -sf ~/.pub-cache/hosted/pub.dev/isar_community_flutter_libs-3.3.2/linux/libisar.so libisar.so

# Lancer tous les tests
flutter test
```

Le lien symbolique est nécessaire car Isar charge `libisar.so` via FFI au runtime. Les tests repository ouvrent une vraie instance Isar en mémoire ; les tests cubit utilisent des mocks mocktail.

## CI

GitHub Actions (`.github/workflows/tests.yml`) :

- Déclenché sur push/PR vers `main`
- Étapes : `pub get` → build_runner → `flutter analyze` → `flutter test`
- Les 20 tests doivent réussir pour que la CI valide

## Tests

| Suite | Nombre | Approche |
|---|---|---|
| Repository | 10 | Isar en mémoire réel, couvre save/delete/getById/watchAllTasks/toggleStatus avec chemins heureux + cas limites |
| Cubit | 10 | `bloc_test` + `mocktail`, couvre les 5 méthodes publiques avec chemins heureux + cas d'erreur |

## Thème

Toutes les constantes visuelles sont dans `lib/theme/` :

- **AppColors** — Rose accent (`#EC4899`), neutres, couleurs sémantiques (succès/erreur/avertissement)
- **AppSizes** — Échelle d'espacement (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48) + rayons + tailles d'icônes
- **AppFonts** — Poppins (titres) et Inter (corps) avec poids Regular/Medium/Bold
- **AppStyles** — Getters TextStyle préconstruits (headline, title, body, label) + padding commun
- **AppTheme** — `light` et `dark` ThemeData avec Material 3, couleur seed rose, thèmes personnalisés FAB/input/card

## Décisions de conception clés

- Utilisation du fork `isar_community` au lieu d'Isar officiel pour la compatibilité Dart 3.12
- Le modèle `Task` évite l'héritage `Equatable` (conflit avec le générateur Isar) ; `==`/`hashCode` manuels
- Les méthodes du Cubit (`saveTask`, `deleteTask`, etc.) n'émettent PAS en cas de succès — l'abonnement au stream `watchAllTasks` gère les mises à jour UI de manière réactive
- `SyncTaskRepository` écrit d'abord dans Isar, puis Firestore (sûr hors ligne) ; les erreurs Firestore sont silencieusement ignorées
- `FirestoreTaskRepository` utilise des ID de doc auto-générés + un champ `isarId` pour les recherches (découple l'ID Firestore de l'ID Isar)
- `toggleStatus` dans Isar utilise delete+put (nouvelle instance, nouvel ID) ; le repo sync gère le nettoyage Firestore
- Constructeurs privés (`AppColors._()`) empêchent l'instanciation des classes utilitaires
