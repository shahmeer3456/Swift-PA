import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';
import '../services/gemini_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load tasks from local storage
  Future<void> loadTasks() async {
    _setLoading(true);
    try {
      _tasks = await LocalStorageService.getTasks();
      _clearError();
    } catch (e) {
      _setError('Failed to load tasks: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new task
  Future<Task?> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    String recurring = 'none',
    String priority = 'medium',
    List<String> tags = const [],
  }) async {
    _setLoading(true);
    try {
      final task = Task(
        id: '', // Will be set by LocalStorageService
        userId: 'local_user', // Default user ID for local storage
        title: title,
        description: description,
        dueDate: dueDate,
        recurring: recurring,
        priority: priority,
        tags: tags,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final newTask = await LocalStorageService.createTask(task);
      _tasks.add(newTask);
      _clearError();
      notifyListeners();
      return newTask;
    } catch (e) {
      _setError('Failed to create task: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update a task
  Future<Task?> updateTask(Task task) async {
    _setLoading(true);
    try {
      final updatedTask = await LocalStorageService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      _clearError();
      notifyListeners();
      return updatedTask;
    } catch (e) {
      _setError('Failed to update task: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a task
  Future<bool> deleteTask(String taskId) async {
    _setLoading(true);
    try {
      await LocalStorageService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete task: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == 'completed' ? 'pending' : 'completed';
    final updatedTask = task.copyWith(status: newStatus);
    await updateTask(updatedTask);
  }

  // Get tasks by status
  List<Task> getTasksByStatus(String status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Get tasks by priority
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // Search tasks
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    final lowercaseQuery = query.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
          (task.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get task statistics
  Map<String, dynamic> getTaskStatistics() {
    final totalTasks = _tasks.length;
    final completedTasks = _tasks
        .where((task) => task.status == 'completed')
        .length;
    final pendingTasks = _tasks
        .where((task) => task.status == 'pending')
        .length;
    final highPriorityTasks = _tasks
        .where((task) => task.priority == 'high')
        .length;

    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'highPriorityTasks': highPriorityTasks,
      'completionRate': totalTasks > 0
          ? (completedTasks / totalTasks * 100).round()
          : 0,
    };
  }

  // AI-powered task suggestions
  Future<List<String>> getTaskSuggestions(String context) async {
    try {
      return await GeminiService.generateTaskSuggestions(context);
    } catch (e) {
      _setError('Failed to get AI suggestions: $e');
      return [];
    }
  }

  // AI assistance for task management
  Future<String> getTaskAssistance(String taskDescription) async {
    try {
      return await GeminiService.getTaskAssistance(taskDescription);
    } catch (e) {
      _setError('Failed to get AI assistance: $e');
      return 'Unable to get AI assistance at the moment.';
    }
  }

  // Parse natural language command to create task
  Future<Task?> parseAndCreateTask(String command) async {
    try {
      final parsed = await GeminiService.parseCommand(command);

      if (parsed['action'] == 'create_task') {
        return await createTask(
          title: parsed['title'] ?? 'New Task',
          description: parsed['description'],
          priority: parsed['priority'] ?? 'medium',
          tags: List<String>.from(parsed['tags'] ?? []),
        );
      }

      return null;
    } catch (e) {
      _setError('Failed to parse command: $e');
      return null;
    }
  }

  // Clear completed tasks
  Future<void> clearCompletedTasks() async {
    final completedTasks = _tasks
        .where((task) => task.status == 'completed')
        .toList();
    for (final task in completedTasks) {
      await deleteTask(task.id);
    }
  }

  // Get overdue tasks
  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      return task.status == 'pending' &&
          task.dueDate != null &&
          task.dueDate!.isBefore(now);
    }).toList();
  }

  // Get tasks due today
  List<Task> getTasksDueToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _tasks.where((task) {
      return task.status == 'pending' &&
          task.dueDate != null &&
          task.dueDate!.isAfter(today) &&
          task.dueDate!.isBefore(tomorrow);
    }).toList();
  }

  // Get tasks due this week
  List<Task> getTasksDueThisWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfWeek = today.add(const Duration(days: 7));

    return _tasks.where((task) {
      return task.status == 'pending' &&
          task.dueDate != null &&
          task.dueDate!.isAfter(today) &&
          task.dueDate!.isBefore(endOfWeek);
    }).toList();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
