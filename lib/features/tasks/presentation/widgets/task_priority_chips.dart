import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';

enum PriorityFilter { all, high, medium, low }

class TaskPriorityChips extends StatelessWidget {
  const TaskPriorityChips({super.key});

  TaskPriority? _resolvePriority(PriorityFilter f) {
    switch (f) {
      case PriorityFilter.all:
        return null;
      case PriorityFilter.high:
        return TaskPriority.high;
      case PriorityFilter.medium:
        return TaskPriority.medium;
      case PriorityFilter.low:
        return TaskPriority.low;
    }
  }

  PriorityFilter _resolveFilter(TaskPriority? p) {
    if (p == null) return PriorityFilter.all;
    switch (p) {
      case TaskPriority.high:
        return PriorityFilter.high;
      case TaskPriority.medium:
        return PriorityFilter.medium;
      case TaskPriority.low:
        return PriorityFilter.low;
    }
  }

  Color _priorityColor(PriorityFilter f) {
    switch (f) {
      case PriorityFilter.all:
        return AppColors.primary;
      case PriorityFilter.high:
        return AppColors.priorityHigh;
      case PriorityFilter.medium:
        return AppColors.priorityMedium;
      case PriorityFilter.low:
        return AppColors.priorityLow;
    }
  }

  String _priorityLabel(PriorityFilter f) {
    switch (f) {
      case PriorityFilter.all:
        return AppStrings.filterAll;
      case PriorityFilter.high:
        return AppStrings.filterHigh;
      case PriorityFilter.medium:
        return AppStrings.filterMedium;
      case PriorityFilter.low:
        return AppStrings.filterLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membaca status filter yang sedang aktif dari Provider
    final currentFilter =
        _resolveFilter(context.watch<TaskProvider>().priorityFilter);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: PriorityFilter.values.map((f) {
          final selected = currentFilter == f;
          final color = _priorityColor(f);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_priorityLabel(f)),
              selected: selected,
              selectedColor: color.withOpacity(0.25),
              checkmarkColor: color,
              onSelected: (_) {
                context
                    .read<TaskProvider>()
                    .setPriorityFilter(_resolvePriority(f));
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
