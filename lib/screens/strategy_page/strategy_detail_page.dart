import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hyper_app/models/strategy_models.dart';
import 'package:hyper_app/provider/strategy_provider.dart';

class StrategyDetailPage extends StatefulWidget {
  final StrategyModel strategy;

  const StrategyDetailPage({super.key, required this.strategy});

  @override
  State<StrategyDetailPage> createState() => _StrategyDetailPageState();
}

class _StrategyDetailPageState extends State<StrategyDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  StrategyModel? _strategy;
  StrategyExecutionsResponse? _executionsMeta;
  List<StrategyExecution> _executionItems = [];
  int _totalExecutionsCount = 0;
  int _offset = 0;
  final int _pageSize = 20;

  bool _isLoading = true;
  bool _isExecutionsLoading = false;
  bool _hasMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _strategy = widget.strategy;
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (!mounted) return;

    setState(() {
      if (!refresh) {
        _isLoading = true;
      }
      _error = null;
    });

    final provider = context.read<StrategyProvider>();

    try {
      final detail = await provider.fetchStrategyDetail(
        widget.strategy.id,
        forceRefresh: refresh,
      );
      final executions = await provider.fetchStrategyExecutions(
        widget.strategy.id,
        limit: _pageSize,
        offset: 0,
        forceRefresh: refresh,
      );

      if (!mounted) return;

      setState(() {
        if (detail != null) {
          _strategy = detail;
        }
        if (executions != null) {
          _executionsMeta = executions;
          _executionItems = List.of(executions.executions);
          _totalExecutionsCount = executions.totalCount;
          _offset = _executionItems.length;
          _hasMore = _offset < _totalExecutionsCount;
        } else {
          _executionsMeta = null;
          _executionItems = [];
          _totalExecutionsCount = 0;
          _offset = 0;
          _hasMore = false;
        }
        _isLoading = false;
        if (detail == null && executions == null) {
          _error = 'Unable to load strategy data.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMoreExecutions() async {
    if (_isExecutionsLoading || !_hasMore) return;

    setState(() {
      _isExecutionsLoading = true;
    });

    final provider = context.read<StrategyProvider>();

    try {
      final response = await provider.fetchStrategyExecutions(
        widget.strategy.id,
        limit: _pageSize,
        offset: _offset,
        forceRefresh: true,
      );

      if (!mounted) return;

      if (response != null) {
        setState(() {
          _executionItems = List.of(_executionItems)
            ..addAll(response.executions);
          _executionsMeta = response;
          _totalExecutionsCount = response.totalCount;
          _offset = _executionItems.length;
          _hasMore = _offset < _totalExecutionsCount;
        });
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isExecutionsLoading = false;
      });
    }
  }

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
    final strategy = _strategy ?? widget.strategy;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: RefreshIndicator(
        color: const Color(0xFF00D2FF),
        onRefresh: () => _loadData(refresh: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              backgroundColor: const Color(0xFF1E293B),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
                  onPressed: () => _loadData(refresh: true),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00D2FF),
                              ),
                            )
                          : _buildHeader(strategy),
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Executions'),
                ],
                labelColor: const Color(0xFF00D2FF),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF00D2FF),
                indicatorWeight: 3,
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(strategy),
                  _buildExecutionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(StrategyModel strategy) {
    final provider = context.read<StrategyProvider>();
    final winRate = provider.successRate(strategy);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.analytics,
                  color: Color(0xFF00D2FF), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strategy.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.category,
                          size: 16, color: const Color(0xFF94A3B8)),
                      const SizedBox(width: 6),
                      Text(
                        strategy.strategyType,
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _statusColor(strategy.status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                strategy.status,
                style: TextStyle(
                  color: _statusColor(strategy.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _HeaderMetric(
              label: 'Capital Allocated',
              value: provider.formatCurrency(strategy.capitalAllocated),
            ),
            _HeaderMetric(
              label: 'Daily PnL',
              value: provider.formatCurrency(strategy.dailyPnl),
              valueColor: (strategy.dailyPnl ?? 0) >= 0
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
            _HeaderMetric(
              label: 'Total PnL',
              value: provider.formatCurrency(strategy.totalPnl),
              valueColor: (strategy.totalPnl ?? 0) >= 0
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_executionsMeta?.lastExecution != null)
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(
                'Last execution: ${_executionsMeta!.lastExecution}',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildOverviewTab(StrategyModel strategy) {
    if (_isLoading && _executionItems.isEmpty && _error == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D2FF)),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    final provider = context.read<StrategyProvider>();
    final winRate = provider.successRate(strategy);

    return Container(
      color: const Color(0xFF0F172A),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Performance Metrics',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              StrategyMetricCard(
                title: 'Capital Allocated',
                value: provider.formatCurrency(strategy.capitalAllocated),
                icon: Icons.account_balance_wallet,
              ),
              StrategyMetricCard(
                title: 'Daily PnL',
                value: provider.formatCurrency(strategy.dailyPnl),
                icon: Icons.trending_up,
                valueColor: (strategy.dailyPnl ?? 0) >= 0
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              StrategyMetricCard(
                title: 'Total PnL',
                value: provider.formatCurrency(strategy.totalPnl),
                icon: Icons.pie_chart,
                valueColor: (strategy.totalPnl ?? 0) >= 0
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              StrategyMetricCard(
                title: 'Sharpe Ratio',
                value: strategy.sharpeRatio?.toStringAsFixed(2) ?? '--',
                icon: Icons.score,
              ),
              StrategyMetricCard(
                title: 'Max Drawdown',
                value: strategy.maxDrawdown != null
                    ? provider.formatPercent(strategy.maxDrawdown)
                    : '--',
                icon: Icons.troubleshoot,
                valueColor: const Color(0xFFEF4444),
              ),
              StrategyMetricCard(
                title: 'Avg Latency',
                value: strategy.averageLatencyMs != null
                    ? '${strategy.averageLatencyMs!.toStringAsFixed(0)} ms'
                    : '--',
                icon: Icons.speed,
              ),
              StrategyMetricCard(
                title: 'Total Trades',
                value: '${strategy.totalTrades ?? 0}',
                icon: Icons.calculate,
              ),
              StrategyMetricCard(
                title: 'Successful Trades',
                value: '${strategy.successfulTrades ?? 0}',
                icon: Icons.emoji_events,
              ),
              StrategyMetricCard(
                title: 'Win Rate',
                value: provider.formatPercent(winRate),
                icon: Icons.percent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Configuration',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (strategy.config == null || strategy.config!.isEmpty)
            const Text(
              'No configuration data available.',
              style: TextStyle(color: Color(0xFF94A3B8)),
            )
          else
            Column(
              children: strategy.config!.entries
                  .map(
                    (entry) => _ConfigRow(
                      label: entry.key,
                      value: entry.value?.toString() ?? '--',
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildExecutionsTab() {
    if (_isLoading && _executionItems.isEmpty && _error == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D2FF)),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_executionItems.isEmpty) {
      return const Center(
        child: Text(
          'No executions recorded yet',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return Container(
      color: const Color(0xFF0F172A),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _executionItems.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _executionItems.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: _isExecutionsLoading
                    ? const CircularProgressIndicator(color: Color(0xFF00D2FF))
                    : ElevatedButton(
                        onPressed: _loadMoreExecutions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D2FF),
                        ),
                        child: const Text(
                          'Load more',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
              ),
            );
          }

          final execution = _executionItems[index];
          return StrategyExecutionTile(execution: execution);
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadData(refresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D2FF),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _HeaderMetric({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StrategyMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color valueColor;

  const StrategyMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00D2FF)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfigRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StrategyExecutionTile extends StatelessWidget {
  final StrategyExecution execution;

  const StrategyExecutionTile({super.key, required this.execution});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return const Color(0xFF10B981);
      case 'failed':
      case 'error':
        return const Color(0xFFEF4444);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: _statusColor(execution.executionStatus)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  execution.executionStatus,
                  style: TextStyle(
                    color: _statusColor(execution.executionStatus),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                execution.createdAt ?? '--',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ExecutionMetric(
                label: 'Coin',
                value: execution.coin,
              ),
              const SizedBox(width: 16),
              _ExecutionMetric(
                label: 'Spread',
                value: '${execution.spreadBasisPoints.toStringAsFixed(2)} bps',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ExecutionMetric(
                label: 'Spot Price',
                value: execution.spotPrice.toStringAsFixed(4),
              ),
              const SizedBox(width: 16),
              _ExecutionMetric(
                label: 'Perp Price',
                value: execution.perpPrice.toStringAsFixed(4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ExecutionMetric(
                label: 'PnL',
                value: execution.pnl != null
                    ? execution.pnl! >= 0
                        ? '+${execution.pnl!.toStringAsFixed(4)}'
                        : execution.pnl!.toStringAsFixed(4)
                    : '--',
                valueColor: execution.pnl == null
                    ? Colors.white
                    : execution.pnl! >= 0
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 16),
              _ExecutionMetric(
                label: 'Latency',
                value: execution.latencyMs != null
                    ? '${execution.latencyMs} ms'
                    : '--',
              ),
            ],
          ),
          if (execution.errorMessage != null &&
              execution.errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                execution.errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExecutionMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _ExecutionMetric({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1525),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
