import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/models/wallet_models.dart';

class WalletService {
  static const String _baseUrl = 'https://hypertrade-api.pseudoyu.com';

  static Future<Map<String, String>> _getHeaders() async {
    String? privyToken = await TokenStorageService.getPrivyToken();

    debugPrint('🔑 [WalletService] Getting headers with token: ${privyToken != null ? '${privyToken.substring(0, privyToken.length.clamp(0, 20))}...' : 'null'}');

    return {
      'Content-Type': 'application/json',
      if (privyToken != null) 'Authorization': 'Bearer $privyToken',
    };
  }

  static Future<void> _checkResponse(http.Response response) async {
    debugPrint('📡 [WalletService] Response status: ${response.statusCode}');
    debugPrint('📡 [WalletService] Response body: ${response.body}');

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

      // Handle authentication errors with token refresh retry
      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('🔐 [WalletService] Authentication error - attempting token refresh');
        await TokenStorageService.clearToken();
        // Note: The calling code should handle retry logic
      }

      throw Exception(
        'API request failed with status ${response.statusCode}: $errorMessage',
      );
    }
  }

  /// Get all wallets for the current user
  static Future<List<UserWallet>> getWallets() async {
    final response = await getWalletsResponse();
    return response.wallets;
  }

  /// Get complete wallets response for the current user with automatic retry on auth failure
  static Future<UserWalletsResponse> getWalletsResponse() async {
    return await _makeAuthenticatedRequest<UserWalletsResponse>(
      'GET',
      '/wallets',
      (data) => UserWalletsResponse.fromJson(data),
      'fetch wallets',
    );
  }

  /// Generic method for authenticated requests with automatic token refresh retry
  static Future<T> _makeAuthenticatedRequest<T>(
    String method,
    String endpoint,
    T Function(Map<String, dynamic>) parser,
    String operation, {
    Map<String, dynamic>? body,
  }) async {
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        debugPrint('🌐 [WalletService] ${operation.toUpperCase()} attempt ${attempt + 1}...');

        final headers = await _getHeaders();
        debugPrint('🔑 [WalletService] Request headers: $headers');

        late http.Response response;
        final uri = Uri.parse('$_baseUrl$endpoint');

        switch (method.toUpperCase()) {
          case 'GET':
            response = await http.get(uri, headers: headers);
            break;
          case 'POST':
            response = await http.post(uri, headers: headers, body: body != null ? json.encode(body) : null);
            break;
          case 'PUT':
            response = await http.put(uri, headers: headers, body: body != null ? json.encode(body) : null);
            break;
          case 'DELETE':
            response = await http.delete(uri, headers: headers);
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        await _checkResponse(response);

        final data = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [WalletService] Successfully completed $operation');
        return parser(data);
      } catch (e) {
        debugPrint('💥 [WalletService] $operation failed on attempt ${attempt + 1}: $e');

        // If it's an auth error (400 with Invalid token or 401), try user registration first
        if (attempt == 0 && (e.toString().contains('401') || e.toString().contains('Invalid token'))) {
          debugPrint('🔄 [WalletService] Auth error detected, attempting user registration...');
          
          // Try to register user with HyperTrade API first
          final registerSuccess = await _registerUserIfNeeded();
          if (registerSuccess) {
            debugPrint('✅ [WalletService] User registration successful, retrying...');
            continue; // Retry with same token after registration
          } else {
            // If registration fails, try refreshing token
            debugPrint('🔄 [WalletService] Registration failed, refreshing token...');
            await TokenStorageService.clearToken();
            final freshToken = await TokenStorageService.getPrivyToken();
            if (freshToken == null) {
              debugPrint('❌ [WalletService] Could not get fresh token, giving up');
              throw Exception('Authentication failed: Could not refresh token or register user');
            }
            continue; // Retry with fresh token
          }
        }

        // If it's the second attempt or not an auth error, give up
        throw Exception('Failed to $operation: $e');
      }
    }

    throw Exception('Failed to $operation after 2 attempts');
  }

  /// Add a new wallet to monitoring list
  static Future<UserWallet> addWallet(String address, {String? name}) async {
    final request = AddWalletRequest(address: address, name: name);
    return await _makeAuthenticatedRequest<UserWallet>(
      'POST',
      '/wallets',
      (data) => UserWallet.fromJson(data),
      'add wallet',
      body: request.toJson(),
    );
  }

  /// Update wallet name or active status
  static Future<UserWallet> updateWallet(
    String address, {
    String? name,
    bool? active,
  }) async {
    final request = UpdateWalletRequest(name: name, active: active);
    return await _makeAuthenticatedRequest<UserWallet>(
      'PUT',
      '/wallets/$address',
      (data) => UserWallet.fromJson(data),
      'update wallet',
      body: request.toJson(),
    );
  }

  /// Remove wallet from monitoring list
  static Future<void> deleteWallet(String address) async {
    await _makeAuthenticatedRequest<Map<String, dynamic>>(
      'DELETE',
      '/wallets/$address',
      (data) => data, // DELETE doesn't return meaningful data
      'delete wallet',
    );
  }

  /// Get detailed wallet information
  static Future<WalletDetailsResponse> getWalletDetails(String address) async {
    return await _makeAuthenticatedRequest<WalletDetailsResponse>(
      'GET',
      '/wallets/$address/details',
      (data) => WalletDetailsResponse.fromJson(data),
      'fetch wallet details',
    );
  }

  /// Get wallet analytics
  static Future<WalletAnalytics> getWalletAnalytics(String address) async {
    return await _makeAuthenticatedRequest<WalletAnalytics>(
      'GET',
      '/wallets/$address/analytics',
      (data) => WalletAnalytics.fromJson(data),
      'fetch wallet analytics',
    );
  }

  /// Get wallet spot balances
  static Future<WalletSpotResponse> getWalletSpotBalances(String address) async {
    return await _makeAuthenticatedRequest<WalletSpotResponse>(
      'GET',
      '/wallets/$address/spot',
      (data) => WalletSpotResponse.fromJson(data),
      'fetch wallet spot balances',
    );
  }

  /// Get wallet perpetual positions
  static Future<WalletPerpResponse> getWalletPerpPositions(String address) async {
    return await _makeAuthenticatedRequest<WalletPerpResponse>(
      'GET',
      '/wallets/$address/perp',
      (data) => WalletPerpResponse.fromJson(data),
      'fetch wallet perp positions',
    );
  }
  
  /// Register user with HyperTrade API if not exists
  static Future<bool> _registerUserIfNeeded() async {
    try {
      debugPrint('👥 [WalletService] Attempting user registration with HyperTrade API...');
      
      final headers = await _getHeaders();
      
      // Try to create/register user with POST to /users/me
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: headers,
        body: json.encode({}), // Empty body for user creation
      );
      
      debugPrint('👥 [WalletService] Registration response: ${response.statusCode}');
      debugPrint('👥 [WalletService] Registration body: ${response.body}');
      
      // Accept both 200 (success) and 201 (created) and 409 (already exists)
      if (response.statusCode == 200 || 
          response.statusCode == 201 || 
          response.statusCode == 409) {
        debugPrint('✅ [WalletService] User registration/verification successful');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('💥 [WalletService] User registration failed: $e');
      return false;
    }
  }
}