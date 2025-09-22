class UserWallet {
  final String address;
  final bool active;
  final String? name;
  final double? totalValue;
  final String? updatedAt;

  UserWallet({
    required this.address,
    required this.active,
    this.name,
    this.totalValue,
    this.updatedAt,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) {
    return UserWallet(
      address: json['address'] as String,
      active: json['active'] as bool,
      name: json['name'] as String?,
      totalValue: (json['total_value'] as num?)?.toDouble(),
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'active': active,
      'name': name,
      'total_value': totalValue,
      'updated_at': updatedAt,
    };
  }

  UserWallet copyWith({
    String? address,
    bool? active,
    String? name,
    double? totalValue,
    String? updatedAt,
  }) {
    return UserWallet(
      address: address ?? this.address,
      active: active ?? this.active,
      name: name ?? this.name,
      totalValue: totalValue ?? this.totalValue,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserWalletsResponse {
  final int? userId;
  final List<UserWallet> wallets;
  final int totalCount;

  UserWalletsResponse({
    this.userId,
    required this.wallets,
    required this.totalCount,
  });

  factory UserWalletsResponse.fromJson(Map<String, dynamic> json) {
    return UserWalletsResponse(
      userId: json['user_id'] as int?,
      wallets: (json['wallets'] as List)
          .map((wallet) => UserWallet.fromJson(wallet))
          .toList(),
      totalCount: json['total_count'] as int,
    );
  }
}

class AddWalletRequest {
  final String address;
  final String? name;

  AddWalletRequest({
    required this.address,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      if (name != null) 'name': name,
    };
  }
}

class UpdateWalletRequest {
  final String? name;
  final bool? active;

  UpdateWalletRequest({
    this.name,
    this.active,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (active != null) data['active'] = active;
    return data;
  }
}

// Analytics endpoint response
class WalletAnalytics {
  final String walletAddress;
  final int totalSpotBalanceCount;
  final int totalPerpPositions;
  final int totalPerpOrders;
  final int activePerpOrders;
  final double totalSpotValueUsd;
  final String? lastActivity;

  WalletAnalytics({
    required this.walletAddress,
    required this.totalSpotBalanceCount,
    required this.totalPerpPositions,
    required this.totalPerpOrders,
    required this.activePerpOrders,
    required this.totalSpotValueUsd,
    this.lastActivity,
  });

  factory WalletAnalytics.fromJson(Map<String, dynamic> json) {
    return WalletAnalytics(
      walletAddress: json['wallet_address'] as String,
      totalSpotBalanceCount: json['total_spot_balance_count'] as int,
      totalPerpPositions: json['total_perp_positions'] as int,
      totalPerpOrders: json['total_perp_orders'] as int,
      activePerpOrders: json['active_perp_orders'] as int,
      totalSpotValueUsd: (json['total_spot_value_usd'] as num).toDouble(),
      lastActivity: json['last_activity'] as String?,
    );
  }
}

// Details endpoint response
class WalletDetailsResponse {
  final String walletAddress;
  final double spotBalance;
  final double perpBalance;
  final double totalBalance;
  final double totalMarginUsed;
  final double totalNtlPos;
  final double withdrawable;
  final int spotBalancesCount;
  final int perpPositionsCount;
  final int perpOrdersCount;
  final String createdAt;
  final String updatedAt;

  WalletDetailsResponse({
    required this.walletAddress,
    required this.spotBalance,
    required this.perpBalance,
    required this.totalBalance,
    required this.totalMarginUsed,
    required this.totalNtlPos,
    required this.withdrawable,
    required this.spotBalancesCount,
    required this.perpPositionsCount,
    required this.perpOrdersCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletDetailsResponse.fromJson(Map<String, dynamic> json) {
    return WalletDetailsResponse(
      walletAddress: json['wallet_address'] as String,
      spotBalance: (json['spot_balance'] as num).toDouble(),
      perpBalance: (json['perp_balance'] as num).toDouble(),
      totalBalance: (json['total_balance'] as num).toDouble(),
      totalMarginUsed: (json['total_margin_used'] as num).toDouble(),
      totalNtlPos: (json['total_ntl_pos'] as num).toDouble(),
      withdrawable: (json['withdrawable'] as num).toDouble(),
      spotBalancesCount: json['spot_balances_count'] as int,
      perpPositionsCount: json['perp_positions_count'] as int,
      perpOrdersCount: json['perp_orders_count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

// Spot balances response
class SpotBalance {
  final String coin;
  final String balance;
  final String hold;
  final String total;
  final String entryNtl;
  final String updatedAt;

  SpotBalance({
    required this.coin,
    required this.balance,
    required this.hold,
    required this.total,
    required this.entryNtl,
    required this.updatedAt,
  });

  factory SpotBalance.fromJson(Map<String, dynamic> json) {
    return SpotBalance(
      coin: json['coin'] as String,
      balance: json['balance'] as String,
      hold: json['hold'] as String,
      total: json['total'] as String,
      entryNtl: json['entry_ntl'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class WalletSpotResponse {
  final String walletAddress;
  final List<SpotBalance> balances;
  final int totalCount;
  final String? lastUpdated;

  WalletSpotResponse({
    required this.walletAddress,
    required this.balances,
    required this.totalCount,
    this.lastUpdated,
  });

  factory WalletSpotResponse.fromJson(Map<String, dynamic> json) {
    return WalletSpotResponse(
      walletAddress: json['wallet_address'] as String,
      balances: (json['balances'] as List)
          .map((balance) => SpotBalance.fromJson(balance))
          .toList(),
      totalCount: json['total_count'] as int,
      lastUpdated: json['last_updated'] as String?,
    );
  }
}

// Perp positions response
class PerpPosition {
  final String coin;
  final String leverageType;
  final String leverageValue;
  final String marginUsed;
  final String positionValue;
  final String returnOnEquity;
  final String szi;
  final String unrealizedPnl;
  final int maxLeverage;
  final String cumFundingAllTime;
  final String cumFundingSinceOpen;
  final String cumFundingSinceChange;
  final String typeString;
  final String updatedAt;
  final String? entryPx;
  final String? leverageRawUsd;
  final String? liquidationPx;

  PerpPosition({
    required this.coin,
    required this.leverageType,
    required this.leverageValue,
    required this.marginUsed,
    required this.positionValue,
    required this.returnOnEquity,
    required this.szi,
    required this.unrealizedPnl,
    required this.maxLeverage,
    required this.cumFundingAllTime,
    required this.cumFundingSinceOpen,
    required this.cumFundingSinceChange,
    required this.typeString,
    required this.updatedAt,
    this.entryPx,
    this.leverageRawUsd,
    this.liquidationPx,
  });

  factory PerpPosition.fromJson(Map<String, dynamic> json) {
    return PerpPosition(
      coin: json['coin'] as String,
      leverageType: json['leverage_type'] as String,
      leverageValue: json['leverage_value'] as String,
      marginUsed: json['margin_used'] as String,
      positionValue: json['position_value'] as String,
      returnOnEquity: json['return_on_equity'] as String,
      szi: json['szi'] as String,
      unrealizedPnl: json['unrealized_pnl'] as String,
      maxLeverage: json['max_leverage'] as int,
      cumFundingAllTime: json['cum_funding_all_time'] as String,
      cumFundingSinceOpen: json['cum_funding_since_open'] as String,
      cumFundingSinceChange: json['cum_funding_since_change'] as String,
      typeString: json['type_string'] as String,
      updatedAt: json['updated_at'] as String,
      entryPx: json['entry_px'] as String?,
      leverageRawUsd: json['leverage_raw_usd'] as String?,
      liquidationPx: json['liquidation_px'] as String?,
    );
  }
}

class WalletPerpResponse {
  final String walletAddress;
  final List<PerpPosition> positions;
  final int totalCount;
  final String? lastUpdated;

  WalletPerpResponse({
    required this.walletAddress,
    required this.positions,
    required this.totalCount,
    this.lastUpdated,
  });

  factory WalletPerpResponse.fromJson(Map<String, dynamic> json) {
    return WalletPerpResponse(
      walletAddress: json['wallet_address'] as String,
      positions: (json['positions'] as List)
          .map((position) => PerpPosition.fromJson(position))
          .toList(),
      totalCount: json['total_count'] as int,
      lastUpdated: json['last_updated'] as String?,
    );
  }
}