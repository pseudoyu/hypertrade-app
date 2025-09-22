class StrategyModel {
  final int id;
  final String name;
  final String strategyType;
  final String status;
  final Map<String, dynamic>? config;
  final double? capitalAllocated;
  final double? dailyPnl;
  final double? totalPnl;
  final double? sharpeRatio;
  final double? maxDrawdown;
  final double? averageLatencyMs;
  final int? totalTrades;
  final int? successfulTrades;
  final String? createdAt;
  final String? updatedAt;

  const StrategyModel({
    required this.id,
    required this.name,
    required this.strategyType,
    required this.status,
    this.config,
    this.capitalAllocated,
    this.dailyPnl,
    this.totalPnl,
    this.sharpeRatio,
    this.maxDrawdown,
    this.averageLatencyMs,
    this.totalTrades,
    this.successfulTrades,
    this.createdAt,
    this.updatedAt,
  });

  factory StrategyModel.fromJson(Map<String, dynamic> json) {
    return StrategyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      strategyType: json['strategy_type'] as String,
      status: json['status'] as String,
      config: (json['config'] as Map<String, dynamic>?),
      capitalAllocated: _parseNullableDouble(json['capital_allocated']),
      dailyPnl: _parseNullableDouble(json['daily_pnl']),
      totalPnl: _parseNullableDouble(json['total_pnl']),
      sharpeRatio: _parseNullableDouble(json['sharpe_ratio']),
      maxDrawdown: _parseNullableDouble(json['max_drawdown']),
      averageLatencyMs: _parseNullableDouble(json['average_latency_ms']),
      totalTrades: _parseNullableInt(json['total_trades']),
      successfulTrades: _parseNullableInt(json['successful_trades']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class StrategiesListResponse {
  final List<StrategyModel> strategies;
  final int totalCount;

  const StrategiesListResponse({
    required this.strategies,
    required this.totalCount,
  });

  factory StrategiesListResponse.fromJson(Map<String, dynamic> json) {
    return StrategiesListResponse(
      strategies: (json['strategies'] as List<dynamic>?)
              ?.map((item) =>
                  StrategyModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      totalCount: json['total_count'] as int? ?? 0,
    );
  }
}

class StrategyExecutionsResponse {
  final int strategyId;
  final String strategyName;
  final List<StrategyExecution> executions;
  final int totalCount;
  final String? lastExecution;

  const StrategyExecutionsResponse({
    required this.strategyId,
    required this.strategyName,
    required this.executions,
    required this.totalCount,
    this.lastExecution,
  });

  factory StrategyExecutionsResponse.fromJson(Map<String, dynamic> json) {
    return StrategyExecutionsResponse(
      strategyId: json['strategy_id'] as int,
      strategyName: json['strategy_name'] as String,
      executions: (json['executions'] as List<dynamic>?)
              ?.map(
                (item) => StrategyExecution.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      totalCount: json['total_count'] as int? ?? 0,
      lastExecution: json['last_execution'] as String?,
    );
  }
}

class StrategyExecution {
  final String id;
  final String coin;
  final double spotPrice;
  final double perpPrice;
  final double spreadPct;
  final double spreadBasisPoints;
  final String executionStatus;
  final String? fundingRate;
  final String? errorMessage;
  final String? spotOrderId;
  final String? perpOrderId;
  final int? latencyMs;
  final double? pnl;
  final double? feesPaid;
  final double? liquiditySpot;
  final double? liquidityPerp;
  final double? slippageExperienced;
  final double? takerFeeRate;
  final String? createdAt;
  final String? completedAt;

  const StrategyExecution({
    required this.id,
    required this.coin,
    required this.spotPrice,
    required this.perpPrice,
    required this.spreadPct,
    required this.spreadBasisPoints,
    required this.executionStatus,
    this.fundingRate,
    this.errorMessage,
    this.spotOrderId,
    this.perpOrderId,
    this.latencyMs,
    this.pnl,
    this.feesPaid,
    this.liquiditySpot,
    this.liquidityPerp,
    this.slippageExperienced,
    this.takerFeeRate,
    this.createdAt,
    this.completedAt,
  });

  factory StrategyExecution.fromJson(Map<String, dynamic> json) {
    return StrategyExecution(
      id: json['id'] as String,
      coin: json['coin'] as String,
      spotPrice: _parseNullableDouble(json['spot_price']) ?? 0,
      perpPrice: _parseNullableDouble(json['perp_price']) ?? 0,
      spreadPct: _parseNullableDouble(json['spread_pct']) ?? 0,
      spreadBasisPoints: _parseNullableDouble(json['spread_basis_points']) ?? 0,
      executionStatus: json['execution_status'] as String,
      fundingRate: json['funding_rate'] as String?,
      errorMessage: json['error_message'] as String?,
      spotOrderId: json['spot_order_id'] as String?,
      perpOrderId: json['perp_order_id'] as String?,
      latencyMs: _parseNullableInt(json['latency_ms']),
      pnl: _parseNullableDouble(json['pnl']),
      feesPaid: _parseNullableDouble(json['fees_paid']),
      liquiditySpot: _parseNullableDouble(json['liquidity_spot']),
      liquidityPerp: _parseNullableDouble(json['liquidity_perp']),
      slippageExperienced: _parseNullableDouble(json['slippage_experienced']),
      takerFeeRate: _parseNullableDouble(json['taker_fee_rate']),
      createdAt: json['created_at'] as String?,
      completedAt: json['completed_at'] as String?,
    );
  }
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
