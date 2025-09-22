import 'package:flutter/services.dart';

/// 震动反馈工具类
/// 提供多种震动模式以增强用户体验
class HapticUtils {
  /// 轻快震动 - 用于标签切换、轻量交互
  /// 短促、轻柔的震动反馈
  static Future<void> lightTap() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // 静默处理震动失败的情况（用户可能关闭了触觉反馈）
    }
  }

  /// 中等震动 - 用于按钮点击、确认操作
  /// 适中强度、平衡感的震动反馈
  static Future<void> mediumTap() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // 静默处理震动失败的情况
    }
  }

  /// 强烈震动 - 用于重要操作完成、错误提醒
  /// 强烈、明显的震动反馈
  static Future<void> heavyTap() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // 静默处理震动失败的情况
    }
  }

  /// 标准震动 - 通用反馈
  /// 系统默认震动模式
  static Future<void> standardVibrate() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      // 静默处理震动失败的情况
    }
  }

  /// 轻触震动 - 用于细微交互
  /// 最轻的触觉反馈
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // 静默处理震动失败的情况
    }
  }
}