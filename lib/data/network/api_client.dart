import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Retrofit-style API client using Dio
/// Handles all HTTP requests with interceptors and error handling
class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator
  // For iOS simulator: 'http://localhost:3000/api'
  // For production: 'https://your-backend.com/api'
  
  late final Dio _dio;
  
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors
    _dio.interceptors.add(_createInterceptor());
  }
  
  /// Create logging and error interceptor
  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('🚀 REQUEST[${options.method}] => ${options.path}');
        debugPrint('📦 Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
        debugPrint('Error message: ${error.message}');
        return handler.next(error);
      },
    );
  }
  
  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handle Dio errors
  Exception _handleError(DioException error) {
    String message = 'An error occurred';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      default:
        message = 'Network error. Please try again.';
    }
    
    return ApiException(message);
  }
  
  /// Handle HTTP status codes
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error';
      default:
        return 'An error occurred';
    }
  }
}

/// Custom API exception
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

