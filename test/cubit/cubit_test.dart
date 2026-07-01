import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hosto/cubit/cubit.dart';
import 'package:hosto/cubit/state.dart';
import 'package:hosto/model/task_modal.dart';
import 'package:hosto/repository/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(Task(title: 'fallback'));
  });

  setUp(() {
    mockRepo = MockTaskRepository();
  });

  group('TaskCubit', () {
    group('watchAllTasks', () {
      late StreamController<List<Task>> controller;

      blocTest<TaskCubit, TaskCubitState>(
        'happy path — emits loading then main state with tasks',
        setUp: () {
          controller = StreamController<List<Task>>();
        },
        build: () {
          when(() => mockRepo.watchAllTasks()).thenAnswer((_) => controller.stream);
          return TaskCubit(mockRepo);
        },
        act: (cubit) {
          cubit.watchAllTasks();
          controller.add([Task(title: 'Faire les courses')]);
        },
        tearDown: () => controller.close(),
        wait: const Duration(milliseconds: 50),
        expect: () => [
          const TaskLoading(),
          isA<TaskMainState>().having(
            (s) => s.tasks.length,
            'length',
            1,
          ),
        ],
      );

      blocTest<TaskCubit, TaskCubitState>(
        'edge case — emits failure on stream error',
        setUp: () {
          controller = StreamController<List<Task>>();
        },
        build: () {
          when(() => mockRepo.watchAllTasks()).thenAnswer((_) => controller.stream);
          return TaskCubit(mockRepo);
        },
        act: (cubit) {
          cubit.watchAllTasks();
          controller.addError('Erreur test');
        },
        tearDown: () => controller.close(),
        wait: const Duration(milliseconds: 50),
        expect: () => [
          const TaskLoading(),
          isA<TaskFailureState>().having(
            (s) => s.message,
            'message',
            'Erreur test',
          ),
        ],
      );
    });

    group('saveTask', () {
      blocTest<TaskCubit, TaskCubitState>(
        'happy path — calls repo saveTask',
        build: () {
          when(() => mockRepo.saveTask(any())).thenAnswer((_) async {});
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.saveTask(Task(title: 'Test')),
        expect: () => [],
        verify: (_) {
          verify(() => mockRepo.saveTask(any())).called(1);
        },
      );

      blocTest<TaskCubit, TaskCubitState>(
        'edge case — emits failure when repo throws',
        build: () {
          when(() => mockRepo.saveTask(any())).thenThrow(Exception('DB down'));
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.saveTask(Task(title: 'Test')),
        expect: () => [
          isA<TaskFailureState>().having(
            (s) => s.message,
            'message',
            contains('DB down'),
          ),
        ],
      );
    });

    group('deleteTask', () {
      blocTest<TaskCubit, TaskCubitState>(
        'happy path — calls repo deleteTask',
        build: () {
          when(() => mockRepo.deleteTask(any())).thenAnswer((_) async {});
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.deleteTask(1),
        expect: () => [],
        verify: (_) {
          verify(() => mockRepo.deleteTask(1)).called(1);
        },
      );

      blocTest<TaskCubit, TaskCubitState>(
        'edge case — emits failure when repo throws',
        build: () {
          when(() => mockRepo.deleteTask(any())).thenThrow(Exception('Not found'));
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.deleteTask(42),
        expect: () => [
          isA<TaskFailureState>().having(
            (s) => s.message,
            'message',
            contains('Not found'),
          ),
        ],
      );
    });

    group('toggleStatus', () {
      blocTest<TaskCubit, TaskCubitState>(
        'happy path — calls repo toggleStatus',
        build: () {
          when(() => mockRepo.toggleStatus(any())).thenAnswer((_) async {});
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.toggleStatus(1),
        expect: () => [],
        verify: (_) {
          verify(() => mockRepo.toggleStatus(1)).called(1);
        },
      );

      blocTest<TaskCubit, TaskCubitState>(
        'edge case — emits failure when repo throws',
        build: () {
          when(() => mockRepo.toggleStatus(any())).thenThrow(Exception('Fail'));
          return TaskCubit(mockRepo);
        },
        act: (cubit) => cubit.toggleStatus(99),
        expect: () => [
          isA<TaskFailureState>().having(
            (s) => s.message,
            'message',
            contains('Fail'),
          ),
        ],
      );
    });
  });
}
