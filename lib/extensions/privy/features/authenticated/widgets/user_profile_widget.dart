import 'package:flutter/material.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:hyper_app/provider/hypertrade_provider.dart';
import 'package:hyper_app/models/hypertrade_user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Widget that displays basic user profile information
class UserProfileWidget extends StatefulWidget {
  final PrivyUser user;

  const UserProfileWidget({super.key, required this.user});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  void initState() {
    super.initState();
    // Trigger HyperTrade user loading if not already loading/loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HyperTradeProvider>();
      if (!provider.isLoading && provider.hyperTradeUser == null && provider.error == null) {
        provider.fetchHyperTradeUserInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          icon: Icons.fingerprint,
          title: "Privy User ID",
          content: widget.user.id,
          isSelectable: true,
        ),
        const SizedBox(height: 16),
        _buildHypertradeSection(),
      ],
    );
  }

  Widget _buildHypertradeSection() {
    return Consumer<HyperTradeProvider>(
      builder: (context, hyperTradeProvider, child) {
        if (hyperTradeProvider.isLoading) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF374151),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D2FF)),
                ),
                SizedBox(width: 12),
                Text(
                  'Loading profile data...',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (hyperTradeProvider.error != null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEF4444),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hyperTradeProvider.error!,
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => hyperTradeProvider.retry(),
                  icon: const Icon(
                    Icons.refresh,
                    color: Color(0xFF00D2FF),
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        }

        if (hyperTradeProvider.hyperTradeUser == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 20,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'HyperTrade Account',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Account ID',
                    hyperTradeProvider.hyperTradeUser!.id.toString(),
                    Icons.tag,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Created At',
                    DateFormat('MMM dd, yyyy • HH:mm').format(hyperTradeProvider.hyperTradeUser!.createdAt),
                    Icons.schedule,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            SelectableText(
              value,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    bool isSelectable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF00D2FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isSelectable
              ? SelectableText(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ],
      ),
    );
  }
}