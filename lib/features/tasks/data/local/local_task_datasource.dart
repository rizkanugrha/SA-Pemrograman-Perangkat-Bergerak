import 'package:sqflite/sqflite.dart';
import '../../domain/task.dart';
import 'task_database.dart';
import 'task_mapper.dart';

// Catatan: saat mengimplementasi TODO, tambahkan import berikut:
//   import 'package:sqflite/sqflite.dart';
//   import 'task_mapper.dart';

/// Sumber data lokal berbasis SQLite.
///
/// Semua method CRUD sengaja **no-op/TODO**. Selesaikan [TaskMapper] lebih
/// dulu (checkpoint 2), lalu implementasikan method di sini memakai
/// [TaskDatabase.database()] dan [TaskMapper]. Lihat README checkpoint.
class LocalTaskDatasource {
  LocalTaskDatasource(this._db);
  final TaskDatabase _db;

  /// Mengambil seluruh task, urut judul naik.

  Future<List<Task>> getAll() async {
    final db = await _db.database();
    final rows = await db.query(
      TaskSchema.table,
      orderBy: '${TaskSchema.columnTitle} ASC',
    );
    return rows.map(TaskMapper.fromRow).toList();
  }

  /// Menyisipkan task baru. Gunakan conflictAlgorithm.replace agar aman.

  Future<void> insert(Task task) async {
    final db = await _db.database();
    await db.insert(
      TaskSchema.table,
      TaskMapper.toRow(task),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Memperbarui task yang sudah ada (dicocokkan berdasarkan id).

  Future<void> update(Task task) async {
    final db = await _db.database();
    await db.update(
      TaskSchema.table,
      TaskMapper.toRow(task),
      where: '${TaskSchema.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  /// Menghapus task berdasarkan id.

  Future<void> delete(String id) async {
    final db = await _db.database();
    await db.delete(
      TaskSchema.table,
      where: '${TaskSchema.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Mengosongkan tabel. Berguna untuk reset sesi lab.

  Future<void> clear() async {
    final db = await _db.database();
    await db.delete(TaskSchema.table);
  }
}
