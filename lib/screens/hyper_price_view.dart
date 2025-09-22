import 'package:flutter/material.dart';
import 'package:hyper_app/models/token_info.dart';
import 'package:hyper_app/screens/common_page/token_chart/token_price_page.dart';
import 'package:hyper_app/widgets/svg_or_png_card.dart';
import 'package:provider/provider.dart';
import 'package:hyper_app/provider/hyper_price_provider.dart';

class HyperPriceView extends StatefulWidget {
  const HyperPriceView({super.key});

  @override
  State<HyperPriceView> createState() => _HyperPriceViewState();
}

class _HyperPriceViewState extends State<HyperPriceView> {
  @override
  void initState() {
    super.initState();
    // 确保在初始化时开始获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HyperPriceProvider>(context, listen: false);
      provider.fetchSpotData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HyperPriceProvider>(context);
    final tokens = provider.tokens;
    final loading = provider.loading;
    final error = provider.error;
    final lastUpdate = provider.lastUpdate;

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
                    Icons.candlestick_chart,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Market',
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D2FF)),
                      ),
                    )
                  : const Icon(
                      Icons.refresh,
                      color: Color(0xFF00D2FF),
                      size: 20,
                    ),
              onPressed: loading ? null : provider.fetchSpotData,
            ),
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMarketStats(tokens, lastUpdate),
              const SizedBox(height: 20),
              if (loading && tokens.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D2FF)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading market data...',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (error != null)
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFDC2626),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: $error',
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFDC2626),
                                  Color(0xFFEF4444),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: provider.fetchSpotData,
                              child: const Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: tokens.length,
                  itemBuilder: (context, index) {
                    final token = tokens[index];
                    return _buildTokenCard(context, token);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketStats(List<dynamic> tokens, DateTime? lastUpdate) {
    final marketCap = tokens.length;
    final positiveCount = tokens.where((token) => (token['changePercent'] as num) >= 0).length;
    final negativeCount = tokens.length - positiveCount;

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
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: Color(0xFF00D2FF),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Market Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (lastUpdate != null)
                Text(
                  'Updated: ${lastUpdate.toLocal().toString().split('.')[0].split(' ')[1]}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Assets',
                  marketCap.toString(),
                  Icons.pie_chart,
                  const Color(0xFF00D2FF),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF374151),
              ),
              Expanded(
                child: _buildStatItem(
                  'Gainers',
                  positiveCount.toString(),
                  Icons.trending_up,
                  const Color(0xFF10B981),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF374151),
              ),
              Expanded(
                child: _buildStatItem(
                  'Losers',
                  negativeCount.toString(),
                  Icons.trending_down,
                  const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTokenCard(BuildContext context, Map<String, dynamic> token) {
    final changePercent = (token['changePercent'] as num).toDouble();
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? const Color(0xFF10B981) : const Color(0xFFDC2626);
    final changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TokenPricePage(
              symbol: token['name'],
              tokenInfo: TokenInfo(
                name: token['name'],
                price: token['price'],
                prevPrice: token['prevPrice'],
                change: (token['change'] as num).toDouble(),
                changePercent: changePercent,
                logoUrl: token['logoUrl'],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E293B),
              const Color(0xFF0F172A),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: changeColor.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: changeColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: tokenImageWidget(token['logoUrl'], token['name']),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          token['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Dec: ${token['szDecimals']}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  // 根据屏幕宽度动态调整字体大小
                  double fontSize = constraints.maxWidth > 140 ? 18 : 16;
                  return Text(
                    '\$${token['price'].toStringAsFixed(4)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                },
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    changeIcon,
                    color: changeColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '\$${token['change'].toStringAsFixed(4)}',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: changeColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
