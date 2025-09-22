import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hyper_app/helper/upload.dart';
import 'package:hyper_app/models/login_json.dart';
import 'package:hyper_app/provider/auth_provider.dart';
import 'package:hyper_app/provider/hypertrade_provider.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';
import 'package:hyper_app/helper/token_storage_service.dart';
import 'package:hyper_app/screens/app_router.dart';
import 'package:hyper_app/widgets/loading.dart';
import 'package:hyper_app/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  File? _image;
  final picker = ImagePicker();
  UserData? userInfo;

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (_image != null) {
      await _uploadAvatar();
    }
  }

  Future<void> _uploadAvatar() async {
    if (_image == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    if (userToken == null) {
      showSnackbar(
          context, 'Error', 'User token not found.', ContentType.failure);
      return;
    }

    try {
      String uploadedUrl = await uploadAvatar(
        file: _image!,
        token: userToken,
      );

      showSnackbar(context, 'Success', 'Avatar uploaded successfully!',
          ContentType.success);

      setState(() {
        // 你可以在此更新用户的头像URL
        print('Uploaded Avatar URL: $uploadedUrl');
      });
    } catch (e) {
      showSnackbar(
          context, 'Error', 'Failed to upload avatar.', ContentType.failure);
      print('Upload failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('📱 [ProfilePage] initState called');
    // requestCollectionVCListData();
    // renewUserData();

    // Fetch HyperTrade user info when profile page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('📱 [ProfilePage] addPostFrameCallback executing...');
      debugPrint('📱 [ProfilePage] Calling fetchHyperTradeUserInfo...');
      context.read<HyperTradeProvider>().fetchHyperTradeUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 [ProfilePage] build method called');
    return Scaffold(
      body: SafeArea(
        child: Consumer2<AuthProvider, HyperTradeProvider>(
          builder: (context, authProvider, hyperTradeProvider, child) {
            debugPrint('📱 [ProfilePage] Consumer2 builder called');
            debugPrint('📱 [ProfilePage] AuthProvider - isFetching: ${authProvider.isFetchingUserInfo}, userData: ${authProvider.userData != null ? 'exists' : 'null'}');
            debugPrint('📱 [ProfilePage] HyperTradeProvider - isLoading: ${hyperTradeProvider.isLoading}, error: ${hyperTradeProvider.error}, user: ${hyperTradeProvider.hyperTradeUser != null ? 'exists' : 'null'}');

            if (authProvider.isFetchingUserInfo) {
              debugPrint('📱 [ProfilePage] Showing auth loading widget');
              return const Center(
                child: LoadingWidget(),
              );
            }
            if (authProvider.userData == null) {
              debugPrint('📱 [ProfilePage] Showing user data not found');
              return const Center(
                child: Text('User data not found'),
              );
            }
            return Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'My Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 114, 189, 250),
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Image.asset(
                            'assets/logo/splash.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                          )
                        : null,
                  ),
                  // Positioned(
                  //   right: 0,
                  //   bottom: 0,
                  //   child: GestureDetector(
                  //     onTap: getImage,
                  //     child: const CircleAvatar(
                  //       radius: 15,
                  //       backgroundColor: Colors.blue,
                  //       child: Icon(Icons.edit, size: 15, color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                authProvider.userData!.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                authProvider.userData!.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // HyperTrade Wallet Info Section
              _buildHyperTradeWalletInfo(hyperTradeProvider),

              // Debug Info Section (for development)
              _buildDebugInfo(hyperTradeProvider),

              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile('My Collection VC', Icons.people,
                        onTap: () => context.push('/collectionvc')),
                    // _buildListTile('Appearance', Icons.palette,
                    //     onTap: () => context.goNamed('settings')),
                    _buildListTile('Privacy & Security', Icons.security,
                        onTap: () => context.push('/privacy')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    debugPrint('🚪 [ProfilePage] Logout button pressed');

                    try {
                      // Clear SharedPreferences
                      debugPrint('🚪 [ProfilePage] Clearing SharedPreferences...');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('user_token');
                      await prefs.remove('user_name');
                      await prefs.remove('user_company_name');
                      await prefs.remove('user_title');
                      await prefs.remove('user_email');

                      // Clear HyperTrade data
                      if (mounted) {
                        debugPrint('🚪 [ProfilePage] Clearing HyperTrade data...');
                        await context.read<HyperTradeProvider>().clearUserData();
                      }

                      // Clear Privy authentication
                      debugPrint('🚪 [ProfilePage] Logging out from Privy...');
                      await privyManager.privy.logout();

                      debugPrint('🚪 [ProfilePage] Logout successful, showing snackbar...');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout Successful!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );

                      // Navigate to Privy login screen (first login page)
                      debugPrint('🚪 [ProfilePage] Navigating to Privy login screen...');
                      context.goNamed(AppRouter.homeRoute);

                    } catch (e) {
                      debugPrint('💥 [ProfilePage] Logout error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout error: $e'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, {void Function()? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildHyperTradeWalletInfo(HyperTradeProvider hyperTradeProvider) {
    debugPrint('💳 [ProfilePage] _buildHyperTradeWalletInfo called');
    debugPrint('💳 [ProfilePage] Provider state - isLoading: ${hyperTradeProvider.isLoading}, error: ${hyperTradeProvider.error}, user: ${hyperTradeProvider.hyperTradeUser}');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.blue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'HyperTrade Wallet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hyperTradeProvider.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (hyperTradeProvider.error != null)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  onPressed: () => hyperTradeProvider.retry(),
                  tooltip: 'Retry',
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (hyperTradeProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Loading wallet info...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else if (hyperTradeProvider.error != null)
            Column(
              children: [
                Text(
                  'Error: ${hyperTradeProvider.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => hyperTradeProvider.retry(),
                  child: const Text('Retry'),
                ),
              ],
            )
          else if (hyperTradeProvider.hyperTradeUser != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  'HyperTrade ID',
                  hyperTradeProvider.hyperTradeUser!.id.toString(),
                  Icons.person,
                ),
                _buildInfoRow(
                  'Privy ID',
                  hyperTradeProvider.hyperTradeUser!.privyId,
                  Icons.fingerprint,
                ),
                _buildInfoRow(
                  'Created At',
                  hyperTradeProvider.hyperTradeUser!.createdAt.toString(),
                  Icons.schedule,
                ),
              ],
            )
          else
            const Text(
              'No wallet information available',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }

  Widget _buildDebugInfo(HyperTradeProvider hyperTradeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.orange, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Debug Info',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  debugPrint('🔄 [ProfilePage] Manual retry button pressed');
                  hyperTradeProvider.retry();
                },
                child: const Text('Retry', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('IsLoading: ${hyperTradeProvider.isLoading}', style: const TextStyle(fontSize: 12)),
          Text('Error: ${hyperTradeProvider.error ?? 'None'}', style: const TextStyle(fontSize: 12)),
          Text('User exists: ${hyperTradeProvider.hyperTradeUser != null}', style: const TextStyle(fontSize: 12)),
          Text('API URL: https://hypertrade-api.pseudoyu.com/users/me', style: const TextStyle(fontSize: 12)),
          Text('Privy initialized: ${privyManager.isInitialized}', style: const TextStyle(fontSize: 12)),

          // Token information
          FutureBuilder<Map<String, dynamic>>(
            future: TokenStorageService.getTokenInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tokenInfo = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text('Token Info:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Has Token: ${tokenInfo['hasStoredToken']}', style: const TextStyle(fontSize: 11)),
                    Text('Valid: ${tokenInfo['isValid']}', style: const TextStyle(fontSize: 11)),
                    Text('Expires in: ${tokenInfo['timeUntilExpiry']} min', style: const TextStyle(fontSize: 11)),
                  ],
                );
              }
              return const Text('Loading token info...', style: TextStyle(fontSize: 11));
            },
          ),

          if (hyperTradeProvider.hyperTradeUser != null) ...[
            const Divider(),
            Text('Raw JSON:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                hyperTradeProvider.hyperTradeUser!.toJson().toString(),
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
