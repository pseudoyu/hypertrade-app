import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hyper_app/models/strategy_models.dart';
import 'package:hyper_app/provider/strategy_provider.dart';
import 'strategy_detail_page.dart';

class StrategyPage extends StatefulWidget {
  const StrategyPage({super.key});

  @override
  State<StrategyPage> createState() => _StrategyPageState();
}

class _StrategyPageState extends State<StrategyPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StrategyProvider>().fetchStrategies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Strategy Center',
          style: TextStyle(
            color: Color(0xFF00D2FF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF64748B)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
            onPressed: () {
              context.read<StrategyProvider>().refreshStrategies();
            },
          ),
        ],
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _query = value.toLowerCase();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search strategy name/type/status',
                        hintStyle: TextStyle(color: Color(0xFF64748B)),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<StrategyProvider>(
                    builder: (context, provider, child) {
                      return _StrategyStatsRow(
                        total: provider.totalCount,
                        active: provider.activeStrategiesCount,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<StrategyProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.strategies.isEmpty) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF00D2FF)),
                    );
                  }

                  if (provider.error != null && provider.strategies.isEmpty) {
                    return _StrategyErrorState(
                      message: provider.error!,
                      onRetry: () =>
                          provider.fetchStrategies(forceRefresh: true),
                    );
                  }

                  final filteredStrategies =
                      provider.strategies.where((strategy) {
                    if (_query.isEmpty) return true;
                    return strategy.name.toLowerCase().contains(_query) ||
                        strategy.strategyType.toLowerCase().contains(_query) ||
                        strategy.status.toLowerCase().contains(_query);
                  }).toList();

                  if (filteredStrategies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No strategies found',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFF00D2FF),
                    onRefresh: () => provider.refreshStrategies(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: filteredStrategies.length,
                      itemBuilder: (context, index) {
                        final strategy = filteredStrategies[index];
                        return StrategyListItem(
                          strategy: strategy,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    StrategyDetailPage(strategy: strategy),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategyStatsRow extends StatelessWidget {
  final int total;
  final int active;

  const _StrategyStatsRow({required this.total, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.analytics,
              label: 'Total Strategies',
              value: '$total',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF334155)),
          Expanded(
            child: _StatItem(
              icon: Icons.play_circle_fill,
              label: 'Active Now',
              value: '$active',
              iconColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = const Color(0xFF00D2FF),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StrategyErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _StrategyErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            Text(
              'Failed to load strategies',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D2FF),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

class StrategyListItem extends StatelessWidget {
  final StrategyModel strategy;
  final VoidCallback onTap;

  const StrategyListItem(
      {super.key, required this.strategy, required this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'paused':
        return const Color(0xFFF59E0B);
      case 'error':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<StrategyProvider>();
    final successRate = provider.successRate(strategy);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF00D2FF)],
            ),
            border: Border.all(color: const Color(0xFF00D2FF), width: 2),
          ),
          child: const Icon(Icons.analytics, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                strategy.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _statusColor(strategy.status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                strategy.status,
                style: TextStyle(
                  color: _statusColor(strategy.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: const Color(0xFF94A3B8)),
                const SizedBox(width: 6),
                Text(
                  strategy.strategyType,
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StrategyMetricChip(
                  icon: Icons.trending_up,
                  label: provider.formatCurrency(strategy.dailyPnl),
                ),
                _StrategyMetricChip(
                  icon: Icons.account_balance_wallet,
                  label: provider.formatCurrency(strategy.capitalAllocated),
                ),
                _StrategyMetricChip(
                  icon: Icons.emoji_events,
                  label: successRate != null
                      ? '${(successRate * 100).toStringAsFixed(1)}% win'
                      : 'No trades',
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _StrategyMetricChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StrategyMetricChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF00D2FF)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
