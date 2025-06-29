import 'package:opsmate/features/tasks/domain/task_model.dart';

/// this is the file where auth_controller connect with repositories
class TaskRepository {
  final List<TaskModel> _tasks = [];

  /// Add a new task
  Future<TaskModel?> addTask(String text) async {
    final task = TaskModel(
      tid: DateTime.now().microsecondsSinceEpoch.toInt(),
      title: text,
      isCompleted: false,
      taskCreationTime: DateTime.now().toString(),
    );
    _tasks.add(task); // <-- Add this line to save the task!

    return task;
  }

  /// Toggle Task Completion
  Future<void> toggleTask(int tid) async {
    final index = _tasks.indexWhere((task) => task.tid == tid);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
    }
  }

  /// Remove a Task
  Future<void> removeTask(int id) async {
    _tasks.removeWhere((task) => task.tid == id);
  }

  /// Edit a task
  Future<void> editTask(int id, String newText) async {
    final index = _tasks.indexWhere((task) => task.tid == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(title: newText);
    }
  }

  /// Get All Tasks
  List<TaskModel> getTasks() => List.unmodifiable(_tasks);
}
