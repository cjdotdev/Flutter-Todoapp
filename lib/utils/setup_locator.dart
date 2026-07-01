import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../cubit/cubit.dart';
import '../model/task_modal.dart';
import '../repository/firestore_task_repository.dart';
import '../repository/sync_task_repository.dart';
import '../repository/task_repository.dart';
import '../repository/task_repository_impl.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TaskSchema],
    directory: dir.path,
  );

  locator.registerSingleton<Isar>(isar);
  locator.registerLazySingleton<TaskRepositoryImpl>(
    () => TaskRepositoryImpl(locator<Isar>()),
  );
  locator.registerLazySingleton<FirestoreTaskRepository>(
    () => FirestoreTaskRepository(FirebaseFirestore.instance),
  );
  locator.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );
  locator.registerLazySingleton<TaskRepository>(
    () => SyncTaskRepository(
      locator<TaskRepositoryImpl>(),
      locator<FirestoreTaskRepository>(),
      locator<Connectivity>(),
    ),
  );
  locator.registerFactory<TaskCubit>(
    () => TaskCubit(locator<TaskRepository>()),
  );
}
