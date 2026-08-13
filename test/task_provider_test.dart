import 'package:flutter_test/flutter_test.dart';
import 'package:p03_provider_crud/features/tasks/domain/task.dart';
import 'package:p03_provider_crud/features/tasks/presentation/providers/task_provider.dart';
import 'package:p03_provider_crud/features/tasks/data/local/task_database.dart';
import 'package:p03_provider_crud/features/tasks/data/local/local_task_datasource.dart';
import 'package:p03_provider_crud/features/tasks/data/repositories/task_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Test CRUD inti untuk P03.
///
/// Sebagian test di sini **SENGAJA GAGAL (merah)** karena [TaskProvider] CRUD
/// masih no-op (TODO). Target checkpoint: implementasikan add/update/delete/
/// toggle di `task_provider.dart` sampai semua test hijau. Lihat `README.md`.
void main() {
  late TaskProvider provider;
  late TaskDatabase db;

  // 1. Inisialisasi FFI SQLite untuk environment testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // 2. Setup In-memory Database & Repository
    db = TaskDatabase(fileName: 'tasks_provider_test.db');
    await (await db.database()).execute('DELETE FROM ${TaskSchema.table}');

    final datasource = LocalTaskDatasource(db);
    final repo = LocalTaskRepository(datasource);

    provider = TaskProvider(repo);

    // 3. Masukkan initial tasks menggunakan fungsi addTask yang baru
    await provider.addTask(
      Task(
        id: '1',
        title: 'Task One',
        description: 'first',
        dueDate: DateTime(2026, 9, 1),
        priority: TaskPriority.medium,
      ),
    );
    await provider.addTask(
      Task(
        id: '2',
        title: 'Task Two',
        description: 'second',
        dueDate: DateTime(2026, 9, 2),
        priority: TaskPriority.low,
      ),
    );

    // Pastikan data dimuat ke state _tasks
    await provider.loadTasks();
  });

  test('initial state memiliki 2 task', () {
    expect(provider.count, 2);
    expect(provider.isLoading, isFalse);
    expect(provider.error, isNull);
  });

  test('findById mengembalikan task yang benar', () {
    expect(provider.findById('1')?.title, 'Task One');
    expect(provider.findById('missing'), isNull);
  });

  test(
    'addTask menambah task dan memanggil notifyListeners',
    () async {
      var changed = 0;
      provider.addListener(() => changed++);

      // Tambahkan await
      await provider.addTask(
        Task(
          id: '3',
          title: 'Task Three',
          description: 'third',
          dueDate: DateTime(2026, 9, 3),
        ),
      );

      expect(provider.count, 3);
      expect(provider.findById('3'), isNotNull);
      expect(changed, greaterThan(0));
    },
  );

  test(
    'updateTask mengganti task dengan id sama',
    () async {
      final updatedTask = Task(
        id: '1',
        title: 'Task One Updated',
        description: 'first',
        dueDate: DateTime(2026, 9, 1),
      );

      // Tambahkan await
      await provider.updateTask(updatedTask);

      expect(provider.findById('1')?.title, 'Task One Updated');
      expect(provider.count, 2);
    },
  );

  test(
    'deleteTask menghapus task',
    () async {
      // Tambahkan await
      await provider.deleteTask('1');

      expect(provider.count, 1);
      expect(provider.findById('1'), isNull);
    },
  );

  test(
    'toggleComplete membalik isCompleted',
    () async {
      expect(provider.findById('1')?.isCompleted, isFalse);

      // Tambahkan await
      await provider.toggleComplete('1');
      expect(provider.findById('1')?.isCompleted, isTrue);

      // Tambahkan await
      await provider.toggleComplete('1');
      expect(provider.findById('1')?.isCompleted, isFalse);
    },
  );
}
