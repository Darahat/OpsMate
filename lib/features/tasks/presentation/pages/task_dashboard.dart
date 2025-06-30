import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for playing system sound
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/app/theme/app_colors.dart';
import 'package:opsmate/features/tasks/application/task_controller.dart';
import 'package:opsmate/features/tasks/presentation/widgets/showAddTaskDialog.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

/// Main Task dashboard
class TaskDashboard extends ConsumerStatefulWidget {
  /// Main Task Dashboard constructor
  const TaskDashboard({super.key});

  @override
  ConsumerState<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends ConsumerState<TaskDashboard> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(taskLoadingProvider);
    final tasks = ref.watch(taskControllerProvider);
    final isRecording = ref.watch(isListeningProvider);
    final taskTitles =
        tasks.isEmpty ? '' : tasks.map((t) => '- ${t.title}').join('\n');
    final summaryAsync = ref.watch(aiSummaryProvider(taskTitles));
    @override
    void initState() {
      super.initState();

      // Load tasks after widget tree builds
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   ref.read(taskControllerProvider.notifier).getTask();
      // });
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(title: const Text('AI Planner')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'April 24, 2024',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh:
                    () => ref.read(taskControllerProvider.notifier).getTask(),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return CheckboxListTile(
                              title: Text(task.title ?? ''),
                              subtitle:
                                  task.taskCreationTime != null
                                      ? Text(task.taskCreationTime!)
                                      : null,
                              value: task.isCompleted,
                              onChanged:
                                  (val) => ref
                                      .read(taskControllerProvider.notifier)
                                      .toggleTask(task.tid!),
                            );
                          },
                        ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: () async {
                  showAddTaskDialog(context, ref);
                },
                child: const Text("+ New Task"),
              ),
            ),
            const SizedBox(height: 20),
            if (isRecording)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text('Listening...', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

            Center(
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColor.buttonText, AppColor.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(34), // Half of 68
                    onTap: () async {
                      final voiceService = ref.read(voiceToTextProvider);
                      ref.read(isListeningProvider.notifier).state = true;

                      SystemSound.play(SystemSoundType.click); //Bip on start
                      final text = await voiceService.listenForText();
                      ref.read(isListeningProvider.notifier).state = false;
                      SystemSound.play(SystemSoundType.alert); //Bip on start

                      if (text != null && text.isNotEmpty) {
                        await ref
                            .read(taskControllerProvider.notifier)
                            .addTask(text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5), // Border width
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.accentDark,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.mic,
                            size: 30,
                            color:
                                isRecording ? Colors.red : AppColor.buttonText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
