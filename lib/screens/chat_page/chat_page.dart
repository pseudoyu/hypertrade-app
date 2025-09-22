import 'dart:math' as math;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hyper_app/widgets/snack_bar.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Network',
          style: TextStyle(
            color: Color(0xFF00D2FF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildStatsRow(),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const crossAxisCount = 2;
                    const spacing = 16.0;
                    final totalSpacing = spacing * (crossAxisCount - 1);
                    final itemWidth =
                        (constraints.maxWidth - totalSpacing) / crossAxisCount;
                    final desiredHeight =
                        math.max(240.0, itemWidth + 80.0);
                    final childAspectRatio = itemWidth / desiredHeight;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return ChatItem(chat);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
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
            child:
                _buildStatItem('Active Users', '${chats.length}', Icons.people),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFF374151),
          ),
          Expanded(
            child: _buildStatItem(
                'Online Now', '${(chats.length * 0.7).round()}', Icons.circle,
                isOnline: true),
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

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem(this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 根据屏幕宽度动态调整padding和尺寸
          double padding = constraints.maxWidth > 160 ? 16.0 : 12.0;
          double avatarRadius = constraints.maxWidth > 160 ? 28 : 24;
          double fontSize = constraints.maxWidth > 160 ? 16.0 : 14.0;
          double messageFontSize = constraints.maxWidth > 160 ? 13.0 : 12.0;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00D2FF),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF00D2FF).withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(chat.avatar),
                        radius: avatarRadius,
                        backgroundColor: const Color(0xFF374151),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: constraints.maxWidth > 160 ? 16 : 14,
                        height: constraints.maxWidth > 160 ? 16 : 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0F172A),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: constraints.maxWidth > 160 ? 12.0 : 10.0),
                Text(
                  chat.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: constraints.maxWidth > 160 ? 8.0 : 6.0),
                Text(
                  chat.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: messageFontSize,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: constraints.maxWidth > 160 ? 4.0 : 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: const Color(0xFF64748B),
                      size: constraints.maxWidth > 160 ? 14 : 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      chat.time,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: constraints.maxWidth > 160 ? 12.0 : 11.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: constraints.maxWidth > 160 ? 9.0 : 8.0),
                Container(
                  width: double.infinity,
                  height: constraints.maxWidth > 160 ? 40 : 36,
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
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showSnackbar(
                        context,
                        'Follow Request Sent!',
                        'Request sent to ${chat.name}',
                        ContentType.success,
                      );
                    },
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: constraints.maxWidth > 160 ? 14 : 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Chat {
  final String name;
  final String message;
  final String avatar;
  final String time;

  Chat({
    required this.name,
    required this.message,
    required this.avatar,
    required this.time,
  });
}

List<Chat> chats = [
  Chat(
    name: 'vitalik.eth',
    message:
        'Ethereum co-founder. Currently focused on improving ETH scalability and switching to PoS consensus.',
    avatar: 'https://picsum.photos/200/300',
    time: '2:15 PM',
  ),
  Chat(
    name: 'cobie.eth',
    message:
        'Professional crypto trader and investor. Known for alpha calls on emerging DeFi protocols.',
    avatar: 'https://picsum.photos/200/301',
    time: '2:22 PM',
  ),
  Chat(
    name: 'danilocrypto.eth',
    message:
        'DeFi yield farmer and smart money tracker. Sharing profitable farming strategies daily.',
    avatar: 'https://picsum.photos/200/302',
    time: '2:28 PM',
  ),
  Chat(
    name: '0xmaki.eth',
    message:
        'Former SushiSwap core contributor. Now building next-gen DEX infrastructure.',
    avatar: 'https://picsum.photos/200/303',
    time: '2:35 PM',
  ),
  Chat(
    name: 'santiagoroel.eth',
    message:
        'Arbitrage bot operator. Extracting MEV opportunities across multiple chains.',
    avatar: 'https://picsum.photos/200/304',
    time: '2:41 PM',
  ),
  Chat(
    name: 'hayden.eth',
    message:
        'Uniswap founder. Building the future of decentralized exchanges and AMMs.',
    avatar: 'https://picsum.photos/200/305',
    time: '2:47 PM',
  ),
  Chat(
    name: 'kain.eth',
    message:
        'Synthetix founder. Pioneer in synthetic assets and derivatives on Ethereum.',
    avatar: 'https://picsum.photos/200/306',
    time: '2:53 PM',
  ),
  Chat(
    name: 'stani.eth',
    message:
        'Aave founder and CEO. Leading the decentralized lending and borrowing revolution.',
    avatar: 'https://picsum.photos/200/308',
    time: '2:59 PM',
  ),
  Chat(
    name: 'balajis.eth',
    message:
        'Former Coinbase CTO. Angel investor focusing on crypto and network states.',
    avatar: 'https://picsum.photos/200/309',
    time: '3:05 PM',
  ),
  Chat(
    name: 'rleshner.eth',
    message:
        'Compound founder. Created the first major DeFi money market protocol.',
    avatar: 'https://picsum.photos/200/310',
    time: '3:11 PM',
  ),
  Chat(
    name: 'andre.cronje.eth',
    message:
        'DeFi architect behind Yearn Finance and other innovative protocols.',
    avatar: 'https://picsum.photos/200/311',
    time: '3:17 PM',
  ),
  Chat(
    name: 'degen_trader.eth',
    message:
        'High-volume perpetual futures trader. Sharing market analysis and trading signals.',
    avatar: 'https://picsum.photos/200/312',
    time: '3:23 PM',
  ),
];
