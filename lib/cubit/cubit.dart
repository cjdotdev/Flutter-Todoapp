import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/task_modal.dart';
import '../repository/task_repository.dart';
import 'state.dart';

class TaskCubit extends Cubit<TaskCubitState> {
  final TaskRepository _repository;
  StreamSubscription<List<Task>>? _subscription;

  TaskCubit(this._repository) : super(const TaskLoading());

  void watchAllTasks() {
    emit(const TaskLoading());
    _subscription?.cancel();
    _subscription = _repository.watchAllTasks().listen(
      (tasks) => emit(TaskMainState(tasks: tasks)),
      onError: (e) => emit(TaskFailureState(message: e.toString())),
    );
  }

  Future<void> saveTask(Task task) async {
    try {
      await _repository.saveTask(task);
    } catch (e) {
      emit(TaskFailureState(message: e.toString()));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id);
    } catch (e) {
      emit(TaskFailureState(message: e.toString()));
    }
  }

  Future<void> getTaskById(int id) async {
    try {
      await _repository.getTaskById(id);
    } catch (e) {
      emit(TaskFailureState(message: e.toString()));
    }
  }

  Future<void> toggleStatus(int id) async {
    try {
      await _repository.toggleStatus(id);
    } catch (e) {
      emit(TaskFailureState(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
