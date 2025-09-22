import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/models/hypertrade_user.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // final String _baseUrl = 'http://0.0.0.0:8006/api';
  final String _baseUrl = 'https://vc-api.d1v.xyz/api';

  Future<Map<String, dynamic>> get(String endpoint) async {
    final Uri url = _buildUrl(endpoint);
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );
    _checkResponse(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final Uri url = _buildUrl(endpoint);
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: json.encode(body),
    );
    _checkResponse(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final Uri url = _buildUrl(endpoint);
    final response = await http.put(
      url,
      headers: await _getHeaders(),
      body: json.encode(body),
    );
    _checkResponse(response);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<void> delete(String endpoint) async {
    final Uri url = _buildUrl(endpoint);
    final response = await http.delete(
      url,
      headers: await _getHeaders(),
    );
    _checkResponse(response);
  }

  /// Fetch current user's hypertrade information
  Future<HyperTradeUser?> getHypertradeUser() async {
    try {
      debugPrint('🌐 [ApiService] Fetching HyperTrade user...');

      String? privyToken = await TokenStorageService.getPrivyToken();
      if (privyToken == null) {
        debugPrint('❌ [ApiService] No Privy token available');
        return null;
      }

      debugPrint('🔑 [ApiService] Using token: ${privyToken.substring(0, privyToken.length.clamp(0, 20))}...');

      final response = await http.get(
        Uri.parse('$_baseUrl/users/me'),
        headers: await _getHeaders(),
      );

      debugPrint('📡 [ApiService] Response status: ${response.statusCode}');
      debugPrint('📡 [ApiService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return HyperTradeUser.fromJson(data);
      } else if (response.statusCode == 401) {
        debugPrint('🔐 [ApiService] Unauthorized - token may be expired, attempting refresh...');
        await TokenStorageService.clearToken();

        // Try one more time with fresh token
        final freshToken = await TokenStorageService.getPrivyToken();
        if (freshToken != null) {
          debugPrint('🔄 [ApiService] Retrying with fresh token...');
          final retryResponse = await http.get(
            Uri.parse('$_baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $freshToken',
            },
          );

          if (retryResponse.statusCode == 200) {
            debugPrint('✅ [ApiService] Success with fresh token!');
            final data = json.decode(retryResponse.body) as Map<String, dynamic>;
            return HyperTradeUser.fromJson(data);
          } else {
            debugPrint('❌ [ApiService] Still failing with fresh token: ${retryResponse.statusCode} - ${retryResponse.body}');
          }
        }
        return null;
      } else if (response.statusCode == 400 && response.body.contains('Invalid token')) {
        debugPrint('👥 [ApiService] Invalid token error - attempting user registration...');

        // Try to register user first, then retry
        final registrationSuccess = await _registerUserWithHyperTrade();
        if (registrationSuccess) {
          debugPrint('✅ [ApiService] User registration successful, retrying...');
          final retryResponse = await http.get(
            Uri.parse('$_baseUrl/users/me'),
            headers: await _getHeaders(),
          );

          if (retryResponse.statusCode == 200) {
            debugPrint('✅ [ApiService] Success after registration!');
            final data = json.decode(retryResponse.body) as Map<String, dynamic>;
            return HyperTradeUser.fromJson(data);
          }
        }
        debugPrint('❌ [ApiService] Registration failed or retry still failed');
        return null;
      } else {
        debugPrint('❌ [ApiService] API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 [ApiService] Exception in getHypertradeUser: $e');
      return null;
    }
  }

  // Helper method to generate headers with Authorization token
  Future<Map<String, String>> _getHeaders() async {
    // Try to get Privy token first
    String? privyToken = await TokenStorageService.getPrivyToken();

    if (privyToken != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $privyToken',
      };
    }

    // Fallback to old user_token for backward compatibility
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? legacyToken = prefs.getString('user_token');

    if (legacyToken != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $legacyToken',
      };
    }

    return {
      'Content-Type': 'application/json',
    };
  }

  /// Register user with HyperTrade API if not exists
  Future<bool> _registerUserWithHyperTrade() async {
    try {
      debugPrint('👥 [ApiService] Attempting user registration with HyperTrade API...');

      String? privyToken = await TokenStorageService.getPrivyToken();
      if (privyToken == null) {
        debugPrint('❌ [ApiService] No token available for registration');
        return false;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $privyToken',
        },
        body: json.encode({}), // Empty body for user creation
      );

      debugPrint('👥 [ApiService] Registration response: ${response.statusCode}');
      debugPrint('👥 [ApiService] Registration body: ${response.body}');

      // Accept both 200 (success), 201 (created), and 409 (already exists)
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 409) {
        debugPrint('✅ [ApiService] User registration/verification successful');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('💥 [ApiService] User registration failed: $e');
      return false;
    }
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Parse error response for better debugging
      String errorMessage = 'HTTP ${response.statusCode}';
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map && errorData.containsKey('error')) {
          errorMessage = errorData['error'].toString();
        } else if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'].toString();
        }
      } catch (e) {
        errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
      }

      throw Exception(
          'API request failed with status ${response.statusCode}: $errorMessage');
    }
  }

  // Helper method to build the URL based on the endpoint
  Uri _buildUrl(String endpoint) {
    // Check if the endpoint starts with 'http'
    if (endpoint.startsWith('http')) {
      return Uri.parse(endpoint);
    } else {
      return Uri.parse('$_baseUrl$endpoint');
    }
  }
}

class HttpService {
  static Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  static Future<dynamic> post(String url,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not found');
      case 500:
        throw Exception('Internal server error');
      default:
        throw Exception('An error occurred: ${response.statusCode}');
    }
  }
}
