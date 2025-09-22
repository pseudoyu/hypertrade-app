import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class HyperPriceProvider with ChangeNotifier {
  List<dynamic> _tokens = [];
  bool _loading = true;
  String? _error;
  DateTime? _lastUpdate;
  late final Timer _refreshTimer;

  List<dynamic> get tokens => _tokens;
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastUpdate => _lastUpdate;

  HyperPriceProvider() {
    fetchSpotData();
    // 每15秒自动刷新
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      fetchSpotData();
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  Future<void> fetchSpotData() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      // 获取现货价格数据
      final response = await http
          .get(Uri.parse('https://hyper-price-six.vercel.app/api/spots'));

      if (!response.statusCode.toString().startsWith('2')) {
        throw Exception('Failed to fetch spot prices');
      }

      final data = jsonDecode(response.body);

      if (data['success'] != true || data['data'] == null) {
        throw Exception('Invalid response format');
      }

      // 更新数据
      _tokens = data['data'];
      _lastUpdate = DateTime.now();
      _loading = false;
      notifyListeners();
    } catch (err) {
      _error = err.toString();
      _loading = false;
      notifyListeners();
    }
  }
}
