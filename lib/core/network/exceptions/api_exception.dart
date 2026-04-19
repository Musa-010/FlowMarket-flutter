class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';

  factory ApiException.fromStatusCode(int statusCode, [dynamic data]) {
    final message = switch (statusCode) {
      400 => 'Bad request. Please check your input.',
      401 => 'Session expired. Please sign in again.',
      403 => 'You don\'t have permission to do this.',
      404 => 'The requested resource was not found.',
      409 => 'This resource already exists.',
      422 => 'Invalid data provided.',
      429 => 'Too many requests. Please try again later.',
      >= 500 => 'Server error. Please try again later.',
      _ => 'Something went wrong.',
    };
    return ApiException(message: message, statusCode: statusCode, data: data);
  }
}
