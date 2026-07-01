import '../model/task_modal.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchAllTasks();
  Future<int> saveTask(Task task);
  Future<void> deleteTask(int id);
  Future<Task?> getTaskById(int id);
  Future<int> toggleStatus(int id);
}
