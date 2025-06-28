import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/task_controller.dart';
import '../domain/task_model.dart';
import '../infrastructure/Task_repository.dart';

/// Provides an instance of TaskRepository.
final taskRepositoryProvider = Provider((ref) => TaskRepository());

/// Provides the TaskController and exposes the list of tasks.

final taskControllerProvider =
    StateNotifierProvider<TaskController, List<TaskModel>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskController(repo);
    });
