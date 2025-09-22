import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';
import 'package:hyper_app/extensions/privy/features/authenticated/widgets/ethereum_wallets_widget.dart';
import 'package:hyper_app/extensions/privy/features/authenticated/widgets/linked_accounts_widget.dart';
import 'package:hyper_app/extensions/privy/features/authenticated/widgets/user_profile_widget.dart';
import 'package:hyper_app/screens/app_router.dart';
import 'package:privy_flutter/privy_flutter.dart';

class AuthenticatedScreen extends StatefulWidget {
  const AuthenticatedScreen({super.key});

  @override
  State<AuthenticatedScreen> createState() => _AuthenticatedScreenState();
}

class _AuthenticatedScreenState extends State<AuthenticatedScreen> {
  final _privyManager = privyManager;
  late PrivyUser _user;

  // Track loading states
  bool _isCreatingEthereumWallet = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  // Get the current authenticated user
  void _fetchUser() {
    _user = _privyManager.privy.user!;
  }

  // Show snackbar message
  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Add Ethereum wallet
  Future<void> _createEthereumWallet() async {
    setState(() {
      _isCreatingEthereumWallet = true;
    });

    try {
      final result = await _user.createEthereumWallet(allowAdditional: true);

      result.fold(
        onSuccess: (wallet) {
          _showMessage("Ethereum wallet created: ${wallet.address}");
          // Refresh user to update the wallet list
          setState(() {
            _isCreatingEthereumWallet = false;
          });
        },
        onFailure: (error) {
          setState(() {
            _isCreatingEthereumWallet = false;
          });
          _showMessage(
            "Error creating wallet: ${error.message}",
            isError: true,
          );
        },
      );
    } catch (e) {
      setState(() {
        _isCreatingEthereumWallet = false;
      });
      _showMessage("Unexpected error: $e", isError: true);
    }
  }


  // Logout
  Future<void> _logout() async {
    try {
      await _privyManager.privy.logout();

      if (mounted) {
        // Route back to the Privy welcome screen so the user can log in again
        context.goNamed(AppRouter.homeRoute);
      }
    } catch (e) {
      _showMessage("Logout error: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0891B2),
                    Color(0xFF00D2FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF64748B)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildUserProfileCard(),
                const SizedBox(height: 24),
                _buildWalletSection(),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back!",
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0891B2),
                  Color(0xFF00D2FF),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A2332),
            Color(0xFF2D3748),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          UserProfileWidget(user: _user),
          const Divider(color: Color(0xFF374151), height: 32),
          LinkedAccountsWidget(user: _user),
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A2332),
            Color(0xFF2D3748),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Color(0xFF00D2FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Wallets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EthereumWalletsWidget(user: _user),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          onPressed: _isCreatingEthereumWallet ? null : _createEthereumWallet,
          icon: _isCreatingEthereumWallet
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.add_card, color: Colors.white),
          label: 'Add ETH Wallet',
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0891B2),
              Color(0xFF00D2FF),
            ],
          ),
          isDisabled: _isCreatingEthereumWallet,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          onPressed: _logout,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: 'Logout',
          gradient: const LinearGradient(
            colors: [
              Color(0xFFDC2626),
              Color(0xFFEF4444),
            ],
          ),
          isDisabled: false,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required LinearGradient gradient,
    required bool isDisabled,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: isDisabled ? null : gradient,
        color: isDisabled ? const Color(0xFF374151) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDisabled
              ? const Color(0xFF4B5563)
              : gradient.colors.first.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isDisabled ? const Color(0xFF6B7280) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
