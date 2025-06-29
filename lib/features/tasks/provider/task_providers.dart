import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/core/services/voice_to_text_service.dart';

import '../application/task_controller.dart';
import '../domain/task_model.dart';
import '../infrastructure/Task_repository.dart';

/// Provides an instance of TaskRepository.
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(),
);

/// Provides an instance of VoiceText Service
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// declaring a state isListeningProvider to check is recording on
final isListeningProvider = StateProvider<bool>((ref) => false);

/// Provides the TaskController and exposes the list of tasks.

final taskControllerProvider =
    StateNotifierProvider<TaskController, List<TaskModel>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskController(repo, ref);
    });
