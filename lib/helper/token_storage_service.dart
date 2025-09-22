import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';

class TokenStorageService {
  static const String _privyTokenKey = 'privy_access_token';
  static const String _tokenExpiryKey = 'privy_token_expiry';

  static String? _cachedToken;
  static DateTime? _cachedExpiry;

  /// Store Privy access token with expiry time
  static Future<void> storePrivyToken(String token) async {
    debugPrint('💾 [TokenStorage] Storing Privy access token...');

    try {
      final prefs = await SharedPreferences.getInstance();

      // Store the token
      await prefs.setString(_privyTokenKey, token);
      _cachedToken = token;

      // Based on server logs showing token expiration, reduce to 30 minutes for safety
      // JWT tokens from Privy seem to expire around 1 hour, but we'll be conservative
      final expiry = DateTime.now().add(const Duration(minutes: 30));
      await prefs.setString(_tokenExpiryKey, expiry.toIso8601String());
      _cachedExpiry = expiry;

      debugPrint('✅ [TokenStorage] Token stored successfully');
      debugPrint('✅ [TokenStorage] Token expiry: $expiry');

    } catch (e) {
      debugPrint('💥 [TokenStorage] Error storing token: $e');
      rethrow;
    }
  }

  /// Get stored Privy access token, refresh if expired
  static Future<String?> getPrivyToken() async {
    debugPrint('🔑 [TokenStorage] Getting Privy access token...');

    try {
      // Check cached token first
      if (_cachedToken != null && _cachedExpiry != null) {
        // Check if token expires within next 5 minutes - proactively refresh
        final now = DateTime.now();
        final expiresWithinFiveMinutes = _cachedExpiry!.difference(now).inMinutes <= 5;

        if (now.isBefore(_cachedExpiry!) && !expiresWithinFiveMinutes) {
          debugPrint('✅ [TokenStorage] Using cached token (expires: $_cachedExpiry)');
          debugPrint('🔍 [TokenStorage] Token preview: ${_cachedToken!.substring(0, _cachedToken!.length.clamp(0, 20))}...');
          return _cachedToken;
        } else {
          if (expiresWithinFiveMinutes) {
            debugPrint('⚠️ [TokenStorage] Cached token expires within 5 minutes, refreshing proactively');
          } else {
            debugPrint('⏰ [TokenStorage] Cached token expired, clearing cache');
          }
          _cachedToken = null;
          _cachedExpiry = null;
        }
      }

      // Check stored token
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_privyTokenKey);
      final storedExpiryString = prefs.getString(_tokenExpiryKey);

      if (storedToken != null && storedExpiryString != null) {
        final storedExpiry = DateTime.parse(storedExpiryString);

        // Check if stored token expires within next 5 minutes - proactively refresh
        final now = DateTime.now();
        final expiresWithinFiveMinutes = storedExpiry.difference(now).inMinutes <= 5;

        if (now.isBefore(storedExpiry) && !expiresWithinFiveMinutes) {
          debugPrint('✅ [TokenStorage] Using stored token (expires: $storedExpiry)');
          debugPrint('🔍 [TokenStorage] Token preview: ${storedToken.substring(0, storedToken.length.clamp(0, 20))}...');
          debugPrint('🔍 [TokenStorage] Token length: ${storedToken.length}');
          _cachedToken = storedToken;
          _cachedExpiry = storedExpiry;
          return storedToken;
        } else {
          if (expiresWithinFiveMinutes) {
            debugPrint('⚠️ [TokenStorage] Stored token expires within 5 minutes, refreshing proactively');
          } else {
            debugPrint('⏰ [TokenStorage] Stored token expired, clearing storage');
          }
          await clearToken();
        }
      }

      // No valid token found, get fresh token from Privy
      debugPrint('🔄 [TokenStorage] No valid token found, getting fresh token from Privy...');
      final freshToken = await privyManager.getAccessToken();

      if (freshToken != null) {
        debugPrint('✅ [TokenStorage] Got fresh token from Privy');
        debugPrint('🔍 [TokenStorage] Fresh token preview: ${freshToken.substring(0, freshToken.length.clamp(0, 20))}...');
        debugPrint('🔍 [TokenStorage] Fresh token length: ${freshToken.length}');
        await storePrivyToken(freshToken);
        return freshToken;
      }

      debugPrint('❌ [TokenStorage] Failed to get fresh token from Privy');
      return null;

    } catch (e) {
      debugPrint('💥 [TokenStorage] Error getting token: $e');
      return null;
    }
  }

  /// Check if current token is valid (not expired)
  static Future<bool> isTokenValid() async {
    try {
      if (_cachedExpiry != null) {
        return DateTime.now().isBefore(_cachedExpiry!);
      }

      final prefs = await SharedPreferences.getInstance();
      final storedExpiryString = prefs.getString(_tokenExpiryKey);

      if (storedExpiryString != null) {
        final storedExpiry = DateTime.parse(storedExpiryString);
        return DateTime.now().isBefore(storedExpiry);
      }

      return false;
    } catch (e) {
      debugPrint('💥 [TokenStorage] Error checking token validity: $e');
      return false;
    }
  }

  /// Clear stored token (for logout)
  static Future<void> clearToken() async {
    debugPrint('🧹 [TokenStorage] Clearing stored token...');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_privyTokenKey);
      await prefs.remove(_tokenExpiryKey);

      _cachedToken = null;
      _cachedExpiry = null;

      debugPrint('✅ [TokenStorage] Token cleared successfully');
    } catch (e) {
      debugPrint('💥 [TokenStorage] Error clearing token: $e');
    }
  }

  /// Get token info for debugging
  static Future<Map<String, dynamic>> getTokenInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_privyTokenKey);
      final storedExpiryString = prefs.getString(_tokenExpiryKey);

      return {
        'hasStoredToken': storedToken != null,
        'hasCachedToken': _cachedToken != null,
        'tokenLength': storedToken?.length ?? 0,
        'expiry': storedExpiryString,
        'isValid': await isTokenValid(),
        'timeUntilExpiry': _cachedExpiry?.difference(DateTime.now()).inMinutes,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}