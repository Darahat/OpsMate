import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/task_model.dart';
import '../infrastructure/Task_repository.dart';

final taskLoadingProvider = StateProvider<bool>((ref) => false);

/// this class is calling Task_repository model functions
///
/// and put user data to hive box and changin state value
class TaskController extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repo;
  final Ref ref;

  TaskController(this._repo, this.ref) : super(_repo.getTasks());

  /// addTask controller calling addTask repository and set state
  Future<void> getTask() async {
    ref.read(taskLoadingProvider.notifier).state = true;
    await _repo.getTasks();
    state = _repo.getTasks();
    ref.read(taskLoadingProvider.notifier).state = false;
  }

  /// addTask controller calling addTask repository and set state
  Future<void> addTask(String text) async {
    final task = await _repo.addTask(text);
    if (task != null) {
      state = _repo.getTasks();
    }
  }

  /// edit task controller calling edittask repository and set state
  Future<void> toggleTask(int id) async {
    await _repo.toggleTask(id);
    state = _repo.getTasks();
  }

  /// removeTask controller calling removeTask repository and set state
  Future<void> removeTask(int id) async {
    await _repo.removeTask(id);
    state = _repo.getTasks();
  }

  /// edit task controller calling edittask repository and set state
  Future<void> editTask(int id, String newText) async {
    await _repo.editTask(id, newText);
    state = _repo.getTasks();
  }
}
