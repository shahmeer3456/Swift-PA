import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  // Default Gemini API key
  static const String _apiKey = 'AIzaSyBFwzdkHIIAj3R3zjiDB1wf5Pe0zwuHTcU';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Get stored API key
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('gemini_api_key') ?? _apiKey;
  }

  // Store API key
  static Future<void> storeApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', apiKey);
  }

  // Generate response from Gemini
  static Future<String> generateResponse(
    String prompt, {
    String? context,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Gemini API key not configured. Please add your API key in the app settings.',
      );
    }

    final fullPrompt = context != null ? '$context\n\n$prompt' : prompt;

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'contents': [
                {
                  'parts': [
                    {'text': fullPrompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 1024,
              },
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates.first['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts.first['text'] as String;
          }
        }
        throw Exception('No response generated from Gemini');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['error']?['message'] ?? 'Failed to generate response',
        );
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      }
      rethrow;
    }
  }

  // Parse natural language command into structured data
  static Future<Map<String, dynamic>> parseCommand(String text) async {
    final prompt =
        '''
Parse the following natural language command into structured data. Return a JSON object with the following structure:

For task creation:
{
  "action": "create_task",
  "title": "task title",
  "description": "task description",
  "priority": "low|medium|high",
  "dueDate": "YYYY-MM-DD" (if mentioned),
  "tags": ["tag1", "tag2"]
}

For note creation:
{
  "action": "create_note",
  "content": "note content",
  "title": "note title",
  "category": "personal|work|ideas",
  "tags": ["tag1", "tag2"],
  "isImportant": true/false
}

For general queries:
{
  "action": "query",
  "query": "the actual query"
}

Command: $text
''';

    try {
      final response = await generateResponse(prompt);

      // Try to parse the response as JSON
      try {
        return json.decode(response) as Map<String, dynamic>;
      } catch (e) {
        // If JSON parsing fails, return a generic query
        return {'action': 'query', 'query': text, 'rawResponse': response};
      }
    } catch (e) {
      return {'action': 'error', 'error': e.toString(), 'originalText': text};
    }
  }

  // Generate task suggestions based on user input
  static Future<List<String>> generateTaskSuggestions(String context) async {
    final prompt =
        '''
Based on the following context, suggest 3-5 relevant tasks that the user might want to create. 
Return only the task titles, one per line, without numbering or bullet points.

Context: $context
''';

    try {
      final response = await generateResponse(prompt);
      return response
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Generate note suggestions based on user input
  static Future<List<String>> generateNoteSuggestions(String context) async {
    final prompt =
        '''
Based on the following context, suggest 3-5 relevant notes that the user might want to create.
Return only the note titles, one per line, without numbering or bullet points.

Context: $context
''';

    try {
      final response = await generateResponse(prompt);
      return response
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get AI assistance for task management
  static Future<String> getTaskAssistance(String taskDescription) async {
    final prompt =
        '''
As a personal assistant, provide helpful advice for the following task:

Task: $taskDescription

Provide practical suggestions for:
1. How to approach this task effectively
2. Potential challenges and solutions
3. Time management tips
4. Related tasks that might be helpful

Keep the response concise and actionable.
''';

    return await generateResponse(prompt);
  }

  // Get AI assistance for note organization
  static Future<String> getNoteAssistance(String noteContent) async {
    final prompt =
        '''
As a personal assistant, provide helpful advice for organizing and improving this note:

Note: $noteContent

Provide suggestions for:
1. Better organization and structure
2. Additional information that might be useful
3. Related topics to explore
4. Tags or categories that would be helpful

Keep the response concise and actionable.
''';

    return await generateResponse(prompt);
  }

  // AI Assistant functionality - enhanced prompt-based responses
  static Future<String> getAIResponse(String userInput) async {
    final prompt =
        '''
You are a helpful AI assistant integrated into a personal productivity app. The user can ask you questions, request help with tasks, get advice, or have general conversations.

User Input: $userInput

Please provide a helpful, informative, and conversational response. You can:
- Answer questions about various topics
- Provide productivity tips and advice
- Help with planning and organization
- Offer creative solutions to problems
- Engage in friendly conversation
- Give educational information

Keep your response engaging, practical, and well-structured. If the user asks for specific help with tasks or notes, provide actionable advice.
''';

    return await generateResponse(prompt);
  }

  // Enhanced search functionality using AI
  static Future<String> search(String query) async {
    final prompt =
        '''
Search for information about: $query

Provide a comprehensive response that includes:
1. Key facts and information
2. Recent developments (if applicable)
3. Practical applications or examples
4. Related topics that might be of interest

Make the response informative, accurate, and well-structured.
''';

    return await generateResponse(prompt);
  }
}
