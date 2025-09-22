import 'dart:async';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hyper_app/extensions/privy/core/navigation_manager.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';
import 'package:hyper_app/screens/app_router.dart';
import 'package:hyper_app/widgets/particle_background.dart';
import 'package:hyper_app/widgets/animated_gradient_button.dart';
import 'package:privy_flutter/privy_flutter.dart';

class PrivyLoginScreen extends StatefulWidget {
  const PrivyLoginScreen({super.key});

  @override
  PrivyLoginScreenState createState() => PrivyLoginScreenState();
}

class PrivyLoginScreenState extends State<PrivyLoginScreen> {
  bool _isPrivyReady = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initializePrivyAndAwaitReady();
  }

  Future<void> _initializePrivyAndAwaitReady() async {
    try {
      // Initialize Privy first
      privyManager.initializePrivy();
      // Then wait for it to be ready
      await privyManager.privy.awaitReady();

      // Update state to indicate Privy is ready
      if (mounted) {
        setState(() {
          _isPrivyReady = true;
        });
        // Set up the auth listener directly in the PrivyLoginScreen
        _setupAuthListener();
      }
    } catch (e) {
      debugPrint("Error initializing Privy: $e");
    }
  }

  /// Set up listener for auth state changes
  void _setupAuthListener() {
    // Cancel any existing subscription
    _authSubscription?.cancel();

    // Subscribe to auth state changes
    _authSubscription = privyManager.privy.authStateStream.listen((state) {
      debugPrint('Auth state changed: $state');

      if (state is Authenticated && mounted) {
        debugPrint('User authenticated: ${state.user.id}');
        // Navigate to authenticated screen with smooth transition
        navigationManager.navigateToAuthenticatedScreen(context);
      }
    });
  }

  @override
  void dispose() {
    // Clean up subscription when widget is disposed
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B23),
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Welcome to Privy",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: ParticleBackground(
        particleCount: 60,
        colors: const [
          Color(0xFF00D4FF),
          Color(0xFF00FF88),
          Color(0xFF8B5CF6),
        ],
        child: Center(
          child: _isPrivyReady
              // Main content when Privy is ready
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Privy Logo from assets
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF00D4FF).withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo/splash.png',
                        height: 180,
                        width: 250,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Larger Title using theme's headlineLarge
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        "Hyperliquid Trading",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedGradientButton(
                      onPressed: () {
                        context.go(AppRouter.emailAuthPath);
                      },
                      text: 'Login With Email',
                      gradientColors: const [
                        Color(0xFF00D4FF),
                        Color(0xFF00FF88),
                      ],
                    ),
                  ],
                )
              // Loading indicator when Privy is not ready
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Custom loading indicator with gradient
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Using custom text style
                    const Text(
                      "Initializing Trading Platform...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
