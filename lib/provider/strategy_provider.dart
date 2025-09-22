import 'package:flutter/foundation.dart';
import 'package:hyper_app/models/strategy_models.dart';
import 'package:hyper_app/services/strategy_service.dart';

class StrategyProvider extends ChangeNotifier {
  List<StrategyModel> _strategies = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _error;
  int _totalCount = 0;

  final Map<int, StrategyModel> _strategyDetails = {};
  final Map<String, StrategyExecutionsResponse> _executionsCache = {};

  List<StrategyModel> get strategies => _strategies;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;
  int get totalCount => _totalCount;

  int get activeStrategiesCount => _strategies
      .where((strategy) => strategy.status.toLowerCase() == 'active')
      .length;

  StrategyModel? getStrategy(int id) {
    if (_strategyDetails.containsKey(id)) {
      return _strategyDetails[id];
    }

    try {
      return _strategies.firstWhere((strategy) => strategy.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchStrategies({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_strategies.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await StrategyService.getStrategies();
      _strategies = response.strategies;
      _totalCount = response.totalCount;
      for (final strategy in response.strategies) {
        _strategyDetails[strategy.id] = strategy;
      }
    } catch (e) {
      debugPrint('💥 [StrategyProvider] Failed to load strategies: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStrategies() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      await fetchStrategies(forceRefresh: true);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<StrategyModel?> fetchStrategyDetail(int id,
      {bool forceRefresh = false}) async {
    if (!forceRefresh && _strategyDetails.containsKey(id)) {
      return _strategyDetails[id];
    }

    try {
      final detail = await StrategyService.getStrategyById(id);
      _strategyDetails[id] = detail;
      _strategies = _strategies
          .map((strategy) => strategy.id == id ? detail : strategy)
          .toList();
      notifyListeners();
      return detail;
    } catch (e) {
      debugPrint(
          '💥 [StrategyProvider] Failed to load strategy detail ($id): $e');
      return null;
    }
  }

  Future<StrategyExecutionsResponse?> fetchStrategyExecutions(
    int id, {
    int limit = 20,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '$id-$limit-$offset';
    if (!forceRefresh && _executionsCache.containsKey(cacheKey)) {
      return _executionsCache[cacheKey];
    }

    try {
      final response = await StrategyService.getStrategyExecutions(
        id,
        limit: limit,
        offset: offset,
      );
      _executionsCache[cacheKey] = response;
      return response;
    } catch (e) {
      debugPrint(
          '💥 [StrategyProvider] Failed to load strategy executions ($id): $e');
      return null;
    }
  }

  double? successRate(StrategyModel strategy) {
    if (strategy.totalTrades == null || strategy.totalTrades == 0) {
      return null;
    }
    final successes = strategy.successfulTrades ?? 0;
    return successes / strategy.totalTrades!;
  }

  String formatCurrency(double? value, {String symbol = '\$'}) {
    if (value == null) return '--';
    return '$symbol${value.toStringAsFixed(2)}';
  }

  String formatPercent(double? value, {int fractionDigits = 2}) {
    if (value == null) return '--';
    return '${(value * 100).toStringAsFixed(fractionDigits)}%';
  }
}
