import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../cubit/cubit.dart';
import '../model/task_modal.dart';
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
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(locator<Isar>()),
  );
  locator.registerFactory<TaskCubit>(
    () => TaskCubit(locator<TaskRepository>()),
  );
}
