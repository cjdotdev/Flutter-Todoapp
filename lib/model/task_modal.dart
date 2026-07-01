import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

part 'task_modal.g.dart';

/// ignore: must_be_immutable
@collection
class Task {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  bool isCompleted = false;
  late DateTime date;

  Task({
    required this.title,
    this.description,
    this.isCompleted = false,
  }) : date = DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
  }) {
    final result = Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
    if (date != null) result.date = date;
    return result;
  }

  @ignore
  List<Object?> get props => [id, title];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => Object.hash(id, title);

  @ignore
  String get dateFormatee => DateFormat('yyyy-MM-dd').format(date);
}
