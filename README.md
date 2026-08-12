# Assignment 1: Task Tracker Core

**Penulis:** Rizka Nugraha

**NIM:** A11.2022.14119

**Mata Kuliah:** Pemrograman Perangkat Bergerak

Aplikasi **Task Tracker Core** ini adalah fondasi aplikasi manajemen tugas yang dibangun menggunakan Flutter. Proyek ini mendemonstrasikan implementasi antarmuka yang responsif (mendukung *portrait* dan *landscape*), validasi *form* yang ketat, dan pengelolaan *state* (State Management) terpusat menggunakan `Provider` dan `ChangeNotifier`.

---

## Instruksi run

```bash
flutter create --project-name p03_provider_crud --platforms=android,web . # di dalam folder ini
flutter pub get
flutter analyze
flutter test
flutter run
```

## Struktur dir

```text
lib/
├── main.dart # MultiProvider + ChangeNotifierProvider
├── app.dart
├── core/{constants,theme}/
└── features/tasks/
 ├── domain/task.dart
 └── presentation/
 ├── providers/task_provider.dart
 ├── screens/
 │ ├── task_list_screen.dart 
 │ ├── task_form_screen.dart 
 │ └── task_detail_screen.dart
 ├──  widgets/
 │ ├── task_card.dart
 │ ├── task_filter_chips.dart
 │ ├── task_priority_chips.dart
 │ ├── task_search_bar.dart


test/
├── task_provider_test.dart # beberapa test sengaja MERAH
└── widget_test.dart # smoke (hijau)
```

## ✨ Fitur Utama
1. Daftar Tugas Responsif: Tampilan otomatis beradaptasi dari ListView (satu kolom) di layar portrait menjadi GridView (dua kolom) di layar landscape (lebar >= 600dp).

2. Detail Tugas Lengkap: Menampilkan seluruh informasi tugas termasuk tenggat waktu (due date), status turunan (pending/overdue/completed), dan prioritas.

3. CRUD Penuh via Provider: Fitur Tambah, Edit, Hapus (dengan dialog konfirmasi), dan Toggle Status yang terintegrasi penuh secara reaktif tanpa setState manual di UI.

4. Pencarian & Filter Pintar (Kombinasi AND): Memungkinkan pengguna mencari tugas berdasarkan judul, menyaring berdasarkan status, dan menyaring berdasarkan prioritas secara bersamaan.

5. Validasi Form Cerdas: Mencegah pengiriman form jika judul kosong atau kurang dari 3 karakter. Terdapat validasi tambahan yang menolak due date di masa lalu secara spesifik saat membuat tugas baru.



## AI Interaction Log - Assignment 1 Task Tracker Core

### 🛡️ Pernyataan Kepatuhan AI
Saya menyatakan bahwa penggunaan AI (Gemini) dalam tugas ini mematuhi batas aturan P1-P3. AI hanya digunakan sebagai teman diskusi untuk **penjelasan konsep widget/Provider**, **diagnosis error linter**, dan **diskusi logika parsial**. Saya **TIDAK** menggunakan AI untuk men-generate keseluruhan aplikasi dari satu *prompt* kosong. Seluruh implementasi *core logic* didasari oleh kode P01-P03 yang saya tulis sendiri dan telah saya analisis sebelum dimodifikasi.

---

### Interaksi 1: Diskusi Konsep OOP dan Ekstraksi Widget (Batas Boleh: Konsep Widget)
* **Tujuan:** Merapikan `TaskListScreen` yang sudah panjang agar mematuhi prinsip OOP dengan memisahkan UI *search* dan *filter*.
* **Prompt Utama:** "tambahkan search dan filter dari kode itu p03 saya... biarkan file task_list_screen saya p03 statelesswidget, dan buatkan filter dan searchhnya di luar, dan hanya dipanggil di task_list screen saja"
* **Ringkasan Respons AI:** AI menjelaskan cara kerja ekstraksi komponen menjadi `TaskSearchBar` dan `TaskFilterChips`. AI menyarankan penggunaan `context.read` dan `context.watch` di dalam widget terpisah agar `TaskListScreen` tetap murni sebagai `StatelessWidget`.
* **Keputusan (Terima/Tolak):** **Diterima dengan analisis.**
* **Alasan Penerimaan:** Secara arsitektur, pemisahan widget ini tidak merusak aturan penugasan, justru memperbaiki *clean code*. Saya menganalisis bahwa selama widget baru tersebut memanggil `notifyListeners()` via Provider, syarat *state management* tetap terpenuhi.
* **Verifikasi Pemahaman:** Menjalankan `flutter run`. Saat mengetik di *search bar*, saya melihat di *DevTools* bahwa hanya komponen *list* yang ter-*rebuild*, membuktikan bahwa ekstraksi widget ini efisien dan bekerja dengan benar.

---

