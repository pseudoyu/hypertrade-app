import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/provider/auth_provider.dart';
import 'package:hyper_app/helper/haptic_utils.dart';
import 'package:hyper_app/widgets/custom_text_from_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _verificationCode = '';
  Timer? _timer;
  int _countdown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> requestUserInfoData() async {
    await Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: kDebugMode ? AppBar(title: const Text('Login Page')) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/logo/splash.png',
                  width: 150,
                  height: 150,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Login to hyper_pro',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                CustomTextFormField(
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  prefixIcon: const Icon(Icons.email, color: Colors.blue),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Verification Code',
                        hintText: 'Enter verification Code',
                        prefixIcon:
                            const Icon(Icons.verified, color: Colors.blue),
                        onChanged: (value) {
                          setState(() {
                            _verificationCode = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: (_countdown == 0 && !authProvider.isSending)
                            ? () {
                                HapticUtils.lightTap();
                                if (_email.contains('@')) {
                                  _formKey.currentState!.save();
                                  authProvider
                                      .sendVerificationCode(_email)
                                      .then((_) {
                                    if (!authProvider.isRequestError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Verification code sent')),
                                      );
                                      _startCountdown(); // 开始倒计时
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to send verification code')),
                                      );
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Invalid email')),
                                  );
                                }
                              }
                            : null,
                        child: authProvider.isSending
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child:
                                    CircularProgressIndicator(strokeWidth: 4))
                            : Text(
                                _countdown > 0
                                    ? '$_countdown s'
                                    : 'Send Verification Code',
                                style: const TextStyle(color: Colors.blue),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80.0, vertical: 20.0),
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2.0,
                  ),
                  onPressed: () async {
                    HapticUtils.mediumTap();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      authProvider
                          .verifyCode(_email, _verificationCode)
                          .then((_) async {
                        if (!mounted) return;
                        if (!authProvider.isRequestError) {
                          HapticUtils.heavyTap();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login successful'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          if (authProvider.isOnboarded) {
                            await requestUserInfoData();
                            if (mounted) {
                              context.go('/');
                            }
                          } else {
                            if (mounted) {
                              context.goNamed('onboard');
                            }
                          }
                        } else {
                          HapticUtils.standardVibrate();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid verification code'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: authProvider.isVerifying
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: Colors.black54,
                              )),
                        )
                      : const Text('Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
