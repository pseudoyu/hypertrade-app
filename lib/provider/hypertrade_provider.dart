import 'package:flutter/foundation.dart';
import 'package:hyper_app/helper/hypertrade_api_service.dart';
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/models/hypertrade_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HyperTradeProvider with ChangeNotifier {
  HyperTradeUser? _hyperTradeUser;
  bool _isLoading = false;
  String? _error;

  HyperTradeUser? get hyperTradeUser => _hyperTradeUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch HyperTrade user information using Privy access token
  Future<void> fetchHyperTradeUserInfo() async {
    debugPrint('🚀 [HyperTradeProvider] Starting fetchHyperTradeUserInfo...');

    _isLoading = true;
    _error = null;
    notifyListeners();
    debugPrint('🚀 [HyperTradeProvider] State updated: isLoading=true, error=null');

    try {
      debugPrint('🚀 [HyperTradeProvider] Getting access token...');

      // Get access token from storage service (with auto-refresh)
      final accessToken = await TokenStorageService.getPrivyToken();

      if (accessToken == null) {
        debugPrint('❌ [HyperTradeProvider] Access token is null!');
        _error = 'No authentication token available. Please login again.';
        debugPrint('❌ [HyperTradeProvider] Error set: $_error');
        return;
      }

      debugPrint('✅ [HyperTradeProvider] Access token received, length: ${accessToken.length}');
      debugPrint('🚀 [HyperTradeProvider] Calling HyperTrade API...');

      // Try to fetch user info, with automatic registration if user doesn't exist
      final userInfoResponse = await _fetchUserInfoWithRegistration(accessToken);

      debugPrint('✅ [HyperTradeProvider] API response received');
      debugPrint('✅ [HyperTradeProvider] Response keys: ${userInfoResponse.keys.toList()}');

      _hyperTradeUser = HyperTradeUser.fromJson(userInfoResponse);
      debugPrint('✅ [HyperTradeProvider] HyperTradeUser created successfully');
      debugPrint('✅ [HyperTradeProvider] User ID: ${_hyperTradeUser?.id}');
      debugPrint('✅ [HyperTradeProvider] Privy ID: ${_hyperTradeUser?.privyId}');
      debugPrint('✅ [HyperTradeProvider] Created at: ${_hyperTradeUser?.createdAt}');
      debugPrint('✅ [HyperTradeProvider] Full user: $_hyperTradeUser');

    } catch (e) {
      debugPrint('💥 [HyperTradeProvider] Exception occurred: $e');
      debugPrint('💥 [HyperTradeProvider] Exception type: ${e.runtimeType}');

      // Provide user-friendly error messages
      if (e.toString().contains('Invalid token')) {
        _error = 'Authentication failed. Please logout and login again.';
      } else if (e.toString().contains('Failed to register user')) {
        _error = 'Account setup failed. Please try again later.';
      } else {
        _error = 'Unable to load profile data. Please check your connection and try again.';
      }

      debugPrint('💥 [HyperTradeProvider] User-friendly error set: $_error');
    } finally {
      _isLoading = false;
      debugPrint('🚀 [HyperTradeProvider] Finally block: isLoading=false');
      debugPrint('🚀 [HyperTradeProvider] Final state - isLoading: $_isLoading, error: $_error, user: ${_hyperTradeUser != null ? 'exists' : 'null'}');
      notifyListeners();
      debugPrint('🚀 [HyperTradeProvider] notifyListeners() called');
    }
  }

  /// Clear user data (for logout)
  Future<void> clearUserData() async {
    debugPrint('🧹 [HyperTradeProvider] Clearing user data...');
    _hyperTradeUser = null;
    _error = null;
    _isLoading = false;

    // Clear stored token
    await TokenStorageService.clearToken();

    debugPrint('🧹 [HyperTradeProvider] Data cleared, notifying listeners...');
    notifyListeners();
  }

  /// Retry fetching user info
  Future<void> retry() async {
    debugPrint('🔄 [HyperTradeProvider] Retry requested, calling fetchHyperTradeUserInfo...');
    await fetchHyperTradeUserInfo();
  }

  /// Fetch user info with automatic registration if user doesn't exist
  Future<Map<String, dynamic>> _fetchUserInfoWithRegistration(String accessToken) async {
    try {
      // First attempt: try to get user info
      return await HyperTradeApiService.getUserInfo(accessToken);
    } catch (e) {
      debugPrint('⚠️ [HyperTradeProvider] First attempt failed: $e');

      // If it's an "Invalid token" or 401/400 error, try to register the user first
      if (e.toString().contains('Invalid token') ||
          e.toString().contains('400') ||
          e.toString().contains('401')) {
        debugPrint('👥 [HyperTradeProvider] Attempting user registration...');

        final registrationSuccess = await _registerUser(accessToken);

        if (registrationSuccess) {
          debugPrint('✅ [HyperTradeProvider] User registration successful, retrying getUserInfo...');
          // Retry getting user info after successful registration
          return await HyperTradeApiService.getUserInfo(accessToken);
        } else {
          debugPrint('❌ [HyperTradeProvider] User registration failed');
          throw Exception('Failed to register user with HyperTrade API');
        }
      }

      // Re-throw other errors
      rethrow;
    }
  }

  /// Register user with HyperTrade API
  Future<bool> _registerUser(String accessToken) async {
    try {
      debugPrint('👥 [HyperTradeProvider] Attempting to register user with HyperTrade API...');

      const baseUrl = 'https://hypertrade-api.pseudoyu.com';

      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({}), // Empty body for user creation
      );

      debugPrint('👥 [HyperTradeProvider] Registration response status: ${response.statusCode}');
      debugPrint('👥 [HyperTradeProvider] Registration response body: ${response.body}');

      // Accept 200 (success), 201 (created), and 409 (already exists)
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 409) {
        debugPrint('✅ [HyperTradeProvider] User registration/verification successful');
        return true;
      }

      debugPrint('❌ [HyperTradeProvider] Unexpected registration response: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('💥 [HyperTradeProvider] User registration exception: $e');
      return false;
    }
  }
}