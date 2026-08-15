# Assignment 2, Serialization dan API

**Nama:** Rizka Nugraha

**NIM:** A11.2022.14119

**Mata Kuliah:** Pemrograman Perangkat Bergerak

Aplikasi **Task Tracker Core** ini adalah fondasi aplikasi manajemen tugas yang dibangun menggunakan Flutter. Proyek ini mendemonstrasikan implementasi antarmuka yang responsif (mendukung *portrait* dan *landscape*), validasi *form* yang ketat, dan pengelolaan *state* (State Management) terpusat menggunakan `Provider` dan `ChangeNotifier`.

---

## Instruksi run

```bash
flutter create --name-project=p03_provider_crud --platforms=android,web . # di dalam folder ini
flutter pub get
flutter analyze
flutter test
flutter run
```


## 📁 Struktur Direktori Enhanced

```text
lib/
├── main.dart 
├── app.dart 
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_theme.dart
│   └── errors/
│       └── api_error.dart 
│
└── features/tasks/
    ├── domain/
    │   └── task.dart # Immutable Task + enums (Priority, Status)
    │
    ├── data/
    │   ├── local/
    │   │   ├── task_database.dart # SQLite initialization
    │   │   ├── local_task_datasource.dart 
    │   │   └── task_mapper.dart 
    │   │
    │   ├── remote/
    │   │   ├── api_config.dart # Environment-based config (--dart-define)
    │   │   ├── task_api_client.dart 
    │   │   ├── http_task_api_client.dart 
    │   │   ├── mock_task_api_client.dart 
    │   │   ├── remote_task_datasource.dart
    │   │   └── fixtures/ 
    │   │
    │   └── repositories/
    │       ├── task_repository.dart 
    │       └── offline_first_task_repository.dart 
    │
    └── presentation/
        ├── providers/
        │   └── task_provider.dart 
        └── screens/
            ├── task_list_screen.dart
            ├── task_detail_screen.dart
            └── task_form_screen.dart
        └── widgets/
            ├── task_card.dart
            ├── task_filter_chips.dart
            ├── task_priority_chips.dart
            └── task_search_bar.dart

test/
├── api_error_test.dart 
├── local_task_datasource_test.dart 
├── mock_task_api_client_test.dart 
├── task_mapper_test.dart 
├── task_provider_test.dart 
└── widget_test.dart 
```


## ⚙️ Konfigurasi Secure

**Tidak ada hardcoded API credentials** - menggunakan `--dart-define`:

```bash
# Development (default mock)
flutter run

# (Opsional) Mode live bila dosen menyediakan endpoint:
flutter run \
--dart-define=API_BASE_URL=https://your-server.example.com \
--dart-define=API_TOKEN=***
```

File [.env.example](.env.example) sebagai template untuk developer.

## 🧪 Testing Coverage

Semua test dapat dijalankan:
```bash
flutter test
```

## 📚 Dokumentasi AI Interactions

Semua interaksi dengan AI telah didokumentasikan di:
**→ [ai_interaction.md](ai_interaction.md)**

## 📖 Quick Start

```bash
# 1. Clone/setup
cd e:\rizka\p03-provider-crud
flutter pub get

# 2. Run checks
flutter analyze   # 0 issues ✅
flutter test      # 25/25 passing ✅

# 3. Run app
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  sqflite: ^2.3.3
  path: ^1.9.0
  http: ^1.2.2


dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  sqflite_common_ffi: ^2.3.3
```

