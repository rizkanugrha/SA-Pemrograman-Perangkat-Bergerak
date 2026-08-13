import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/tasks/presentation/providers/task_provider.dart';

import 'features/tasks/data/local/local_task_datasource.dart';
import 'features/tasks/data/local/task_database.dart';

import 'features/tasks/data/remote/api_config.dart';
import 'features/tasks/data/remote/http_task_api_client.dart';
import 'features/tasks/data/remote/mock_task_api_client.dart';
import 'features/tasks/data/remote/remote_task_datasource.dart';
import 'features/tasks/data/remote/task_api_client.dart';

import 'features/tasks/data/repositories/offline_first_task_repository.dart';

void main() {
  // Wajib ditambahkan jika ada inisialisasi async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  final database = TaskDatabase();
  final localDatasource = LocalTaskDatasource(database);

  final TaskApiClient client = ApiConfig.useMock
      ? MockTaskApiClient()
      : HttpTaskApiClient(
          baseUrl: ApiConfig.baseUrl, token: ApiConfig.apiToken);
  final remoteDatasource = RemoteTaskDatasource(client);

  // Menggabungkan Lokal dan Remote ke dalam Offline-First Repository
  final repository = OfflineFirstTaskRepository(
    local: localDatasource,
    remote: remoteDatasource,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(repository)..loadTasks(),
      child: const TaskTrackerApp(),
    ),
  );
}
