import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_search_bar.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/task_priority_chips.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Future<void> _openForm(BuildContext context, {Task? task}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TaskFormScreen(task: task),
      ),
    );
  }

  void _openDetail(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.homeTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const TaskSearchBar(),
          const TaskFilterChips(),
          const TaskPriorityChips(),
          const SizedBox(height: 8),
          Expanded(child: _body(context, provider)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, TaskProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return _ErrorView(
        message: provider.error!,
        onRetry: () => context.read<TaskProvider>().loadTasks(),
      );
    }

    // Mengambil task yang sudah difilter (Search + Status + Priority)
    final visibleTasks = provider.filteredTasks;

    if (visibleTasks.isEmpty) {
      return _buildEmpty(context, provider);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 600;
        return wide
            ? _grid(context, visibleTasks)
            : _list(context, visibleTasks);
      },
    );
  }

  Widget _list(BuildContext context, List<Task> tasks) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildListItem(context, tasks[index]),
    );
  }

  Widget _grid(BuildContext context, List<Task> tasks) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 132,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _buildListItem(context, tasks[index]),
    );
  }

  // Komponen pembungkus Card agar bisa di-swipe hapus dan merespons tap
  Widget _buildListItem(BuildContext context, Task task) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.errorContainer,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => context.read<TaskProvider>().deleteTask(task.id),
      child: TaskCard(
        task: task,
        onTap: () => _openDetail(context, task),
        onToggle: () => context.read<TaskProvider>().toggleComplete(task.id),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, TaskProvider provider) {
    String message = AppStrings.emptyAll;

    if (provider.searchQuery.trim().isNotEmpty) {
      message = AppStrings.emptySearch
          .replaceAll('{query}', provider.searchQuery.trim());
    } else if (provider.statusFilter != null ||
        provider.priorityFilter != null) {
      message = 'Tidak ada tugas yang cocok dengan filter yang dipilih.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.actionDelete),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text(AppStrings.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}
