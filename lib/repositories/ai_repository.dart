import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../core/network/exceptions/api_exception.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref.read(apiServiceProvider));
});

class AiRepository {
  AiRepository(this._api);

  final ApiService _api;

  Future<Map<String, dynamic>> recommend({
    required String message,
    required List<Map<String, String>> history,
  }) async {
    try {
      final response = await _api.recommendAi({
        'message': message,
        'history': history,
      });
      final responseMap = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{};
      final data = responseMap['data'] is Map<String, dynamic>
          ? responseMap['data'] as Map<String, dynamic>
          : responseMap;
      final recommendationsRaw = data['recommendations'];
      final recommendations = recommendationsRaw is List
          ? recommendationsRaw.cast<Map<String, dynamic>>()
          : <Map<String, dynamic>>[];
      return {
        'message': data['message'] as String? ?? '',
        'recommendations': recommendations,
      };
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : const ApiException(message: 'Failed to get AI recommendations');
    }
  }
}
