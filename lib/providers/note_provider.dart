import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';
import '../services/gemini_service.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load notes from local storage
  Future<void> loadNotes() async {
    _setLoading(true);
    try {
      _notes = await LocalStorageService.getNotes();
      _clearError();
    } catch (e) {
      _setError('Failed to load notes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new note
  Future<Note?> createNote({
    required String content,
    String? title,
    List<String> tags = const [],
    bool isImportant = false,
    String category = 'personal',
  }) async {
    _setLoading(true);
    try {
      final note = Note(
        id: '', // Will be set by LocalStorageService
        userId: 'local_user', // Default user ID for local storage
        content: content,
        title: title,
        tags: tags,
        isImportant: isImportant,
        category: category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final newNote = await LocalStorageService.createNote(note);
      _notes.add(newNote);
      _clearError();
      notifyListeners();
      return newNote;
    } catch (e) {
      _setError('Failed to create note: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update a note
  Future<Note?> updateNote(Note note) async {
    _setLoading(true);
    try {
      final updatedNote = await LocalStorageService.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = updatedNote;
      }
      _clearError();
      notifyListeners();
      return updatedNote;
    } catch (e) {
      _setError('Failed to update note: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a note
  Future<bool> deleteNote(String noteId) async {
    _setLoading(true);
    try {
      await LocalStorageService.deleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete note: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle note importance
  Future<void> toggleNoteImportance(String noteId) async {
    final note = _notes.firstWhere((n) => n.id == noteId);
    final updatedNote = note.copyWith(isImportant: !note.isImportant);
    await updateNote(updatedNote);
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  // Get important notes
  List<Note> getImportantNotes() {
    return _notes.where((note) => note.isImportant).toList();
  }

  // Search notes
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return _notes;
    final lowercaseQuery = query.toLowerCase();
    return _notes.where((note) {
      return (note.title?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          note.content.toLowerCase().contains(lowercaseQuery) ||
          note.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
          note.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get note statistics
  Map<String, dynamic> getNoteStatistics() {
    final totalNotes = _notes.length;
    final importantNotes = _notes.where((note) => note.isImportant).length;
    final personalNotes = _notes
        .where((note) => note.category == 'personal')
        .length;
    final workNotes = _notes.where((note) => note.category == 'work').length;
    final ideasNotes = _notes.where((note) => note.category == 'ideas').length;

    return {
      'totalNotes': totalNotes,
      'importantNotes': importantNotes,
      'personalNotes': personalNotes,
      'workNotes': workNotes,
      'ideasNotes': ideasNotes,
    };
  }

  // AI-powered note suggestions
  Future<List<String>> getNoteSuggestions(String context) async {
    try {
      return await GeminiService.generateNoteSuggestions(context);
    } catch (e) {
      _setError('Failed to get AI suggestions: $e');
      return [];
    }
  }

  // AI assistance for note organization
  Future<String> getNoteAssistance(String noteContent) async {
    try {
      return await GeminiService.getNoteAssistance(noteContent);
    } catch (e) {
      _setError('Failed to get AI assistance: $e');
      return 'Unable to get AI assistance at the moment.';
    }
  }

  // Parse natural language command to create note
  Future<Note?> parseAndCreateNote(String command) async {
    try {
      final parsed = await GeminiService.parseCommand(command);

      if (parsed['action'] == 'create_note') {
        return await createNote(
          content: parsed['content'] ?? 'New note',
          title: parsed['title'],
          category: parsed['category'] ?? 'personal',
          tags: List<String>.from(parsed['tags'] ?? []),
          isImportant: parsed['isImportant'] ?? false,
        );
      }

      return null;
    } catch (e) {
      _setError('Failed to parse command: $e');
      return null;
    }
  }

  // Get notes by tags
  List<Note> getNotesByTags(List<String> tags) {
    return _notes.where((note) {
      return tags.any((tag) => note.tags.contains(tag));
    }).toList();
  }

  // Get recent notes
  List<Note> getRecentNotes({int limit = 10}) {
    final sortedNotes = List<Note>.from(_notes);
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedNotes.take(limit).toList();
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
