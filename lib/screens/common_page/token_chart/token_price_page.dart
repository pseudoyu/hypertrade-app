import 'package:flutter/material.dart';
import 'package:hyper_app/widgets/svg_or_png_card.dart';
import 'package:intl/intl.dart';
import 'package:hyper_app/models/token_info.dart';
import 'package:hyper_app/widgets/chart_widget.dart';
import 'package:hyper_app/helper/http_service.dart';
import 'package:hyper_app/extensions/list_extensions.dart';

class TokenPricePage extends StatefulWidget {
  final String symbol;
  final TokenInfo tokenInfo;
  const TokenPricePage({
    super.key,
    required this.symbol,
    required this.tokenInfo,
  });

  @override
  State<TokenPricePage> createState() => _TokenPricePageState();
}

class _TokenPricePageState extends State<TokenPricePage> {
  List<CandleData> _candleData = [];
  bool _loading = true;
  bool _chartLoading = false;
  String? _error;
  TimeInterval _interval = TimeInterval.hour1;
  DateTime? _lastUpdate;

  final Map<TimeInterval, String> intervalLabels = {
    TimeInterval.minute1: '1m',
    TimeInterval.minute5: '5m',
    TimeInterval.minute15: '15m',
    TimeInterval.hour1: '1h',
    TimeInterval.hour4: '4h',
    TimeInterval.day1: '1d',
  };

  final Map<TimeInterval, String> intervalValues = {
    TimeInterval.minute1: '1m',
    TimeInterval.minute5: '5m',
    TimeInterval.minute15: '15m',
    TimeInterval.hour1: '1h',
    TimeInterval.hour4: '4h',
    TimeInterval.day1: '1d',
  };

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Future.wait([
        // _fetchTokenInfo(),
        _fetchCandleData(_interval),
      ]);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchCandleData(TimeInterval selectedInterval) async {
    setState(() {
      _chartLoading = true;
    });

    try {
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = _getIntervalDuration(selectedInterval);
      final startTime = endTime - duration * 200;

      final response = await HttpService.post(
        'https://api-ui.hyperliquid.xyz/info',
        headers: {
          'accept': '*/*',
          'accept-language': 'zh-CN,zh;q=0.9,en;q=0.8,am;q=0.7,zh-TW;q=0.6',
          'content-type': 'application/json',
          'sec-ch-ua':
              '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
          'sec-ch-ua-mobile': '?0',
          'sec-ch-ua-platform': '"macOS"',
          'sec-fetch-dest': 'empty',
          'sec-fetch-mode': 'cors',
          'sec-fetch-site': 'same-site',
          'referrer': 'https://app.hyperliquid.xyz/',
        },
        body: {
          'req': {
            'coin': widget.symbol,
            'endTime': endTime,
            'interval': intervalValues[selectedInterval],
            'startTime': startTime,
          },
          'type': 'candleSnapshot',
        },
      );

      if (response is List) {
        setState(() {
          _candleData =
              response.map((data) => CandleData.fromJson(data)).toList();
          _lastUpdate = DateTime.now();
        });
      } else {
        throw Exception('Failed to parse candle data');
      }
    } catch (e) {
      debugPrint('Error fetching candle data: $e');
    } finally {
      setState(() {
        _chartLoading = false;
      });
    }
  }

  int _getIntervalDuration(TimeInterval interval) {
    switch (interval) {
      case TimeInterval.minute1:
        return 60 * 1000;
      case TimeInterval.minute5:
        return 5 * 60 * 1000;
      case TimeInterval.minute15:
        return 15 * 60 * 1000;
      case TimeInterval.hour1:
        return 60 * 60 * 1000;
      case TimeInterval.hour4:
        return 4 * 60 * 60 * 1000;
      case TimeInterval.day1:
        return 24 * 60 * 60 * 1000;
    }
  }

  void _handleIntervalChange(TimeInterval? newInterval) {
    if (newInterval != null && newInterval != _interval) {
      setState(() {
        _interval = newInterval;
      });
      _fetchCandleData(newInterval);
    }
  }

