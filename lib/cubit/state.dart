import 'package:equatable/equatable.dart';

import '../model/task_modal.dart';

sealed class TaskCubitState extends Equatable {
  const TaskCubitState();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskCubitState {
  const TaskLoading();
}

class TaskMainState extends TaskCubitState {
  final List<Task> tasks;

  const TaskMainState({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

class TaskFailureState extends TaskCubitState {
  final String message;

  const TaskFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
