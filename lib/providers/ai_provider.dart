import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workflow/workflow_model.dart';
import '../repositories/ai_repository.dart';

class ChatMessage {
  final String role;
  final String content;
  final bool isLoading;
  final List<Workflow> recommendations;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    this.isLoading = false,
    this.recommendations = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessage copyWith({
    String? role,
    String? content,
    bool? isLoading,
    List<Workflow>? recommendations,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      recommendations: recommendations ?? this.recommendations,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, List<ChatMessage>>(
  (ref) {
    return AiChatNotifier(ref);
  },
);

class AiChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;

  AiChatNotifier(this._ref)
    : super([
        ChatMessage(
          role: 'assistant',
          content:
              "Hi! I'm your FlowMarket AI Assistant. Tell me what you want to automate and I'll find the perfect workflow for you.",
        ),
      ]);

  Future<void> sendMessage(String message) async {
    // Add user message
    state = [...state, ChatMessage(role: 'user', content: message)];

    // Add loading assistant message
    state = [
      ...state,
      ChatMessage(role: 'assistant', content: '', isLoading: true),
    ];

    try {
      final history = state
          .where((m) => !m.isLoading)
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      final data = await _ref
          .read(aiRepositoryProvider)
          .recommend(message: message, history: history);
      final content = data['message'] as String? ?? '';
      final workflowsJson = data['recommendations'] as List<dynamic>? ?? [];
      final workflows = workflowsJson
          .map((w) => Workflow.fromJson(w as Map<String, dynamic>))
          .toList();

      _replaceLoadingMessage(
        ChatMessage(
          role: 'assistant',
          content: content,
          recommendations: workflows,
        ),
      );
    } catch (e) {
      _replaceLoadingMessage(
        ChatMessage(
          role: 'assistant',
          content: 'Sorry, something went wrong. Please try again in a moment.',
        ),
      );
    }
  }

  void _replaceLoadingMessage(ChatMessage replacement) {
    final updated = [...state];
    final loadingIndex = updated.lastIndexWhere((m) => m.isLoading);
    if (loadingIndex != -1) {
      updated[loadingIndex] = replacement;
    } else {
      updated.add(replacement);
    }
    state = updated;
  }

  void clearChat() {
    state = [
      ChatMessage(
        role: 'assistant',
        content:
            "Hi! I'm your FlowMarket AI Assistant. Tell me what you want to automate and I'll find the perfect workflow for you.",
      ),
    ];
  }
}
