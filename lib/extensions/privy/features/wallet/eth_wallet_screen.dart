import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:privy_flutter/privy_flutter.dart';

class EthWalletScreen extends StatefulWidget {
  final EmbeddedEthereumWallet ethereumWallet;

  const EthWalletScreen({super.key, required this.ethereumWallet});

  @override
  State<EthWalletScreen> createState() => _EthWalletScreenState();
}

class _EthWalletScreenState extends State<EthWalletScreen> {
  // Controller for the message input TextField.
  final TextEditingController _messageController = TextEditingController();
  // Stores the latest signature generated.
  String? _latestSignature;

  // Updates the UI when the message input changes, to enable/disable the sign button.
  void _onMessageChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  // Copies the latest signature to the clipboard and shows a SnackBar.
  void _copySignatureToClipboard() {
    if (_latestSignature != null && _latestSignature!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _latestSignature!));
      _showCustomSnackBar('Signature copied to clipboard!', Colors.green);
    }
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Signs the message entered by the user using the Ethereum wallet.
  Future<void> _signEthereumMessage() async {
    // ethereumWallet is non-nullable from widget.ethereumWallet
    final messageToSign = _messageController.text.trim();

    // Check if message is empty
    if (messageToSign.isEmpty) {
      _showCustomSnackBar("Please enter a message to sign.", Colors.orange);
      return;
    }

    // Convert the user's message to a hex-encoded Utf8 representation for Ethereum.
    final messageBytes = utf8.encode(messageToSign);
    final String hexMessage =
        '0x${messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join()}';

    final rpcRequest = EthereumRpcRequest(
      method: "personal_sign",
      params: [hexMessage, widget.ethereumWallet.address],
    );

    final result = await widget.ethereumWallet.provider.request(rpcRequest);

    // Handle the result (success or failure) from the signMessage call.
    result.fold(
      onSuccess: (response) {
        final signature = response.data.toString();
        setState(() {
          _latestSignature = signature;
        });
        _showCustomSnackBar("Message signed successfully!", Colors.green);
      },
      onFailure: (error) {
        setState(() {
          _latestSignature = null;
        });
        _showCustomSnackBar("Error signing message: ${error.message}", Colors.red);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Ethereum Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/profile'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletHeader(),
              const SizedBox(height: 24),
              _buildWalletDetails(),
              const SizedBox(height: 32),
              _buildMessageSigningSection(),
              if (_latestSignature != null) ...[
                const SizedBox(height: 32),
                _buildSignatureSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF334155),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0891B2).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ethereum Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "ETH Network",
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wallet Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailItem('Address', widget.ethereumWallet.address),
          if (widget.ethereumWallet.chainId != null) ...[
            const SizedBox(height: 16),
            _buildDetailItem('Chain ID', widget.ethereumWallet.chainId!),
          ],
          if (widget.ethereumWallet.recoveryMethod != null) ...[
            const SizedBox(height: 16),
            _buildDetailItem('Recovery Method', widget.ethereumWallet.recoveryMethod!),
          ],
          const SizedBox(height: 16),
          _buildDetailItem('HD Index', widget.ethereumWallet.hdWalletIndex.toString()),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getIconForLabel(label),
              color: const Color(0xFF00D2FF),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF374151).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  _showCustomSnackBar('$label copied to clipboard!', Colors.green);
                },
                child: Icon(
                  Icons.copy,
                  size: 16,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Address':
        return Icons.fingerprint;
      case 'Chain ID':
        return Icons.link;
      case 'Recovery Method':
        return Icons.security;
      case 'HD Index':
        return Icons.numbers;
      default:
        return Icons.info;
    }
  }

  Widget _buildMessageSigningSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sign Message",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Message to Sign',
              labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
              hintText: 'Enter your message here...',
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF374151)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF374151)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0891B2)),
              ),
            ),
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _messageController.text.trim().isEmpty
                        ? null
                        : const LinearGradient(
                            colors: [
                              Color(0xFF0891B2),
                              Color(0xFF00D2FF),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Sign Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _messageController.text.trim().isEmpty ? null : _signEthereumMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _messageController.text.trim().isEmpty
                          ? const Color(0xFF374151)
                          : Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Latest Signature",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _copySignatureToClipboard,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0891B2).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF00D2FF),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      _latestSignature!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.copy,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
