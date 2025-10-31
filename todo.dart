import 'dart:io';
import 'dart:convert';

class Task {
  int id;
  String title;
  bool isCompleted;
  DateTime? dueDate;
  String category;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'dueDate': dueDate?.toIso8601String(),
    'category': category,
  };

  static Task fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    isCompleted: json['isCompleted'],
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    category: json['category'],
  );
}

List<Task> tasks = [];
int nextId = 1;
final filePath = 'tasks.json';

void clearScreen() =>
    print(Process.runSync("clear", [], runInShell: true).stdout);

void showHeader(String title) {
  print('\n' + '=' * 50);
  print(title.toUpperCase().padLeft(25 + title.length ~/ 2));
  print('=' * 50);
}

void pressEnterToContinue() {
  print('\nTekan Enter untuk melanjutkan...');
  stdin.readLineSync();
}

void saveTasks() {
  final jsonData = jsonEncode(tasks.map((e) => e.toJson()).toList());
  File(filePath).writeAsStringSync(jsonData);
}

void loadTasks() {
  final file = File(filePath);
  if (file.existsSync()) {
    final jsonData = file.readAsStringSync();
    final data = jsonDecode(jsonData) as List;
    tasks = data.map((e) => Task.fromJson(e)).toList();
    if (tasks.isNotEmpty) {
      nextId = tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }
}

DateTime? askForDueDate() {
  stdout.write('Masukkan tanggal deadline (yyyy-mm-dd) atau kosongkan: ');
  final input = stdin.readLineSync()?.trim();
  if (input == null || input.isEmpty) return null;

  try {
    return DateTime.parse(input);
  } catch (_) {
    print('❌ Format tanggal tidak valid!');
    return askForDueDate();
  }
}

void addTask() {
  clearScreen();
  showHeader('Tambah Tugas Baru');

  stdout.write('Judul tugas: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  if (title.isEmpty) {
    print('❌ Judul tidak boleh kosong!');
    pressEnterToContinue();
    return;
  }

  stdout.write('Kategori tugas (contoh: Sekolah, Rumah, dll): ');
  final category = stdin.readLineSync()?.trim() ?? 'Umum';

  final dueDate = askForDueDate();

  tasks.add(Task(
    id: nextId++,
    title: title,
    category: category,
    dueDate: dueDate,
  ));

  print('\n✅ Tugas "$title" berhasil ditambahkan!');
  pressEnterToContinue();
}

void viewTasks({bool showCompleted = false}) {
  clearScreen();
  showHeader('Daftar Tugas ${showCompleted ? 'Selesai' : 'Aktif'}');

  final filtered = tasks.where((t) => showCompleted ? t.isCompleted : !t.isCompleted).toList();
  filtered.sort((a, b) {
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  });

  if (filtered.isEmpty) {
    print('Tidak ada tugas ${showCompleted ? 'selesai' : 'aktif'}');
    pressEnterToContinue();
    return;
  }

  for (final task in filtered) {
    final status = task.isCompleted ? '[✔]' : '[ ]';
    final due = task.dueDate != null
        ? ' (Deadline: ${task.dueDate!.day}/${task.dueDate!.month})'
        : '';
    print('${task.id}. $status ${task.title}$due [${task.category}]');
  }

  pressEnterToContinue();
}

void completeTask() {
  viewTasks(showCompleted: false);
  stdout.write('\nMasukkan ID tugas yang selesai: ');
  final input = stdin.readLineSync();

  try {
    final id = int.parse(input!);
    final task = tasks.firstWhere((t) => t.id == id);
    if (task.isCompleted) {
      print('❗ Tugas sudah selesai.');
    } else {
      task.isCompleted = true;
      print('✅ Tugas "${task.title}" ditandai selesai!');
    }
  } catch (_) {
    print('❌ ID tidak valid!');
  }

  pressEnterToContinue();
}

void deleteTask() {
  viewTasks(showCompleted: true);
  stdout.write('\nMasukkan ID tugas yang dihapus: ');
  final input = stdin.readLineSync();

  try {
    final id = int.parse(input!);
    final task = tasks.firstWhere((t) => t.id == id);
    tasks.remove(task);
    print('🗑 Tugas "${task.title}" dihapus!');
  } catch (_) {
    print('❌ ID tidak valid!');
  }

  pressEnterToContinue();
}

void searchTasks() {
  clearScreen();
  showHeader('Cari Tugas');

  stdout.write('Ketik kata kunci: ');
  final keyword = stdin.readLineSync()?.trim().toLowerCase() ?? '';

  final results = tasks.where((t) => t.title.toLowerCase().contains(keyword)).toList();

  if (results.isEmpty) {
    print('❌ Tidak ada hasil untuk "$keyword"');
  } else {
    for (final task in results) {
      final highlighted = task.title.replaceAllMapped(
        RegExp(keyword, caseSensitive: false),
        (m) => '\x1B[33m${m.group(0)}\x1B[0m',
      );
      final status = task.isCompleted ? '[✔]' : '[ ]';
      print('${task.id}. $status $highlighted [${task.category}]');
    }
  }

  pressEnterToContinue();
}

void showCategoryStats() {
  clearScreen();
  showHeader('Statistik Tugas per Kategori');

  final Map<String, int> stats = {};
  for (final task in tasks) {
    stats[task.category] = (stats[task.category] ?? 0) + 1;
  }

  if (stats.isEmpty) {
    print('Belum ada tugas.');
  } else {
    stats.forEach((category, count) {
      print('- $category: $count tugas');
    });
  }

  pressEnterToContinue();
}

void mainMenu() {
  loadTasks();
  while (true) {
    clearScreen();
    showHeader('aplikasi todo list cli');

    print('''
          1. Tambah Tugas Baru
          2. Lihat Tugas Aktif
          3. Lihat Tugas Selesai
          4. Tandai Tugas Selesai
          5. Hapus Tugas
          6. Cari Tugas
          7. Statistik per Kategori
          8. Keluar
              ''');

    stdout.write('Pilih menu (1-8): ');
    final input = stdin.readLineSync();

    switch (input) {
      case '1': addTask(); break;
      case '2': viewTasks(); break;
      case '3': viewTasks(showCompleted: true); break;
      case '4': completeTask(); break;
      case '5': deleteTask(); break;
      case '6': searchTasks(); break;
      case '7': showCategoryStats(); break;
      case '8':
        saveTasks();
        print('💾 Data disimpan. Sampai jumpa!');
        exit(0);
      default:
        print('❌ Pilihan tidak valid!');
        pressEnterToContinue();
    }
  }
}

void main() => mainMenu();