import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

class AISummaryWidget extends ConsumerStatefulWidget {
  const AISummaryWidget({super.key});

  @override
  ConsumerState<AISummaryWidget> createState() => _AISummaryWidgetState();
}

class _AISummaryWidgetState extends ConsumerState<AISummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskControllerProvider);
    final taskTitles =
        tasks.isEmpty ? '' : tasks.map((t) => '- ${t.title}').join('\n');
    final summaryAsync = ref.watch(aiSummaryProvider(taskTitles));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AI-Generated Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (tasks.isEmpty)
            const Text("No tasks available to summarize.")
          else
            summaryAsync.when(
              data: (summary) => Text(summary),
              loading:
                  () => const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Generating summary..."),
                  ),
              error:
                  (e, _) => const Text(
                    "Unable to generate summary. Please try again.",
                  ),
            ),
        ],
      ),
    );
  }
}
