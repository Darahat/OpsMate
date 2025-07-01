import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/app/theme/app_colors.dart';
import 'package:opsmate/features/tasks/application/task_controller.dart';
import 'package:opsmate/features/tasks/presentation/widgets/aiSummaryWidget.dart';
import 'package:opsmate/features/tasks/presentation/widgets/floatingbuttonwidget.dart';
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
    // print(summaryAsync);

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
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
                  AISummaryWidget(),
                  const SizedBox(height: 16),
                  RefreshIndicator(
                    onRefresh:
                        () =>
                            ref.read(taskControllerProvider.notifier).getTask(),
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                          Text(
                            'Listening...',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                  // Center(child: MicButtonWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Floatingbuttonwidget(),
    );
  }
}
