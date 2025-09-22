import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/models/strategy_models.dart';

class StrategyService {
  static const String _baseUrl = 'https://hypertrade-api.pseudoyu.com';

  static Future<Map<String, String>> _getHeaders() async {
    final privyToken = await TokenStorageService.getPrivyToken();
    debugPrint(
        '🔑 [StrategyService] Preparing headers; hasToken=${privyToken != null}');

    return {
      'Content-Type': 'application/json',
      if (privyToken != null) 'Authorization': 'Bearer $privyToken',
    };
  }

  static Future<void> _checkResponse(http.Response response) async {
    debugPrint('📡 [StrategyService] Response status: ${response.statusCode}');
    if (kDebugMode) {
      debugPrint('📡 [StrategyService] Response body: ${response.body}');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      var errorMessage = 'HTTP ${response.statusCode}';
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map<String, dynamic>) {
          if (errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'].toString();
          }
        }
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint(
            '🔐 [StrategyService] Auth error detected; clearing stored token');
        await TokenStorageService.clearToken();
      }

      throw Exception(
          'API request failed with status ${response.statusCode}: $errorMessage');
    }
  }

  static Future<T> _makeAuthenticatedRequest<T>(
    String method,
    String endpoint,
    T Function(Map<String, dynamic>) parser,
    String operation, {
    Map<String, dynamic>? body,
  }) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        debugPrint('🌐 [StrategyService] $operation attempt ${attempt + 1}');
        final headers = await _getHeaders();
        final uri = Uri.parse('$_baseUrl$endpoint');
        debugPrint('🌐 [StrategyService] Requesting $uri');

        late http.Response response;
        switch (method.toUpperCase()) {
          case 'GET':
            response = await http.get(uri, headers: headers);
            break;
          case 'POST':
            response = await http.post(uri,
                headers: headers,
                body: body != null ? json.encode(body) : null);
            break;
          case 'PUT':
            response = await http.put(uri,
                headers: headers,
                body: body != null ? json.encode(body) : null);
            break;
          case 'DELETE':
            response = await http.delete(uri, headers: headers);
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        await _checkResponse(response);
        final data = json.decode(response.body) as Map<String, dynamic>;
        return parser(data);
      } catch (e) {
        debugPrint(
            '💥 [StrategyService] $operation failed on attempt ${attempt + 1}: $e');
        final isAuthError = e.toString().contains('401') ||
            e.toString().contains('Invalid token');
        if (attempt == 0 && isAuthError) {
          debugPrint(
              '🔄 [StrategyService] Attempting user registration after auth error');
          final registered = await _registerUserIfNeeded();
          if (registered) {
            debugPrint('✅ [StrategyService] Registration succeeded, retrying');
            continue;
          }

          debugPrint(
              '🔄 [StrategyService] Clearing token and retrying after failure');
          await TokenStorageService.clearToken();
          continue;
        }
        rethrow;
      }
    }

    throw Exception('Failed to $operation after retry');
  }

  static Future<StrategiesListResponse> getStrategies() {
    return _makeAuthenticatedRequest<StrategiesListResponse>(
      'GET',
      '/strategies',
      (data) => StrategiesListResponse.fromJson(data),
      'fetch strategies',
    );
  }

  static Future<StrategyModel> getStrategyById(int id) {
    return _makeAuthenticatedRequest<StrategyModel>(
      'GET',
      '/strategies/$id',
      (data) => StrategyModel.fromJson(data),
      'fetch strategy detail',
    );
  }

  static Future<StrategyExecutionsResponse> getStrategyExecutions(
    int id, {
    int limit = 20,
    int offset = 0,
  }) {
    final endpoint = '/strategies/$id/executions?limit=$limit&offset=$offset';
    return _makeAuthenticatedRequest<StrategyExecutionsResponse>(
      'GET',
      endpoint,
      (data) => StrategyExecutionsResponse.fromJson(data),
      'fetch strategy executions',
    );
  }

  static Future<bool> _registerUserIfNeeded() async {
    try {
      debugPrint('👥 [StrategyService] Ensuring user exists on HyperTrade API');
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: headers,
        body: json.encode({}),
      );

      debugPrint(
          '👥 [StrategyService] Registration response: ${response.statusCode}');
      if (kDebugMode) {
        debugPrint('👥 [StrategyService] Registration body: ${response.body}');
      }

      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 409;
    } catch (e) {
      debugPrint('💥 [StrategyService] User registration failed: $e');
      return false;
    }
  }
}
