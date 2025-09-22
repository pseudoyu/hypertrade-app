import 'package:flutter/material.dart';
import 'package:hyper_app/helper/http_service.dart';
import 'package:hyper_app/models/login_json.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // 实例化ApiService

  late LoginJson userInfo;
  UserData? userData;

  bool isSending = false;
  bool isVerifying = false;
  bool isRequestError = false;
  bool isOnboarded = false;

  bool isFetchingUserInfo = false;

  Future<void> sendVerificationCode(String email) async {
    _setSending(true);
    try {
      await _apiService.post('/user/verify-code?email=$email', {});
      // 如果返回200，执行成功逻辑
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setSending(false);
    }
  }

  Future<void> verifyCode(String email, String verificationCode) async {
    _setVerifying(true);
    try {
      final response = await _apiService.post(
        '/user/login',
        {'email': email, 'verify_code': verificationCode},
      );
      userInfo = LoginJson.fromJson(response['data']);
      // 缓存
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', userInfo.token);

      await prefs.setBool(
          'user_onboarded', userInfo.userData?.isOnboarded ?? false);
      _setOnboarded(userInfo.userData?.isOnboarded ?? false);
      if (userInfo.userData!.isOnboarded) {
        await prefs.setString('user_name', userInfo.userData?.name ?? '');
        await prefs.setString(
            'user_company_name', userInfo.userData?.companyName ?? '');
        await prefs.setString('user_title', userInfo.userData?.title ?? '');
        await prefs.setString('user_email', userInfo.userData?.email ?? '');
        await prefs.setString(
            'user_location', userInfo.userData?.location ?? '');
        await prefs.setString('user_stage', userInfo.userData?.stage ?? '');
        await prefs.setString('user_revenue', userInfo.userData?.revenue ?? '');
        await prefs.setString(
            'user_industry', userInfo.userData?.industry ?? '');
        await prefs.setString(
            'user_category', userInfo.userData?.category ?? '');
      }
      // 如果返回200，执行成功逻辑
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setVerifying(false);
    }
  }

  Future<void> fetchUserInfo() async {
    _setIsFetchingUserInfo(true);
    try {
      // Assuming the ApiService has a method for GET requests
      final response = await _apiService.get('/user/info');
      userData = UserData.fromJson(response['data']);
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setIsFetchingUserInfo(false);
    }
  }

  void _setSending(bool value) {
    isSending = value;
    notifyListeners();
  }

  void _setVerifying(bool value) {
    isVerifying = value;
    notifyListeners();
  }

  void _setRequestError(bool value) {
    isRequestError = value;
    notifyListeners();
  }

  void _setOnboarded(bool value) {
    isOnboarded = value;
    notifyListeners();
  }

  void _setIsFetchingUserInfo(bool value) {
    isFetchingUserInfo = value;
    // notifyListeners();
  }
}
