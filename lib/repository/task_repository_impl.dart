import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';

import '../model/task_modal.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Isar _isar;
  final _log = Logger();

  TaskRepositoryImpl(this._isar);

  @override
  Stream<List<Task>> watchAllTasks() {
    return _isar.tasks
        .where()
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => _isar.tasks.where().findAll());
  }

  @override
  Future<int> saveTask(Task task) async {
    try {
      if (task.title.trim().isEmpty) {
        throw ArgumentError('Le titre est obligatoire');
      }
      return await _isar.writeTxn<int>(() async {
        final id = await _isar.tasks.put(task);
        task.id = id;
        return id;
      });
    } catch (e, stack) {
      _log.e('saveTask failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.tasks.delete(id);
      });
    } catch (e, stack) {
      _log.e('deleteTask failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      return await _isar.tasks.get(id);
    } catch (e, stack) {
      _log.e('getTaskById failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<int> toggleStatus(int id) async {
    try {
      return await _isar.writeTxn<int>(() async {
        final task = await _isar.tasks.get(id);
        if (task == null) return id;
        final updated = task.copyWith(isCompleted: !task.isCompleted);
        await _isar.tasks.delete(id);
        final newId = await _isar.tasks.put(updated);
        return newId;
      });
    } catch (e, stack) {
      _log.e('toggleStatus failed', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
