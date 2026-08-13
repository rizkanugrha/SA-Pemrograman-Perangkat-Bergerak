import '../../domain/task.dart';
import 'task_database.dart';
// Catatan: saat mengimplementasi TODO, tambahkan import berikut untuk
// memakai konstanta nama kolom:
//   import 'task_database.dart';

/// Mengkonversi antara model [Task] dan baris SQLite (Map<String, Object?>).
///
/// Catatan tipe:
/// - [Task.dueDate] disimpan sebagai ISO-8601 string.
/// - [Task.priority] disimpan sebagai nama enum (`low`/`medium`/`high`).
/// - [Task.isCompleted] disimpan sebagai integer 0/1.
///
/// Implementasi `fromRow` dan `toRow` sengaja **TODO** agar mahasiswa
/// mempraktikkan marshaling tipe eksplisit. Lihat README checkpoint.
class TaskMapper {
  const TaskMapper._();

  static Task fromRow(Map<String, Object?> row) {
    return Task(
      id: row[TaskSchema.columnId] as String,
      title: row[TaskSchema.columnTitle] as String,
      description: row[TaskSchema.columnDescription] as String,
      dueDate: DateTime.parse(row[TaskSchema.columnDueDate] as String),
      priority:
          TaskPriority.values.byName(row[TaskSchema.columnPriority] as String),
      isCompleted: (row[TaskSchema.columnIsCompleted] as int) != 0,
    );
  }

  static Map<String, Object?> toRow(Task task) {
    return <String, Object?>{
      TaskSchema.columnId: task.id,
      TaskSchema.columnTitle: task.title,
      TaskSchema.columnDescription: task.description,
      TaskSchema.columnDueDate: task.dueDate.toIso8601String(),
      TaskSchema.columnPriority: task.priority.name,
      TaskSchema.columnIsCompleted: task.isCompleted ? 1 : 0,
    };
  }
}
