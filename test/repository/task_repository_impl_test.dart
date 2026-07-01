import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:hosto/model/task_modal.dart';
import 'package:hosto/repository/task_repository.dart';
import 'package:hosto/repository/task_repository_impl.dart';
import 'package:hosto/utils/setup_locator.dart';

void main() {
  late Isar isar;
  late TaskRepository repository;

  setUp(() async {
    final dir = await Directory.systemTemp.createTemp('isar_test');
    isar = await Isar.open(
      [TaskSchema],
      directory: dir.path,
    );
    locator.registerSingleton<Isar>(isar);
    repository = TaskRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close();
    await locator.reset();
  });

  group('TaskRepositoryImpl', () {
    group('saveTask', () {
      test('happy path — saves task and persists it', () async {
        final task = Task(title: 'Acheter du lait');

        await repository.saveTask(task);

        final saved = await repository.getTaskById(task.id);
        expect(saved, isNotNull);
        expect(saved!.title, 'Acheter du lait');
        expect(saved.isCompleted, false);
      });

      test('edge case — throws ArgumentError for empty title', () async {
        final task = Task(title: '');

        expect(
          () => repository.saveTask(task),
          throwsArgumentError,
        );
      });
    });

    group('deleteTask', () {
      test('happy path — deletes task and removes it from DB', () async {
        final task = Task(title: 'Faire le ménage');
        await repository.saveTask(task);

        await repository.deleteTask(task.id);

        final deleted = await repository.getTaskById(task.id);
        expect(deleted, isNull);
      });

      test('edge case — deleting non-existent id does not throw', () async {
        await expectLater(
          repository.deleteTask(99999),
          completes,
        );
      });
    });

    group('getTaskById', () {
      test('happy path — returns the matching task', () async {
        final task = Task(title: 'Lire un livre');
        await repository.saveTask(task);

        final result = await repository.getTaskById(task.id);

        expect(result, isNotNull);
        expect(result!.title, 'Lire un livre');
      });

      test('edge case — returns null for unknown id', () async {
        final result = await repository.getTaskById(99999);

        expect(result, isNull);
      });
    });

    group('watchAllTasks', () {
      test('happy path — stream emits tasks when added to DB', () async {
        final stream = repository.watchAllTasks();

        final future = expectLater(
          stream,
          emitsInOrder([
            predicate<List<Task>>((tasks) => tasks.isEmpty),
            predicate<List<Task>>((tasks) => tasks.length == 1),
            predicate<List<Task>>((tasks) => tasks.length == 2),
          ]),
        );

        await repository.saveTask(Task(title: 'Faire les courses'));
        await repository.saveTask(Task(title: 'Apprendre Dart'));

        await future;
      });

      test('edge case — stream does not emit on failed save', () async {
        final stream = repository.watchAllTasks();

        final future = expectLater(
          stream,
          emitsInOrder([
            predicate<List<Task>>((tasks) => tasks.isEmpty),
            predicate<List<Task>>((tasks) => tasks.length == 1),
          ]),
        );

        try {
          await repository.saveTask(Task(title: ''));
        } catch (_) {}

        await repository.saveTask(Task(title: 'Tâche valide'));

        await future;
      });
    });

    group('toggleStatus', () {
      test('happy path — creates new task with toggled status', () async {
        final task = Task(title: 'Apprendre Flutter');
        await repository.saveTask(task);
        final originalId = task.id;

        final newId = await repository.toggleStatus(originalId);

        final oldTask = await repository.getTaskById(originalId);
        expect(oldTask, isNull);

        final all = await isar.tasks.where().findAll();
        expect(all.length, 1);
        expect(all.first.title, 'Apprendre Flutter');
        expect(all.first.isCompleted, true);
        expect(all.first.id, newId);
        expect(newId, isNot(originalId));
      });

      test('edge case — toggling non-existent id does not throw', () async {
        await expectLater(
          repository.toggleStatus(99999),
          completes,
        );
      });
    });
  });
}