### Interaksi 2: Refactoring Logika Filter AND (Batas Boleh: Diskusi Logika Bertahap)
* **Tujuan:** Menyelesaikan syarat mutlak bahwa Search, Status, dan Priority harus bekerja bersamaan (Logika AND).
* **Prompt Utama:** "baca soalnya kemudian bantu saya untuk menyelesaikan assignment ini... bagian mana dari requirement ini yang ingin kita selesaikan pertama kali?"
* **Ringkasan Respons AI:** AI merekomendasikan pengerjaan logika Provider lebih dulu, dan menyarankan penggunaan method `.where()` berantai yang membandingkan variabel `_searchQuery`, `_statusFilter`, dan `_priorityFilter` secara bersamaan menggunakan operator `&&`.
* **Keputusan (Terima/Tolak):** **Diterima setelah dianalisis.**
* **Alasan Penerimaan:** Saya mengevaluasi logika `&&` (AND) tersebut dan menyadari ini lebih efektif daripada menyaring senarai (`List`) berulang kali. Jika pengguna tidak memilih filter (nilai `null`), operator logika memastikan variabel tersebut bernilai `true` sehingga tidak memblokir data.
* **Verifikasi Pemahaman:** Saya membuktikan logika ini secara manual di aplikasi dengan menyalakan filter "Completed" + "High Priority". Tugas yang tidak memenuhi kedua kriteria tersebut otomatis tersembunyi dari layar.

---

### Interaksi 3: Diagnosis Logika Legacy P02 (Menolak Solusi AI)
* **Tujuan:** Menggabungkan kode *responsive layout* (Grid/List) dari P02 ke dalam *screen* P03.
* **Prompt Utama:** "kode p02 untuk membuka detail di screenlist: [melampirkan kode Stateful P02 yang menggunakan setState]"
* **Ringkasan Respons AI (Skenario Diskusi):** Saat mendiskusikan penggabungan UI P02 ke P03, ada potensi mempertahankan struktur `StatefulWidget` untuk menangani navigasi dan penambahan tugas baru menggunakan fungsi `.then()` dan `setState`.
* **Keputusan (Terima/Tolak):** **DITOLAK.**
* **Alasan Penolakan:** Berdasarkan rubrik tugas, "Seluruh mutasi wajib lewat TaskProvider... tanpa setState manual di list/detail". Jika saya menerima penggunaan `setState` untuk mem- *push* data baru ke layar utama (seperti gaya P02), poin *State & data flow* saya akan hangus. Saya akhirnya melakukan penyesuaian sendiri dengan membungkus layout UI P02 ke dalam `StatelessWidget` P03 dan mendelegasikan pengambilan datanya murni lewat `context.watch<TaskProvider>().filteredTasks`.
* **Verifikasi Pemahaman:** Saya menguji penambahan *task* baru. Karena murni menggunakan `context.watch`, UI daftar tugas langsung bertambah tanpa perlu saya memanggil pembaruan UI lokal secara manual.

---

### Interaksi 4: Diagnosis Error Tooling (Batas Boleh: Diagnosis Error)
* **Tujuan:** Membersihkan hasil pengecekan linter agar terminal 100% hijau.
* **Prompt Utama:** "flutter analyze... warning - The value of the local variable 'theme' isn't used..." dan "unused task_filter? kenapa?"
* **Ringkasan Respons AI:** AI mendiagnosis bahwa variabel `theme` dan *import* `task_filter.dart` merupakan *dead code* karena deklarasinya ada namun tidak pernah dieksekusi atau dipanggil di dalam file terkait.
* **Keputusan (Terima/Tolak):** **Diterima.**
* **Alasan Penerimaan:** Penjelasan AI sangat ringkas dan terbukti kebenarannya. Menghapus kode mati (*dead code*) adalah praktik pengembangan yang baik.
* **Verifikasi Pemahaman:** Saya menghapus kode yang bermasalah dan menjalankan ulang perintah `flutter analyze`. Hasil akhir di terminal menunjukkan "No issues found".

---

### Interaksi 5: Penambahan Validasi Kustom (Batas Boleh: Analisis tanpa Auto-Generate Lengkap)
* **Tujuan:** Menambahkan aturan bahwa *due date* tidak boleh di masa lalu hanya saat mode tambah tugas.
* **Prompt Utama:** [Melampirkan kode task_form_screen.dart yang saya tulis sendiri] "task form saya... "
* **Ringkasan Respons AI:** AI menganalisis kode *form* buatan saya dan memberikan sisipan logika di dalam fungsi `_submit`. AI menambahkan blok percabangan `if (!_isEditing)` yang memotong akurasi jam menggunakan `DateTime(year, month, day)` untuk membandingkan secara adil apakah kalender yang dipilih kurang dari tanggal hari ini.
* **Keputusan (Terima/Tolak):** **Diterima dengan modifikasi.**
* **Alasan Penerimaan:** Saya sengaja tidak meminta AI menulis ulang seluruh `TaskFormScreen`. Saya hanya butuh bantuan merumuskan logika perbandingan hari (*date matching*) tanpa terpengaruh perbedaan jam. Logika perbandingan `.isBefore()` yang disarankan sangat akurat.
* **Verifikasi Pemahaman:** Saat mengetes *form* penambahan tugas baru dengan *due date* hari kemarin, penyimpanan berhasil dicegah dan menampilkan `SnackBar` peringatan. Namun saat saya melakukan *Edit* pada tugas lawas, tanggal di masa lalu sukses tersimpan.
