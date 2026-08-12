import 'package:flutter/foundation.dart';
import '../../domain/task.dart';

/// State manajemen task dengan [ChangeNotifier].
///
/// PERHATIAN (P03): metode CRUD (add/update/delete/toggle) sengaja dibuat
/// `test/task_provider_test.dart` menjadi hijau. Lihat README checkpoint.
///
/// Konvensi state:
/// - [_tasks] sumber data reaktif.
/// - [_isLoading] untuk loading state UI.
/// - [_error] != null => error state UI (dengan retry).
class TaskProvider extends ChangeNotifier {
  TaskProvider({List<Task> initialTasks = const []}) : _tasks = initialTasks;

  List<Task> _tasks;
  bool _isLoading = false;
  String? _error;

// Filter state (untuk filter/search).
  String _searchQuery = '';
  TaskStatus? _statusFilter;

  String get searchQuery => _searchQuery;
  TaskPriority? _priorityFilter;
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == null || task.status == _statusFilter;
      final matchesPriority =
          _priorityFilter == null || task.priority == _priorityFilter;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

// func statre filter dan searc

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

//akhirn

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get count => _tasks.length;

  Task? findById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _tasks = Task.getDummyTasks();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---- CRUD inti (TODO student) ------------------------------------------

  /// Menambahkan task baru ke daftar.
  void addTask(Task task) {
    // Saat ini no-op agar starter tetap bisa build; test CRUD akan merah.
    _tasks = [..._tasks, task];
    notifyListeners();
  }

  /// Memperbarui task yang sudah ada (dicocokkan berdasarkan id).
  void updateTask(Task task) {
    _tasks = [
      for (final t in _tasks)
        if (t.id == task.id) task else t,
    ];
    notifyListeners();
  }

  /// Menghapus task berdasarkan [id].
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Toggle status selesai task dengan [id].
  void toggleComplete(String id) {
    _tasks = [
      for (final t in _tasks)
        if (t.id == id) t.copyWith(isCompleted: !t.isCompleted) else t,
    ];
    notifyListeners();
  }
}
