import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HyperTradeApiService {
  static const String _baseUrl = 'https://hypertrade-api.pseudoyu.com';

  /// Get user information from HyperTrade API
  static Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
    debugPrint('🌐 [HyperTradeApiService] Starting getUserInfo...');
    debugPrint('🌐 [HyperTradeApiService] Base URL: $_baseUrl');

    final Uri url = Uri.parse('$_baseUrl/users/me');
    debugPrint('🌐 [HyperTradeApiService] Full URL: $url');
    debugPrint('🌐 [HyperTradeApiService] Access token length: ${accessToken.length}');
    debugPrint('🌐 [HyperTradeApiService] Access token preview: ${accessToken.substring(0, accessToken.length.clamp(0, 20))}...');

    try {
      debugPrint('🌐 [HyperTradeApiService] Making HTTP GET request...');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      debugPrint('🌐 [HyperTradeApiService] Request headers: $headers');

      final response = await http.get(url, headers: headers);

      debugPrint('🌐 [HyperTradeApiService] Response received');
      debugPrint('🌐 [HyperTradeApiService] Status code: ${response.statusCode}');
      debugPrint('🌐 [HyperTradeApiService] Response headers: ${response.headers}');
      debugPrint('🌐 [HyperTradeApiService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('✅ [HyperTradeApiService] Success! Parsing JSON...');
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [HyperTradeApiService] Parsed JSON keys: ${jsonData.keys.toList()}');
        return jsonData;
      } else {
        debugPrint('❌ [HyperTradeApiService] HTTP Error - Status: ${response.statusCode}');
        debugPrint('❌ [HyperTradeApiService] Error body: ${response.body}');
        throw Exception(
          'Failed to get user info. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('💥 [HyperTradeApiService] Exception occurred: $e');
      debugPrint('💥 [HyperTradeApiService] Exception type: ${e.runtimeType}');
      throw Exception('Error fetching user info from HyperTrade: $e');
    }
  }
}