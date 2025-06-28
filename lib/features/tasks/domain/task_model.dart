import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
/// its User model for authentication
class TaskModel {
  /// first field for the hive/table is uid
  @HiveField(0)
  final int? tid;

  /// second non required field
  @HiveField(1)
  final String? title;

  /// third required field for login
  @HiveField(2)
  final bool isCompleted;

  /// third required field for login
  @HiveField(3)
  final String? task_creation_time;

  /// its contstruct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  TaskModel({
    this.tid,
    this.title,
    required this.isCompleted,
    this.task_creation_time,
  });
  TaskModel copyWith({
    int? tid,
    String? title,
    bool? isCompleted,
    String? task_creation_time,
  }) {
    return TaskModel(
      tid: tid ?? this.tid,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      task_creation_time: task_creation_time ?? this.task_creation_time,
    );
  }
}
