import 'package:flutter/material.dart';
import 'package:hyper_app/helper/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // 实例化 ApiService

  bool isLoading = false;
  bool isRequestError = false;
  bool isOnboarded = false;

  // 更新用户信息的方法，所有参数改为可选参数
  Future<void> updateUserInfo({
    String? name,
    String? companyName,
    String? title,
    String? location,
    String? stage,
    String? revenue,
    String? industry,
    String? category,
  }) async {
    _setLoading(true);
    try {
      // 构造请求数据，过滤掉空值的参数
      final data = {
        if (name != null) "name": name,
        if (companyName != null) "company_name": companyName,
        if (title != null) "title": title,
        if (location != null) "location": location,
        if (stage != null) "stage": stage,
        if (revenue != null) "revenue": revenue,
        if (industry != null) "industry": industry,
        if (category != null) "category": category,
      };

      // 发送 PUT 请求更新用户信息
      final response = await _apiService.put('/user/info', data);
      debugPrint(response.toString());

      // 假设请求成功，更新本地共享偏好设置
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (name != null) await prefs.setString('user_name', name);
      if (companyName != null) {
        await prefs.setString('user_company_name', companyName);
      }
      if (title != null) await prefs.setString('user_title', title);
      if (location != null) await prefs.setString('user_location', location);
      if (stage != null) await prefs.setString('user_stage', stage);
      if (revenue != null) await prefs.setString('user_revenue', revenue);
      if (industry != null) await prefs.setString('user_industry', industry);
      if (category != null) await prefs.setString('user_category', category);
      await prefs.setBool('user_onboarded', true);
      // 更新 Onboarded 状态
      _setOnboarded(true);
      _setRequestError(false);
    } catch (error) {
      // 处理请求错误
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  // 更新加载状态的方法
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // 更新错误状态的方法
  void _setRequestError(bool value) {
    isRequestError = value;
    notifyListeners();
  }

  // 更新 Onboarded 状态的方法
  void _setOnboarded(bool value) {
    isOnboarded = value;
    notifyListeners();
  }
}
