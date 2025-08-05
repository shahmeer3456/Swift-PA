import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/note.dart';

class LocalStorageService {
  static const String _tasksKey = 'tasks';
  static const String _notesKey = 'notes';
  static const String _settingsKey = 'settings';

  // Tasks
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];

    return tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();

    await prefs.setStringList(_tasksKey, tasksJson);
  }

  static Future<Task> createTask(Task task) async {
    final tasks = await getTasks();
    final newTask = task.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    tasks.add(newTask);
    await saveTasks(tasks);
    return newTask;
  }

  static Future<Task> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);

    if (index != -1) {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      tasks[index] = updatedTask;
      await saveTasks(tasks);
      return updatedTask;
    }

    throw Exception('Task not found');
  }

  static Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  // Notes
  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    return notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();

    await prefs.setStringList(_notesKey, notesJson);
  }

  static Future<Note> createNote(Note note) async {
    final notes = await getNotes();
    final newNote = note.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    notes.add(newNote);
    await saveNotes(notes);
    return newNote;
  }

  static Future<Note> updateNote(Note note) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == note.id);

    if (index != -1) {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      notes[index] = updatedNote;
      await saveNotes(notes);
      return updatedNote;
    }

    throw Exception('Note not found');
  }

  static Future<void> deleteNote(String noteId) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == noteId);
    await saveNotes(notes);
  }

  // Settings
  static Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null) {
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    }

    return {
      'theme': 'system',
      'notifications': true,
      'autoBackup': false,
      'geminiApiKey': '',
    };
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  // Search functionality
  static Future<List<Task>> searchTasks(String query) async {
    final tasks = await getTasks();
    final lowercaseQuery = query.toLowerCase();

    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          (task.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static Future<List<Note>> searchNotes(String query) async {
    final notes = await getNotes();
    final lowercaseQuery = query.toLowerCase();

    return notes.where((note) {
      return (note.title?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          note.content.toLowerCase().contains(lowercaseQuery) ||
          note.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
          note.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filter functionality
  static Future<List<Task>> getTasksByStatus(String status) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.status == status).toList();
  }

  static Future<List<Task>> getTasksByPriority(String priority) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }

  static Future<List<Note>> getNotesByCategory(String category) async {
    final notes = await getNotes();
    return notes.where((note) => note.category == category).toList();
  }

  static Future<List<Note>> getImportantNotes() async {
    final notes = await getNotes();
    return notes.where((note) => note.isImportant).toList();
  }

  // Statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    final tasks = await getTasks();
    final notes = await getNotes();

    final completedTasks = tasks
        .where((task) => task.status == 'completed')
        .length;
    final pendingTasks = tasks.where((task) => task.status == 'pending').length;
    final importantNotes = notes.where((note) => note.isImportant).length;

    return {
      'totalTasks': tasks.length,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'totalNotes': notes.length,
      'importantNotes': importantNotes,
      'completionRate': tasks.isNotEmpty
          ? (completedTasks / tasks.length * 100).round()
          : 0,
    };
  }

  // Export/Import functionality
  static Future<String> exportData() async {
    final tasks = await getTasks();
    final notes = await getNotes();
    final settings = await getSettings();

    final exportData = {
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'notes': notes.map((note) => note.toJson()).toList(),
      'settings': settings,
      'exportDate': DateTime.now().toIso8601String(),
    };

    return jsonEncode(exportData);
  }

  static Future<void> importData(String jsonData) async {
    final data = jsonDecode(jsonData) as Map<String, dynamic>;

    if (data['tasks'] != null) {
      final tasks = (data['tasks'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
      await saveTasks(tasks);
    }

    if (data['notes'] != null) {
      final notes = (data['notes'] as List)
          .map((json) => Note.fromJson(json))
          .toList();
      await saveNotes(notes);
    }

    if (data['settings'] != null) {
      await saveSettings(data['settings'] as Map<String, dynamic>);
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
    await prefs.remove(_notesKey);
    await prefs.remove(_settingsKey);
  }
}
