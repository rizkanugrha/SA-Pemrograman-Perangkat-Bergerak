import 'package:flutter/foundation.dart';
import '../../../../core/errors/api_error.dart';
import '../../data/repositories/offline_first_task_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/task.dart';

/// State manajemen task dengan [ChangeNotifier], menyimpan via [TaskRepository]
/// (remote P05).
///
/// PERHATIAN (P05): method CRUD (add/update/delete/toggle) sengaja dibuat
/// **no-op** sebagai TODO inti. Hubungkan ke [_repo] lalu refresh list.
/// `loadTasks` sudah terhubung sehingga GET memperlihatkan data fixture/mock.
///
/// Konvensi state:
/// - [_tasks] hasil GET dari repo (mock by default).
/// - [_isLoading] => loading state UI.
/// - [_error] != null => error state UI (dengan retry manual).
///
class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repo);
  final TaskRepository _repo;

  List<Task> _tasks = const [];
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;

  // --- Filter & search ---
  String _searchQuery = '';
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;

  String get searchQuery => _searchQuery;
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;
  int get count => _tasks.length;

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

  Task? findById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Memuat seluruh task dari repository. Bila mock (default), mengembalikan
  /// fixture. Bila jaringan gagal, [_error] terisi untuk state error UI.

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _repo.getAll();
      _isOffline = false;
    } on ApiError catch (e) {
      _error = e.message;
      _isOffline = true;
      _loadFallbackLocalData();
    } catch (e) {
      _error = 'Gagal memuat: $e';
      _isOffline = true;
      _loadFallbackLocalData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFallbackLocalData() async {
    if (_repo is OfflineFirstTaskRepository) {
      _tasks = await _repo.local.getAll();
    }
  }

  // ---- CRUD inti (TODO student) ------------------------------------------

  Future<void> addTask(Task task) async {
    try {
      await _repo.save(task);
      _error = null;
    } on ApiError catch (e) {
      _error = e.message;
      _isOffline = true;
    }
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    try {
      await _repo.save(task);
      _error = null;
    } on ApiError catch (e) {
      _error = e.message;
      _isOffline = true;
    }
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repo.remove(id);
      _error = null;
    } on ApiError catch (e) {
      _error = e.message;
      _isOffline = true;
    }
    await loadTasks();
  }

  Future<void> toggleComplete(String id) async {
    final task = findById(id);
    if (task == null) return;
    try {
      await _repo.save(task.copyWith(isCompleted: !task.isCompleted));
      _error = null;
    } on ApiError catch (e) {
      _error = e.message;
      _isOffline = true;
    }
    await loadTasks();
  }
}
