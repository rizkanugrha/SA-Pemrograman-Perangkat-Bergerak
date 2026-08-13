import 'dart:async';

import '../../domain/task.dart';
import '../local/local_task_datasource.dart';
import '../remote/remote_task_datasource.dart';

/// Kontrak repository task. UI/Provider hanya mengenal abstraksi ini,
abstract class TaskRepository {
  Future<List<Task>> getAll();
  Future<void> save(Task task);
  Future<void> remove(String id);
}

/// Implementasi repository yang menyimpan ke [LocalTaskDatasource].
///
/// [save] bersifat upsert: bila id sudah ada, jalankan update; jika belum,
/// insert. Logika ini boleh dipakai langsung (bukan TODO inti). Yang perlu
/// diselesaikan mahasiswa ada di [LocalTaskDatasource] + [TaskMapper].
class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository(this._local);
  final LocalTaskDatasource _local;

  @override
  Future<List<Task>> getAll() => _local.getAll();

  @override
  Future<void> save(Task task) async {
    final existing = await _local.getAll();
    final exists = existing.any((t) => t.id == task.id);
    if (exists) {
      await _local.update(task);
    } else {
      await _local.insert(task);
    }
  }

  @override
  Future<void> remove(String id) => _local.delete(id);
}

/// Implementasi repository yang membaca/menulis ke [RemoteTaskDatasource].
///
/// [save] bersifat upsert: PATCH bila sudah ada, POST bila baru. Logika ini
/// boleh dipakai langsung (bukan TODO inti). Mahasiswa fokus pada wiring
/// provider + state UI error/loading/empty.
class RemoteTaskRepository implements TaskRepository {
  RemoteTaskRepository(this._remote);

  final RemoteTaskDatasource _remote;

  @override
  Future<List<Task>> getAll() => _remote.getAll();

  @override
  Future<void> save(Task task) async {
    final existing = await _remote.getAll();
    final exists = existing.any((t) => t.id == task.id);
    if (exists) {
      await _remote.update(task);
    } else {
      await _remote.create(task);
    }
  }

  @override
  Future<void> remove(String id) => _remote.remove(id);
}
