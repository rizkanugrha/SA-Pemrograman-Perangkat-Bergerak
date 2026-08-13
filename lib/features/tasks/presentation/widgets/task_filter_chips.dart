import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';

enum StatusFilter { all, pending, overdue, completed }

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key});

  TaskStatus? _resolveStatus(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return null;
      case StatusFilter.pending:
        return TaskStatus.pending;
      case StatusFilter.overdue:
        return TaskStatus.overdue;
      case StatusFilter.completed:
        return TaskStatus.completed;
    }
  }

  StatusFilter _resolveFilter(TaskStatus? s) {
    if (s == null) return StatusFilter.all;
    switch (s) {
      case TaskStatus.pending:
        return StatusFilter.pending;
      case TaskStatus.overdue:
        return StatusFilter.overdue;
      case TaskStatus.completed:
        return StatusFilter.completed;
    }
  }

  Color _statusColor(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return AppColors.primary;
      case StatusFilter.pending:
        return AppColors.statusPending;
      case StatusFilter.overdue:
        return AppColors.statusOverdue;
      case StatusFilter.completed:
        return AppColors.statusCompleted;
    }
  }

  String _statusLabel(StatusFilter f) {
    switch (f) {
      case StatusFilter.all:
        return AppStrings.filterAll;
      case StatusFilter.pending:
        return AppStrings.filterPending;
      case StatusFilter.overdue:
        return AppStrings.filterOverdue;
      case StatusFilter.completed:
        return AppStrings.filterCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membaca status filter yang sedang aktif dari Provider
    final currentFilter =
        _resolveFilter(context.watch<TaskProvider>().statusFilter);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: StatusFilter.values.map((f) {
          final selected = currentFilter == f;
          final color = _statusColor(f);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_statusLabel(f)),
              selected: selected,
              selectedColor: color.withOpacity(0.25),
              checkmarkColor: color,
              onSelected: (_) {
                context.read<TaskProvider>().setStatusFilter(_resolveStatus(f));
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
