import 'dart:developer';

class ApiErrorResponse {
  final int status;
  final String message;
  final Map<String, dynamic>? data;

  ApiErrorResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      status: json['status'] ?? 500,
      message: json['message'] ?? 'An error occurred',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  // Get validation errors as a list of strings
  List<String> getValidationErrors() {
    if (data == null) {
      log('ApiErrorResponse: data is null');
      return [];
    }
    
    log('ApiErrorResponse: data = $data');
    final errors = <String>[];
    data!.forEach((key, value) {
      log('ApiErrorResponse: key=$key, value=$value, type=${value.runtimeType}');
      if (value is List) {
        errors.addAll(value.map((e) => e.toString()));
      } else {
        errors.add(value.toString());
      }
    });
    log('ApiErrorResponse: errors = $errors');
    return errors;
  }

  // Get first validation error
  String getFirstValidationError() {
    log('getFirstValidationError called');
    final errors = getValidationErrors();
    log('getFirstValidationError: errors = $errors');
    if (errors.isNotEmpty) {
      log('getFirstValidationError: returning first error = ${errors.first}');
      return errors.first;
    }
    log('getFirstValidationError: no errors, returning message = $message');
    return message.isNotEmpty ? message : 'An error occurred';
  }

  // Get all validation errors as a single string
  String getAllValidationErrors() {
    final errors = getValidationErrors();
    if (errors.isNotEmpty) {
      return errors.join('\n');
    }
    return message.isNotEmpty ? message : 'An error occurred';
  }

  @override
  String toString() {
    return 'ApiErrorResponse(status: $status, message: $message, data: $data)';
  }
}
