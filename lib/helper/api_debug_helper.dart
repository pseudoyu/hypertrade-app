import 'package:flutter/foundation.dart';
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';
import 'package:http/http.dart' as http;

class ApiDebugHelper {
  static const String _baseUrl = 'https://hypertrade-api.pseudoyu.com';

  /// Comprehensive token and authentication debugging
  static Future<Map<String, dynamic>> debugAuthentication() async {
    debugPrint('🔍 [ApiDebug] Starting comprehensive authentication debug...');

    final Map<String, dynamic> debugInfo = {};

    try {
      // 1. Check token storage info
      final tokenInfo = await TokenStorageService.getTokenInfo();
      debugInfo['tokenStorageInfo'] = tokenInfo;
      debugPrint('🔍 [ApiDebug] Token storage info: $tokenInfo');

      // 2. Check Privy state
      try {
        final isInitialized = privyManager.isInitialized;
        debugInfo['privyInitialized'] = isInitialized;
        debugPrint('🔍 [ApiDebug] Privy initialized: $isInitialized');

        if (isInitialized) {
          final privyUser = privyManager.privy.user;
          debugInfo['privyUserExists'] = privyUser != null;
          if (privyUser != null) {
            debugInfo['privyUserId'] = privyUser.id;
          }
          debugPrint('🔍 [ApiDebug] Privy user: ${privyUser?.id ?? "none"}');
        }
      } catch (e) {
        debugInfo['privyStateError'] = e.toString();
        debugPrint('❌ [ApiDebug] Error getting Privy state: $e');
      }

      // 3. Try to get fresh token from Privy
      try {
        final freshToken = await privyManager.getAccessToken();
        if (freshToken != null) {
          debugInfo['freshTokenAvailable'] = true;
          debugInfo['freshTokenLength'] = freshToken.length;
          debugInfo['freshTokenPreview'] = freshToken.substring(0, freshToken.length.clamp(0, 20));
          debugPrint('✅ [ApiDebug] Fresh token available: ${freshToken.length} chars');
        } else {
          debugInfo['freshTokenAvailable'] = false;
          debugPrint('❌ [ApiDebug] No fresh token available from Privy');
        }
      } catch (e) {
        debugInfo['freshTokenError'] = e.toString();
        debugPrint('❌ [ApiDebug] Error getting fresh token: $e');
      }

      // 4. Test API connectivity (without auth)
      try {
        final response = await http.get(Uri.parse('$_baseUrl/prices/coins'));
        debugInfo['apiConnectivity'] = {
          'statusCode': response.statusCode,
          'accessible': response.statusCode == 200,
        };
        debugPrint('🌐 [ApiDebug] API connectivity test: ${response.statusCode}');
      } catch (e) {
        debugInfo['apiConnectivityError'] = e.toString();
        debugPrint('❌ [ApiDebug] API connectivity error: $e');
      }

      // 5. Test authenticated endpoint with current token
      try {
        final currentToken = await TokenStorageService.getPrivyToken();
        if (currentToken != null) {
          final response = await http.get(
            Uri.parse('$_baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $currentToken',
            },
          );
          debugInfo['authEndpointTest'] = {
            'statusCode': response.statusCode,
            'responseBody': response.body,
            'success': response.statusCode == 200,
          };
          debugPrint('🔐 [ApiDebug] Auth endpoint test: ${response.statusCode} - ${response.body}');
        } else {
          debugInfo['authEndpointTest'] = {'error': 'No token available for test'};
        }
      } catch (e) {
        debugInfo['authEndpointTestError'] = e.toString();
        debugPrint('❌ [ApiDebug] Auth endpoint test error: $e');
      }

    } catch (e) {
      debugInfo['debugError'] = e.toString();
      debugPrint('💥 [ApiDebug] Debug process error: $e');
    }

    debugPrint('🔍 [ApiDebug] Complete debug info: $debugInfo');
    return debugInfo;
  }

  /// Test token validity by making a simple authenticated request
  static Future<bool> testTokenValidity([String? token]) async {
    debugPrint('🧪 [ApiDebug] Testing token validity...');

    try {
      final testToken = token ?? await TokenStorageService.getPrivyToken();
      if (testToken == null) {
        debugPrint('❌ [ApiDebug] No token to test');
        return false;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $testToken',
        },
      );

      debugPrint('🧪 [ApiDebug] Token test result: ${response.statusCode}');
      debugPrint('🧪 [ApiDebug] Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ [ApiDebug] Token test error: $e');
      return false;
    }
  }

  /// Force refresh authentication state
  static Future<String?> forceRefreshToken() async {
    debugPrint('🔄 [ApiDebug] Force refreshing token...');

    try {
      // Clear existing tokens
      await TokenStorageService.clearToken();

      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));

      // Get fresh token from Privy
      final freshToken = await privyManager.getAccessToken();

      if (freshToken != null) {
        await TokenStorageService.storePrivyToken(freshToken);
        debugPrint('✅ [ApiDebug] Successfully refreshed token');
        return freshToken;
      } else {
        debugPrint('❌ [ApiDebug] Failed to get fresh token');
        return null;
      }
    } catch (e) {
      debugPrint('❌ [ApiDebug] Token refresh error: $e');
      return null;
    }
  }
}
