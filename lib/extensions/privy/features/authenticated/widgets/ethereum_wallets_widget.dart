import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/screens/app_router.dart';
import 'package:privy_flutter/privy_flutter.dart';

/// Widget that displays all Ethereum wallets for a Privy user
class EthereumWalletsWidget extends StatelessWidget {
  final PrivyUser user;

  const EthereumWalletsWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.embeddedEthereumWallets.isEmpty)
          _buildEmptyState()
        else
          ...user.embeddedEthereumWallets.asMap().entries.map(
            (entry) => _buildWalletCard(context, entry.value, entry.key),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF64748B).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF64748B),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No Ethereum wallets",
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Create your first wallet to get started",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, EmbeddedEthereumWallet wallet, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: index < user.embeddedEthereumWallets.length - 1 ? 16 : 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0891B2).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            GoRouter.of(context).pushNamed(
              AppRouter.ethWalletRoute,
              extra: wallet,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0891B2),
                            Color(0xFF00D2FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ethereum Wallet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "ETH Network",
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildWalletInfo(
                  Icons.fingerprint,
                  "Address",
                  _formatAddress(wallet.address),
                ),
                if (wallet.chainId != null) ...[
                  const SizedBox(height: 12),
                  _buildWalletInfo(
                    Icons.link,
                    "Chain ID",
                    wallet.chainId.toString(),
                  ),
                ],
                if (wallet.recoveryMethod != null) ...[
                  const SizedBox(height: 12),
                  _buildWalletInfo(
                    Icons.security,
                    "Recovery Method",
                    wallet.recoveryMethod!,
                  ),
                ],
                const SizedBox(height: 12),
                _buildWalletInfo(
                  Icons.numbers,
                  "HD Index",
                  wallet.hdWalletIndex.toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF00D2FF),
          size: 16,
        ),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatAddress(String address) {
    if (address.length > 14) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 8)}';
    }
    return address;
  }
}
