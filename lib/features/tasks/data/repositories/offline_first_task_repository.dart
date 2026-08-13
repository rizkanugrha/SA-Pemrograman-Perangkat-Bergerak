import '../../domain/task.dart';
import '../local/local_task_datasource.dart';
import '../remote/remote_task_datasource.dart';
import 'task_repository.dart';

class OfflineFirstTaskRepository implements TaskRepository {
  OfflineFirstTaskRepository({
    required this.local,
    required this.remote,
  });

  final LocalTaskDatasource local;
  final RemoteTaskDatasource remote;

  @override
  Future<List<Task>> getAll() async {
    try {
      final remoteTasks = await remote.getAll();

      await local.clear();
      for (final task in remoteTasks) {
        await local.insert(task);
      }
      return await local.getAll();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> save(Task task) async {
    final existingLocal = await local.getAll();
    if (existingLocal.any((t) => t.id == task.id)) {
      await local.update(task);
    } else {
      await local.insert(task);
    }

    final existingRemote = await remote.getAll();
    if (existingRemote.any((t) => t.id == task.id)) {
      await remote.update(task);
    } else {
      await remote.create(task);
    }
  }

  @override
  Future<void> remove(String id) async {
    await local.delete(id);
    await remote.remove(id);
  }
}
