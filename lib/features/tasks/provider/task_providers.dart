import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/core/services/mistral_service.dart';
import 'package:opsmate/core/services/voice_to_text_service.dart';

import '../application/task_controller.dart';
import '../domain/task_model.dart';
import '../infrastructure/task_repository.dart';

/// Task repository that interacts with Hive
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(),
);

/// Voice input for adding tasks
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// Controller for task logic and Hive access
final taskControllerProvider =
    StateNotifierProvider<TaskController, List<TaskModel>>((ref) {
      final repo = ref.watch(taskRepositoryProvider);
      return TaskController(repo, ref);
    });

/// Mistral AI summary service
final mistralServiceProvider = Provider((ref) => MistralService());

/// Async summary from Mistral for task list
final aiSummaryProvider = FutureProvider.family<String, String>((
  ref,
  taskList,
) {
  final service = ref.read(mistralServiceProvider);
  return service.generateSummary(taskList);
});
