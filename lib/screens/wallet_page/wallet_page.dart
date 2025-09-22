import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hyper_app/provider/wallet_provider.dart';
import 'package:hyper_app/models/wallet_models.dart';
import 'package:hyper_app/widgets/snack_bar.dart';
import 'package:hyper_app/screens/wallet_page/wallet_detail_page.dart';
import 'package:hyper_app/helper/api_debug_helper.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addWalletController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWallets();
    });
  }

  Future<void> _loadWallets() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.fetchWallets();
  }

  void _showAddWalletDialog() {
    _addWalletController.clear();
    _nameController.clear();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _addWalletController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '搜索钱包名/地址',
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00D2FF)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '钱包名称 (可选)',
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00D2FF)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addWallet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D2FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '添加',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Future<void> _addWallet() async {
    final address = _addWalletController.text.trim();
    final name = _nameController.text.trim();

    if (address.isEmpty) {
      showSnackbar(context, '错误', '请输入钱包地址', ContentType.failure);
      return;
    }

    final walletProvider = context.read<WalletProvider>();
    if (!walletProvider.isValidWalletAddress(address)) {
      showSnackbar(context, '错误', '请输入有效的钱包地址', ContentType.failure);
      return;
    }

    Navigator.pop(context);

    final success = await walletProvider.addWallet(
      address,
      name: name.isEmpty ? null : name,
    );

    if (success) {
      showSnackbar(context, '成功', '钱包已添加到监控列表', ContentType.success);
    } else {
      showSnackbar(
        context,
        '错误',
        walletProvider.error ?? 'Add Wallet失败',
        ContentType.failure,
      );
    }
  }

  void _showWalletOptions(UserWallet wallet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF64748B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              wallet.name ?? walletProvider.formatWalletAddress(wallet.address),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF00D2FF)),
              title: const Text(
                '编辑名称',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(wallet);
              },
            ),
            ListTile(
              leading: Icon(
                wallet.active ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF00D2FF),
              ),
              title: Text(
                wallet.active ? '取消监控' : '开启监控',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleWalletMonitoring(wallet);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                '删除钱包',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(wallet);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(UserWallet wallet) {
    final nameController = TextEditingController(text: wallet.name ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '编辑名称',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '输入钱包名称',
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00D2FF)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final walletProvider = context.read<WalletProvider>();
                        final success = await walletProvider.renameWallet(
                          wallet.address,
                          nameController.text.trim(),
                        );
                        if (success) {
                          showSnackbar(
                            context,
                            '成功',
                            '钱包名称已更新',
                            ContentType.success,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D2FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '保存',
                        style: TextStyle(color: Colors.white),
                      ),
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

  void _showDeleteConfirmation(UserWallet wallet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '确认删除',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '确定要删除钱包 ${wallet.name ?? walletProvider.formatWalletAddress(wallet.address)} 吗？',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final walletProvider = context.read<WalletProvider>();
              final success = await walletProvider.deleteWallet(wallet.address);
              if (success) {
                showSnackbar(
                  context,
                  '成功',
                  '钱包已从监控列表中删除',
                  ContentType.success,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleWalletMonitoring(UserWallet wallet) async {
    final walletProvider = context.read<WalletProvider>();
    final success = await walletProvider.toggleWalletActive(wallet.address);
    if (success) {
      showSnackbar(
        context,
        '成功',
        wallet.active ? '已停止监控' : '已开始监控',
        ContentType.success,
      );
    }
  }

  WalletProvider get walletProvider => context.read<WalletProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Wallet Monitoring',
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
            icon: const Icon(Icons.menu, color: Color(0xFF64748B)),
            onPressed: () {},
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
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
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search wallet name/address',
                        hintStyle: TextStyle(color: Color(0xFF64748B)),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Consumer<WalletProvider>(
                  //   builder: (context, walletProvider, child) {
                  //     return _buildStatsRow(walletProvider);
                  //   },
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<WalletProvider>(
                builder: (context, walletProvider, child) {
                  if (walletProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D2FF),
                      ),
                    );
                  }

                  if (walletProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '加载失败',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            walletProvider.error!,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _loadWallets,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00D2FF),
                                ),
                                child: const Text(
                                  '重试',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  showSnackbar(context, '调试', '正在运行认证诊断...', ContentType.help);
                                  final debugInfo = await ApiDebugHelper.debugAuthentication();
                                  print('Debug Info: $debugInfo');
                                  // Try to refresh token and retry
                                  final newToken = await ApiDebugHelper.forceRefreshToken();
                                  if (newToken != null) {
                                    showSnackbar(context, '成功', 'Token已刷新，正在重试...', ContentType.success);
                                    _loadWallets();
                                  } else {
                                    showSnackbar(context, '错误', '无法刷新认证Token', ContentType.failure);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B6B),
                                ),
                                child: const Text(
                                  '诊断',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredWallets = walletProvider.wallets.where((wallet) {
                    if (_searchQuery.isEmpty) return true;
                    final name = wallet.name?.toLowerCase() ?? '';
                    final address = wallet.address.toLowerCase();
                    return name.contains(_searchQuery) ||
                        address.contains(_searchQuery);
                  }).toList();

                  if (filteredWallets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Color(0xFF64748B),
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? '当前版本上线为几个' : '未找到匹配的钱包',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _showAddWalletDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D2FF),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Add Wallet',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: filteredWallets.length,
                      itemBuilder: (context, index) {
                        final wallet = filteredWallets[index];
                        return WalletItem(
                          wallet: wallet,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalletDetailPage(wallet: wallet),
                            ),
                          ),
                          onOptions: () => _showWalletOptions(wallet),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWalletDialog,
        backgroundColor: const Color(0xFF00D2FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsRow(WalletProvider walletProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Active Users',
              '${walletProvider.activeWalletsCount}',
              Icons.people,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFF374151),
          ),
          Expanded(
            child: _buildStatItem(
              'Online Now',
              '${walletProvider.totalWalletsCount}',
              Icons.circle,
              isOnline: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {bool isOnline = false}) {
    return Column(
      children: [
        Icon(
          icon,
          color: isOnline ? const Color(0xFF10B981) : const Color(0xFF00D2FF),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
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

class WalletItem extends StatelessWidget {
  final UserWallet wallet;
  final VoidCallback onTap;
  final VoidCallback onOptions;

  const WalletItem({
    super.key,
    required this.wallet,
    required this.onTap,
    required this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.read<WalletProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF00D2FF)],
                ),
                border: Border.all(color: const Color(0xFF00D2FF), width: 2),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (wallet.active)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0F172A), width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          wallet.name ?? walletProvider.formatWalletAddress(wallet.address),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              walletProvider.formatWalletAddress(wallet.address),
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
            if (wallet.totalValue != null) ...[
              const SizedBox(height: 4),
              Text(
                '\$${wallet.totalValue!.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              wallet.active ? Icons.notifications : Icons.notifications_off,
              color: wallet.active ? const Color(0xFF10B981) : const Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onOptions,
              child: Icon(
                Icons.more_vert,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}