  void _handleRefresh() {
    // _fetchTokenInfo();
    _fetchCandleData(_interval);
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(2);
    } else if (price >= 1) {
      return price.toStringAsFixed(4);
    } else if (price >= 0.01) {
      return price.toStringAsFixed(6);
    } else {
      return price.toStringAsFixed(8);
    }
  }

  String _formatChange(double change) {
    final absChange = change.abs();
    String formatted;

    if (absChange >= 1000) {
      formatted = absChange.toStringAsFixed(2);
    } else if (absChange >= 1) {
      formatted = absChange.toStringAsFixed(4);
    } else if (absChange >= 0.01) {
      formatted = absChange.toStringAsFixed(6);
    } else {
      formatted = absChange.toStringAsFixed(8);
    }

    return change >= 0 ? '+$formatted' : '-$formatted';
  }

  String _formatChangePercent(double percent) {
    return percent >= 0
        ? '+${percent.toStringAsFixed(2)}%'
        : '${percent.toStringAsFixed(2)}%';
  }

  (double high, double low) _get24hHighLow() {
    if (_candleData.isEmpty) return (0, 0);

    final last24hData = _candleData.takeLast(24);
    final highs = last24hData.map((candle) => candle.h).toList();
    final lows = last24hData.map((candle) => candle.l).toList();

    return (
      highs.isNotEmpty ? highs.reduce((a, b) => a > b ? a : b) : 0,
      lows.isNotEmpty ? lows.reduce((a, b) => a < b ? a : b) : 0
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildLoadingScreen();
    }

    if (_error != null) {
      return _buildErrorScreen();
    }

    final (high24h, low24h) = _get24hHighLow();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // _buildPriceInfoCards(high24h, low24h),
                      const SizedBox(height: 20),
                      _buildChartSection(),
                      const SizedBox(height: 20),
                      _buildTradingDataTable(),
                      const SizedBox(height: 20), // 底部安全距离
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Color(0xFF00D2FF),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Loading token data...',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
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
                  color: const Color(0xFFDC2626).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error Loading Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error ?? 'Unknown error occurred',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF374151),
                                  Color(0xFF4B5563),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF00D2FF),
                                size: 16,
                              ),
                              label: const Text(
                                'Go Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0891B2),
                                  Color(0xFF00D2FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _handleRefresh,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 16,
                              ),
                              label: const Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final currentPrice = widget.tokenInfo.price;
    final change = widget.tokenInfo.change;
    final changePercent = widget.tokenInfo.changePercent;
    final isPositive = changePercent >= 0;
    final changeColor =
        isPositive ? const Color(0xFF10B981) : const Color(0xFFDC2626);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF374151),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Top row: Back button, token info, and refresh
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF00D2FF),
                        size: 18,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00D2FF).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: tokenImageWidget(
                          widget.tokenInfo.logoUrl, widget.tokenInfo.name),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0891B2),
                                    Color(0xFF00D2FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${widget.tokenInfo.name}/USDC',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_lastUpdate != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: const Color(0xFF10B981),
                                    size: 10,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    DateFormat.Hm().format(_lastUpdate!),
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Hyperliquid Spot',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF00D2FF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _handleRefresh,
                      icon: _chartLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00D2FF)),
                              ),
                            )
                          : const Icon(
                              Icons.refresh,
                              color: Color(0xFF00D2FF),
                              size: 18,
                            ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom row: Price info
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                '\$${_formatPrice(currentPrice)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: changeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: changeColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: changeColor,
                                    size: 14,
                                  ),
                                  Text(
                                    '${_formatChangePercent(changePercent)}',
                                    style: TextStyle(
                                      color: changeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '24h: ',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_formatChange(change)}',
                              style: TextStyle(
                                color: changeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'H/L: ',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Flexible(
                              child: _candleData.isNotEmpty
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '\$${_formatPrice(_get24hHighLow().$1)}',
                                          style: const TextStyle(
                                            color: Color(0xFF10B981),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        ' / ',
                                        style: const TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 9,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '\$${_formatPrice(_get24hHighLow().$2)}',
                                          style: const TextStyle(
                                            color: Color(0xFFDC2626),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'N/A',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 9,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF374151),
                                Color(0xFF4B5563),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF00D2FF).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: DropdownButton<TimeInterval>(
                            value: _interval,
                            onChanged: _handleIntervalChange,
                            dropdownColor: const Color(0xFF1E293B),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            underline: Container(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF00D2FF),
                              size: 16,
                            ),
                            isDense: true,
                            items: TimeInterval.values.map((interval) {
                              return DropdownMenuItem<TimeInterval>(
                                value: interval,
                                child: Text(
                                  intervalLabels[interval]!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Current Price':
        return Icons.attach_money;
      case '24h Change':
        return Icons.trending_up;
      case '24h High':
        return Icons.keyboard_arrow_up;
      case '24h Low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildChartSection() {
    return Container(
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
          color: const Color(0xFF00D2FF).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D2FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.candlestick_chart,
                    color: Color(0xFF00D2FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Price Chart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF374151),
                        Color(0xFF4B5563),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00D2FF).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<TimeInterval>(
                    value: _interval,
                    onChanged: _handleIntervalChange,
                    dropdownColor: const Color(0xFF1E293B),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    underline: Container(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF00D2FF),
                      size: 16,
                    ),
                    isDense: true,
                    items: TimeInterval.values.map((interval) {
                      return DropdownMenuItem<TimeInterval>(
                        value: interval,
                        child: Text(
                          intervalLabels[interval]!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_chartLoading)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          color: Color(0xFF00D2FF),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading chart data...',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_candleData.isNotEmpty)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ChartWidget(data: _candleData),
                ),
              )
            else
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        color: Color(0xFF64748B),
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No chart data available',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingDataTable() {
    return Container(
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
          color: const Color(0xFF00D2FF).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D2FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.table_chart,
                    color: Color(0xFF00D2FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Recent Trading Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_candleData.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF374151),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        color: Color(0xFF64748B),
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No trading data available',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 800;

                  if (isSmallScreen) {
                    return _buildMobileTradingData();
                  } else {
                    return _buildDesktopTradingData();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTradingData() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 40,
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFF1E293B).withOpacity(0.8),
            ),
            headingTextStyle: const TextStyle(
              color: Color(0xFF00D2FF),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            dataTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
            columns: const [
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Open'), numeric: true),
              DataColumn(label: Text('High'), numeric: true),
              DataColumn(label: Text('Low'), numeric: true),
              DataColumn(label: Text('Close'), numeric: true),
              DataColumn(label: Text('Volume'), numeric: true),
              DataColumn(label: Text('Trades'), numeric: true),
            ],
            rows: _candleData.takeLast(10).map((candle) {
              final open = candle.o;
              final close = candle.c;
              final isGreen = close >= open;
              final changeColor =
                  isGreen ? const Color(0xFF10B981) : const Color(0xFFDC2626);

              return DataRow(
                color: WidgetStateProperty.all(
                  const Color(0xFF0F172A).withOpacity(0.3),
                ),
                cells: [
                  DataCell(
                    Text(
                      DateFormat.Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(candle.t)),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${_formatPrice(open)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${_formatPrice(candle.h)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${_formatPrice(candle.l)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${_formatPrice(close)}',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      candle.v.toStringAsFixed(3),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      candle.n.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTradingData() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _candleData.takeLast(10).length,
      itemBuilder: (context, index) {
        final candle = _candleData.takeLast(10).toList()[index];
        final open = candle.o;
        final close = candle.c;
        final isGreen = close >= open;
        final changeColor =
            isGreen ? const Color(0xFF10B981) : const Color(0xFFDC2626);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F172A).withOpacity(0.8),
                const Color(0xFF1E293B).withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: changeColor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: changeColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: const Color(0xFF64748B),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(candle.t)),
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            changeColor.withOpacity(0.1),
                            changeColor.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: changeColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGreen ? Icons.trending_up : Icons.trending_down,
                            color: changeColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${_formatPrice(close)}',
                            style: TextStyle(
                              color: changeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileDataItem(
                          'Open',
                          '\$${_formatPrice(open)}',
                          Icons.radio_button_unchecked),
                    ),
                    Expanded(
                      child: _buildMobileDataItem(
                          'High',
                          '\$${_formatPrice(candle.h)}',
                          Icons.keyboard_arrow_up),
                    ),
                    Expanded(
                      child: _buildMobileDataItem(
                          'Low',
                          '\$${_formatPrice(candle.l)}',
                          Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileDataItem('Volume',
                          candle.v.toStringAsFixed(3), Icons.bar_chart),
                    ),
                    Expanded(
                      child: _buildMobileDataItem(
                          'Trades', candle.n.toString(), Icons.swap_horiz),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileDataItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF64748B),
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

enum TimeInterval {
  minute1,
  minute5,
  minute15,
  hour1,
  hour4,
  day1,
}

class CandleData {
  final int t; // timestamp start
  final int T; // timestamp end
  final String s; // symbol
  final String i; // interval
  final double o; // open
  final double c; // close
  final double h; // high
  final double l; // low
  final double v; // volume
  final int n; // number of trades

  CandleData({
    required this.t,
    required this.T,
    required this.s,
    required this.i,
    required this.o,
    required this.c,
    required this.h,
    required this.l,
    required this.v,
    required this.n,
  });

  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      t: json['t'],
      T: json['T'],
      s: json['s'],
      i: json['i'],
      o: double.parse(json['o']),
      c: double.parse(json['c']),
      h: double.parse(json['h']),
      l: double.parse(json['l']),
      v: double.parse(json['v']),
      n: json['n'],
    );
  }
}
