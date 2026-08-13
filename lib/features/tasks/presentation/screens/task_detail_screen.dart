import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task; // Task awal yang dilempar dari List

  @override
  Widget build(BuildContext context) {
    // Memantau provider untuk mendapatkan data task TERBARU berdasarkan ID.
    // Ini menjamin "Konsistensi lintas layar" seperti syarat assignment.
    final provider = context.watch<TaskProvider>();
    final freshTask = provider.findById(task.id);

    // Jika task terhapus atau tidak ditemukan, tampilkan layar kosong
    if (freshTask == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.detailTitle)),
        body: const Center(
            child: Text(AppStrings.detailNotFound,
                style: TextStyle(fontSize: 16))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.detailTitle),
        actions: [
          IconButton(
            icon: Icon(
              freshTask.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: freshTask.isCompleted
                  ? AppColors.statusCompleted
                  : AppColors.statusPending,
            ),
            onPressed: () =>
                context.read<TaskProvider>().toggleComplete(freshTask.id),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(freshTask.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(freshTask.description),
            const SizedBox(height: 16),
            _InfoRow(
              label: AppStrings.dueLabel,
              value:
                  '${freshTask.dueDate.day}/${freshTask.dueDate.month}/${freshTask.dueDate.year}',
            ),
            _InfoRow(
              label: AppStrings.priorityLabel,
              value: freshTask.priority.name.toUpperCase(),
              color: _priorityColor(freshTask.priority),
            ),
            _InfoRow(
              label: AppStrings.statusLabel,
              value: freshTask.status.name.toUpperCase(),
              color: _statusColor(freshTask.status),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TaskFormScreen(task: freshTask),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.high => AppColors.priorityHigh,
        TaskPriority.medium => AppColors.priorityMedium,
        TaskPriority.low => AppColors.priorityLow,
      };

  Color _statusColor(TaskStatus s) => switch (s) {
        TaskStatus.pending => AppColors.statusPending,
        TaskStatus.overdue => AppColors.statusOverdue,
        TaskStatus.completed => AppColors.statusCompleted,
      };
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
