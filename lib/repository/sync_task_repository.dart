import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/task_modal.dart';
import 'firestore_task_repository.dart';
import 'task_repository.dart';
import 'task_repository_impl.dart';

class SyncTaskRepository implements TaskRepository {
  final TaskRepositoryImpl _local;
  final FirestoreTaskRepository _remote;
  final Connectivity _connectivity;
  bool _synced = false;

  SyncTaskRepository(this._local, this._remote, this._connectivity);

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  @override
  Stream<List<Task>> watchAllTasks() {
    if (!_synced) {
      _synced = true;
      syncFromRemote();
    }
    return _local.watchAllTasks();
  }

  @override
  Future<Task?> getTaskById(int id) => _local.getTaskById(id);

  @override
  Future<int> saveTask(Task task) async {
    final id = await _local.saveTask(task);
    if (await _isOnline) {
      try {
        await _remote.saveTask(task);
      } catch (_) {}
    }
    return id;
  }

  @override
  Future<void> deleteTask(int id) async {
    await _local.deleteTask(id);
    if (await _isOnline) {
      try {
        await _remote.deleteTask(id);
      } catch (_) {}
    }
  }

  @override
  Future<int> toggleStatus(int id) async {
    final newId = await _local.toggleStatus(id);
    if (await _isOnline) {
      try {
        await _remote.deleteTask(id);
        final newTask = await _local.getTaskById(newId);
        if (newTask != null) {
          await _remote.saveTask(newTask);
        }
      } catch (_) {}
    }
    return newId;
  }

  Future<void> syncFromRemote() async {
    if (!(await _isOnline)) return;
    try {
      final remoteTasks = await _remote.watchAllTasks().first;
      for (final task in remoteTasks) {
        await _local.saveTask(task);
      }
    } catch (_) {}
  }
}
