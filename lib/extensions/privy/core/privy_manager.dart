import 'package:flutter/material.dart';

import 'package:privy_flutter/privy_flutter.dart';

import '../config/env_config.dart';

/// A singleton class to manage the Privy initialization and instance
class PrivyManager {
  // Private constructor
  PrivyManager._();

  // Singleton instance
  static final PrivyManager _instance = PrivyManager._();

  // Factory constructor to return the singleton instance
  factory PrivyManager() => _instance;

  // Reference to the Privy SDK instance
  Privy? _privySdk;

  /// Getter to access the initialized Privy instance
  /// Throws an exception if accessed before initialization
  Privy get privy {
    if (_instance._privySdk == null) {
      throw Exception(
        'PrivyManager has not been initialized. Call initialize() first.',
      );
    }
    return _instance._privySdk!;
  }

  /// Whether the Privy SDK has been initialized
  bool get isInitialized => _privySdk != null;

  /// Initialize Privy with the credentials from env config
  void initializePrivy() {
    try {
      final privyConfig = PrivyConfig(
        appId: EnvConfig.privyAppId,
        appClientId: EnvConfig.privyClientId,
        logLevel: PrivyLogLevel.debug,
      );

      _privySdk = Privy.init(config: privyConfig);
      debugPrint('Privy SDK initialized');
    } catch (e, stack) {
      debugPrint('Privy initialization failed: $e\n$stack');
      rethrow;
    }
  }

  /// Get access token from authenticated user
  Future<String?> getAccessToken() async {
    debugPrint('🔑 [PrivyManager] Starting getAccessToken...');

    try {
      debugPrint('🔑 [PrivyManager] Checking if Privy is initialized: ${isInitialized}');

      final user = privy.user;
      debugPrint('🔑 [PrivyManager] Privy user: ${user != null ? 'Found' : 'Not found'}');

      if (user != null) {
        debugPrint('🔑 [PrivyManager] User ID: ${user.id}');
        debugPrint('🔑 [PrivyManager] Calling user.getAccessToken()...');

        final result = await user.getAccessToken();
        debugPrint('🔑 [PrivyManager] getAccessToken() completed, processing result...');

        String? token;
        result.fold(
          onFailure: (failure) {
            debugPrint('❌ [PrivyManager] Failed to get access token: $failure');
            debugPrint('❌ [PrivyManager] Failure type: ${failure.runtimeType}');
            token = null;
          },
          onSuccess: (successToken) {
            debugPrint('✅ [PrivyManager] Access token retrieved successfully');
            debugPrint('✅ [PrivyManager] Token length: ${successToken.length}');
            debugPrint('✅ [PrivyManager] Token preview: ${successToken.substring(0, successToken.length.clamp(0, 20))}...');
            token = successToken;
          },
        );

        debugPrint('🔑 [PrivyManager] Returning token: ${token != null ? 'Success' : 'Null'}');
        return token;
      }

      debugPrint('❌ [PrivyManager] No authenticated user found');
      return null;
    } catch (e, stack) {
      debugPrint('💥 [PrivyManager] Exception in getAccessToken: $e');
      debugPrint('💥 [PrivyManager] Stack trace: $stack');
      return null;
    }
  }
}

/// Convenient singleton accessor for Privy Manger instance
PrivyManager get privyManager => PrivyManager();
