import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/app/theme/app_colors.dart';
import 'package:opsmate/features/tasks/presentation/widgets/showAddTaskDialog.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

class TaskDashboard extends ConsumerStatefulWidget {
  const TaskDashboard({super.key});

  @override
  ConsumerState<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends ConsumerState<TaskDashboard> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      _isLoading = true;
    });
    await ref.read(taskControllerProvider.notifier).getTask();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskControllerProvider);
    print(tasks);
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI-Generated Summary",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Meeting with design-team is scheduled for 10 AM, Prepare presentation for project kickoff.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
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
                                    .toggleTask(index),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 10),
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
                      // TODO: Add voice-to-text logic
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5), // Border width
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.accentDark,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mic,
                            size: 30,
                            color: AppColor.buttonText,
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
