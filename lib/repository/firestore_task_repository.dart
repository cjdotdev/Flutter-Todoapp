import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../model/task_modal.dart';
import 'task_repository.dart';

class FirestoreTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore;
  final _log = Logger();
  static const _collection = 'tasks';

  FirestoreTaskRepository(this._firestore);

  @override
  Stream<List<Task>> watchAllTasks() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => _fromDoc(doc)).toList(),
        );
  }

  @override
  Future<int> saveTask(Task task) async {
    try {
      if (task.title.trim().isEmpty) {
        throw ArgumentError('Le titre est obligatoire');
      }
      final data = _toMap(task);
      final docRef = await _firestore.collection(_collection).add(data);
      return int.tryParse(docRef.id) ?? task.id;
    } catch (e, stack) {
      _log.e('saveTask failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      final query =
          await _firestore
              .collection(_collection)
              .where('isarId', isEqualTo: id)
              .get();
      for (final doc in query.docs) {
        await doc.reference.delete();
      }
    } catch (e, stack) {
      _log.e('deleteTask failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      final query =
          await _firestore
              .collection(_collection)
              .where('isarId', isEqualTo: id)
              .get();
      return query.docs.isNotEmpty ? _fromDoc(query.docs.first) : null;
    } catch (e, stack) {
      _log.e('getTaskById failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<int> toggleStatus(int id) async {
    try {
      final query =
          await _firestore
              .collection(_collection)
              .where('isarId', isEqualTo: id)
              .get();
      if (query.docs.isNotEmpty) {
        final current = query.docs.first.data()['isCompleted'] as bool;
        await query.docs.first.reference.update({'isCompleted': !current});
      }
      return id;
    } catch (e, stack) {
      _log.e('toggleStatus failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Map<String, dynamic> _toMap(Task task) {
    return {
      'isarId': task.id,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
      'date': Timestamp.fromDate(task.date),
    };
  }

  Task _fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final task = Task(
      title: data['title'] as String,
      description: data['description'] as String?,
      isCompleted: data['isCompleted'] as bool? ?? false,
    );
    task.id = data['isarId'] as int? ?? 0;
    if (data['date'] is Timestamp) {
      task.date = (data['date'] as Timestamp).toDate();
    }
    return task;
  }
}
