import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hyper_app/extensions/privy/core/privy_manager.dart';
import 'package:hyper_app/screens/app_router.dart';
import 'package:hyper_app/widgets/particle_background.dart';
import 'package:hyper_app/widgets/animated_gradient_button.dart';
import 'package:hyper_app/widgets/animated_glow_textfield.dart';

class EmailAuthenticationScreen extends StatefulWidget {
  const EmailAuthenticationScreen({super.key});

  @override
  EmailAuthenticationScreenState createState() =>
      EmailAuthenticationScreenState();
}

class EmailAuthenticationScreenState extends State<EmailAuthenticationScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool codeSent = false;
  String? errorMessage;
  bool isLoading = false;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  /// Shows a message using a Snackbar
  void showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor:
            isError ? const Color(0xFFFF4757) : const Color(0xFF00FF88),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Sends OTP to the provided email
  ///
  /// NOTE: To use email authentication, you must enable it in the Privy Dashboard:
  /// https://dashboard.privy.io/apps?page=login-methods
  Future<void> sendCode() async {
    // Get and validate the email input
    String email = emailController.text.trim();
    if (email.isEmpty) {
      showMessage("Please enter your email", isError: true);
      return;
    }

    // Update UI to show loading state and clear any previous errors
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Call Privy SDK to send verification code
      // This makes an API request to Privy's authentication service
      final result = await privyManager.privy.email.sendCode(email);

      // Handle the result using Privy's Result type which has onSuccess and onFailure handlers
      result.fold(
        // Success handler - code was sent successfully
        onSuccess: (_) {
          setState(() {
            codeSent =
                true; // This will trigger UI to show the code input field
            errorMessage = null;
            isLoading = false;
          });
          showMessage("Code sent successfully to $email");
        },
        // Failure handler - something went wrong on Privy's end
        onFailure: (error) {
          setState(() {
            errorMessage = error.message; // Store error message from Privy
            codeSent = false; // Ensure code input remains hidden
            isLoading = false;
          });
          showMessage("Error sending code: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      // Handle unexpected exceptions (network issues, etc.)
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      showMessage("Unexpected error: $e", isError: true);
    }
  }

  /// Logs in using code and email, then navigates to the authenticated screen on success
  Future<void> login() async {
    // Validate the verification code input
    String code = codeController.text.trim();
    if (code.isEmpty) {
      showMessage("Please enter the verification code", isError: true);
      return;
    }

    // Update UI to show loading state and clear previous errors
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Call Privy SDK to verify the code and complete authentication
      // This performs verification against Privy's authentication service
      final result = await privyManager.privy.email.loginWithCode(
        code: code, // The verification code entered by user
        email:
            emailController.text.trim(), // The email address to verify against
      );

      // final result2 = await privyManager.privy.user!.getAccessToken();

      // Handle the authentication result
      result.fold(
        // Success handler - user was authenticated
        onSuccess: (user) async {
          // user is a PrivyUser object containing the authenticated user's information
          setState(() {
            isLoading = false;
          });
          showMessage("Authentication successful!");

          // Navigate to authenticated screen
          if (mounted) {
            String accessToken = "";
            (await user.getAccessToken()).fold(
                onSuccess: (token) {
                  accessToken = token;
                },
                onFailure: (onFailure) {});
            print(accessToken);
            // context.go(AppRouter.au∂thenticatedPath);

            context.go(AppRouter.homePath);
          }
        },
        // Failure handler - authentication failed
        onFailure: (error) {
          // Common failures: invalid code, expired code, too many attempts
          setState(() {
            errorMessage = error.message;
            isLoading = false;
          });
          showMessage("Login error: ${error.message}", isError: true);
        },
      );
    } catch (e) {
      // Handle unexpected exceptions (network issues, etc.)
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      showMessage("Unexpected error: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B23),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Email Authentication',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00D4FF)),
          onPressed: () => context.go(AppRouter.privyLoginPath),
        ),
      ),
      body: ParticleBackground(
        particleCount: 40,
        colors: const [
          Color(0xFF00D4FF),
          Color(0xFF00FF88),
          Color(0xFF8B5CF6),
        ],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Privy Logo
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 50),
                        child: Image.asset(
                          'assets/logo/splash.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),

                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'Login with Email',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // height 30
                      const SizedBox(height: 30),

                      // Email input field
                      AnimatedGlowTextField(
                        controller: emailController,
                        labelText: "Email address",
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        glowColor: const Color(0xFF00D4FF),
                      ),
                      const SizedBox(height: 20),

                      // Send code button
                      AnimatedGradientButton(
                        onPressed: isLoading ? null : sendCode,
                        text: isLoading && !codeSent
                            ? "Sending..."
                            : "Send Verification Code",
                        gradientColors: const [
                          Color(0xFF00D4FF),
                          Color(0xFF00FF88),
                        ],
                        isLoading: isLoading && !codeSent,
                      ),

                      // Show verification code input and login button if code was sent
                      if (codeSent) ...[
                        const SizedBox(height: 30),
                        const Divider(color: Color(0xFF2A2D3A), thickness: 1),
                        const SizedBox(height: 30),
                        AnimatedGlowTextField(
                          controller: codeController,
                          labelText: "Verification Code",
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          glowColor: const Color(0xFF00FF88),
                        ),
                        const SizedBox(height: 20),
                        AnimatedGradientButton(
                          onPressed: isLoading ? null : login,
                          text: isLoading ? "Verifying..." : "Verify & Login",
                          gradientColors: const [
                            Color(0xFF00FF88),
                            Color(0xFF00D4FF),
                          ],
                          isLoading: isLoading && codeSent,
                        ),
                      ],

                      // Show error message if any
                      if (errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF4757).withValues(alpha: 0.1),
                            border: Border.all(
                              color: const Color(0xFFFF4757)
                                  .withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFFF4757),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
