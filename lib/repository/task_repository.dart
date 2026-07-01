import '../model/task_modal.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchAllTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(int id);
  Future<Task?> getTaskById(int id);
  Future<void> toggleStatus(int id);
}
