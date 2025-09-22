import 'package:flutter/material.dart';
import 'package:hyper_app/models/wallet_models.dart';
import 'package:hyper_app/services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  List<UserWallet> _wallets = [];
  bool _isLoading = false;
  String? _error;
  final Map<String, WalletDetailsResponse> _walletDetails = {};
  final Map<String, WalletAnalytics> _walletAnalytics = {};
  int _totalCount = 0;

  List<UserWallet> get wallets => _wallets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, WalletDetailsResponse> get walletDetails => _walletDetails;
  Map<String, WalletAnalytics> get walletAnalytics => _walletAnalytics;

  int get activeWalletsCount => _wallets.where((wallet) => wallet.active).length;
  int get totalWalletsCount => _totalCount;

  /// Fetch all wallets from API
  Future<void> fetchWallets() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await WalletService.getWalletsResponse();
      _wallets = response.wallets;
      _totalCount = response.totalCount;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new wallet
  Future<bool> addWallet(String address, {String? name}) async {
    _clearError();

    // Check if wallet already exists
    if (_wallets.any((wallet) => wallet.address.toLowerCase() == address.toLowerCase())) {
      _setError('Wallet already exists in your monitoring list');
      return false;
    }

    try {
      final newWallet = await WalletService.addWallet(address, name: name);
      _wallets.add(newWallet);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Update wallet name or active status
  Future<bool> updateWallet(
    String address, {
    String? name,
    bool? active,
  }) async {
    _clearError();

    try {
      final updatedWallet = await WalletService.updateWallet(
        address,
        name: name,
        active: active,
      );

      final index = _wallets.indexWhere((wallet) => wallet.address == address);
      if (index != -1) {
        _wallets[index] = updatedWallet;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Remove wallet from monitoring list
  Future<bool> deleteWallet(String address) async {
    _clearError();

    try {
      await WalletService.deleteWallet(address);
      _wallets.removeWhere((wallet) => wallet.address == address);
      _walletDetails.remove(address);
      _walletAnalytics.remove(address);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Get detailed information for a specific wallet
  Future<WalletDetailsResponse?> getWalletDetails(String address) async {
    _clearError();

    // Return cached data if available
    if (_walletDetails.containsKey(address)) {
      return _walletDetails[address];
    }

    try {
      final details = await WalletService.getWalletDetails(address);
      _walletDetails[address] = details;
      notifyListeners();
      return details;
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  /// Get analytics for a specific wallet
  Future<WalletAnalytics?> getWalletAnalytics(String address) async {
    _clearError();

    // Return cached data if available
    if (_walletAnalytics.containsKey(address)) {
      return _walletAnalytics[address];
    }

    try {
      final analytics = await WalletService.getWalletAnalytics(address);
      _walletAnalytics[address] = analytics;
      notifyListeners();
      return analytics;
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  /// Toggle wallet active status
  Future<bool> toggleWalletActive(String address) async {
    final wallet = _wallets.firstWhere((w) => w.address == address);
    return await updateWallet(address, active: !wallet.active);
  }

  /// Rename wallet
  Future<bool> renameWallet(String address, String newName) async {
    return await updateWallet(address, name: newName);
  }

  /// Clear all cached data
  void clearCache() {
    _walletDetails.clear();
    _walletAnalytics.clear();
    notifyListeners();
  }

  /// Refresh wallet data
  Future<void> refreshWallets() async {
    clearCache();
    await fetchWallets();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get wallet by address
  UserWallet? getWalletByAddress(String address) {
    try {
      return _wallets.firstWhere((wallet) => wallet.address == address);
    } catch (e) {
      return null;
    }
  }

  /// Check if wallet address is valid (basic validation)
  bool isValidWalletAddress(String address) {
    // Basic Ethereum address validation
    final RegExp ethAddressRegex = RegExp(r'^0x[a-fA-F0-9]{40}$');
    return ethAddressRegex.hasMatch(address);
  }

  /// Format wallet address for display
  String formatWalletAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  /// Get total portfolio value
  double get totalPortfolioValue {
    return _wallets
        .where((wallet) => wallet.active && wallet.totalValue != null)
        .fold(0.0, (sum, wallet) => sum + wallet.totalValue!);
  }
}