import 'package:flutter/material.dart';

/// 响应式布局工具类
/// 用于解决小屏幕溢出问题，提供统一的响应式设计方案
class ResponsiveHelper {
  /// 小屏幕宽度阈值
  static const double smallScreenThreshold = 160.0;
  
  /// 超小屏幕宽度阈值  
  static const double tinyScreenThreshold = 120.0;

  /// 根据屏幕宽度获取响应式字体大小
  /// [normalSize] 正常屏幕字体大小
  /// [smallSize] 小屏幕字体大小
  /// [tinySize] 超小屏幕字体大小(可选)
  static double getResponsiveFontSize(
    double width,
    double normalSize,
    double smallSize, {
    double? tinySize,
  }) {
    if (tinySize != null && width <= tinyScreenThreshold) {
      return tinySize;
    }
    return width > smallScreenThreshold ? normalSize : smallSize;
  }

  /// 根据屏幕宽度获取响应式间距
  /// [normalSpacing] 正常屏幕间距
  /// [smallSpacing] 小屏幕间距
  static double getResponsiveSpacing(
    double width,
    double normalSpacing,
    double smallSpacing,
  ) {
    return width > smallScreenThreshold ? normalSpacing : smallSpacing;
  }

  /// 根据屏幕宽度获取响应式padding
  /// [normalPadding] 正常屏幕padding
  /// [smallPadding] 小屏幕padding
  static EdgeInsets getResponsivePadding(
    double width,
    EdgeInsets normalPadding,
    EdgeInsets smallPadding,
  ) {
    return width > smallScreenThreshold ? normalPadding : smallPadding;
  }

  /// 创建安全的Text组件，自动处理溢出
  /// [text] 文本内容
  /// [style] 文本样式
  /// [maxLines] 最大行数，默认1
  /// [overflow] 溢出处理方式，默认省略号
  /// [textAlign] 文本对齐方式
  static Widget safeText(
    String text, {
    TextStyle? style,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  /// 创建响应式Text组件
  /// [text] 文本内容
  /// [width] 当前容器宽度
  /// [normalStyle] 正常屏幕样式
  /// [smallStyle] 小屏幕样式
  /// [maxLines] 最大行数
  /// [textAlign] 文本对齐方式
  static Widget responsiveText(
    String text,
    double width,
    TextStyle normalStyle,
    TextStyle smallStyle, {
    int maxLines = 1,
    TextAlign? textAlign,
  }) {
    final style = width > smallScreenThreshold ? normalStyle : smallStyle;
    return safeText(
      text,
      style: style,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  /// 判断是否为小屏幕
  static bool isSmallScreen(double width) {
    return width <= smallScreenThreshold;
  }

  /// 判断是否为超小屏幕
  static bool isTinyScreen(double width) {
    return width <= tinyScreenThreshold;
  }

  /// 创建响应式容器高度
  /// [width] 当前容器宽度
  /// [normalHeight] 正常屏幕高度
  /// [smallHeight] 小屏幕高度
  static double getResponsiveHeight(
    double width,
    double normalHeight,
    double smallHeight,
  ) {
    return width > smallScreenThreshold ? normalHeight : smallHeight;
  }

  /// 创建响应式图标大小
  /// [width] 当前容器宽度
  /// [normalSize] 正常屏幕图标大小
  /// [smallSize] 小屏幕图标大小
  static double getResponsiveIconSize(
    double width,
    double normalSize,
    double smallSize,
  ) {
    return width > smallScreenThreshold ? normalSize : smallSize;
  }
}