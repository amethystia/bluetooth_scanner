import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  /// 格式化日期时间
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
  
  /// 格式化时间（仅时间）
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }
  
  /// 获取信号强度颜色
  static Color getSignalColor(int rssi) {
    if (rssi > AppConstants.excellentSignalThreshold) {
      return Color(AppConstants.signalColors['excellent']!);
    } else if (rssi > AppConstants.goodSignalThreshold) {
      return Color(AppConstants.signalColors['good']!);
    } else if (rssi > AppConstants.fairSignalThreshold) {
      return Color(AppConstants.signalColors['fair']!);
    } else {
      return Color(AppConstants.signalColors['poor']!);
    }
  }
  
  /// 获取信号强度描述
  static String getSignalDescription(int rssi) {
    if (rssi > AppConstants.excellentSignalThreshold) {
      return '优秀';
    } else if (rssi > AppConstants.goodSignalThreshold) {
      return '良好';
    } else if (rssi > AppConstants.fairSignalThreshold) {
      return '一般';
    } else {
      return '较差';
    }
  }
  
  /// 获取信号强度百分比
  static double getSignalPercentage(int rssi) {
    if (rssi > -50) return 1.0;
    if (rssi < -100) return 0.0;
    return (rssi + 100) / 50.0;
  }
  
  /// 根据RSSI估算距离
  static double estimateDistance(int rssi, int txPower) {
    if (rssi == 0) return -1.0;
    
    double ratio = (txPower * 1.0) / rssi;
    if (ratio < 1.0) {
      return math.pow(ratio, 10).toDouble();
    } else {
      double accuracy = (0.89976) * math.pow(ratio, 7.7095) + 0.111;
      return accuracy;
    }
  }
  
  /// 获取服务名称
  static String getServiceName(String uuid) {
    final normalizedUuid = uuid.toLowerCase();
    return AppConstants.commonServices[normalizedUuid] ?? '未知服务';
  }
  
  /// 获取设备类型
  static String getDeviceType(String deviceName, List<String> serviceUuids) {
    final nameLower = deviceName.toLowerCase();
    
    // 根据设备名称判断
    if (nameLower.contains('phone') || nameLower.contains('iphone') || 
        nameLower.contains('android')) {
      return AppConstants.deviceTypes['phone']!;
    }
    if (nameLower.contains('headset') || nameLower.contains('headphone') || 
        nameLower.contains('earphone')) {
      return AppConstants.deviceTypes['headset']!;
    }
    if (nameLower.contains('speaker') || nameLower.contains('音响')) {
      return AppConstants.deviceTypes['speaker']!;
    }
    if (nameLower.contains('keyboard') || nameLower.contains('键盘')) {
      return AppConstants.deviceTypes['keyboard']!;
    }
    if (nameLower.contains('mouse') || nameLower.contains('鼠标')) {
      return AppConstants.deviceTypes['mouse']!;
    }
    if (nameLower.contains('watch') || nameLower.contains('手表')) {
      return AppConstants.deviceTypes['watch']!;
    }
    if (nameLower.contains('fitness') || nameLower.contains('健身')) {
      return AppConstants.deviceTypes['fitness']!;
    }
    
    // 根据服务UUID判断
    for (String uuid in serviceUuids) {
      final normalizedUuid = uuid.toLowerCase();
      if (normalizedUuid.contains('1108') || normalizedUuid.contains('111e')) {
        return AppConstants.deviceTypes['headset']!;
      }
      if (normalizedUuid.contains('1812')) {
        return AppConstants.deviceTypes['keyboard']!;
      }
      if (normalizedUuid.contains('110a') || normalizedUuid.contains('110b')) {
        return AppConstants.deviceTypes['speaker']!;
      }
    }
    
    return AppConstants.deviceTypes['unknown']!;
  }
  
  /// 获取设备图标
  static IconData getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case '手机':
        return Icons.smartphone;
      case '电脑':
        return Icons.computer;
      case '耳机':
        return Icons.headset;
      case '扬声器':
        return Icons.speaker;
      case '键盘':
        return Icons.keyboard;
      case '鼠标':
        return Icons.mouse;
      case '游戏手柄':
        return Icons.gamepad;
      case '健身设备':
        return Icons.fitness_center;
      case '智能手表':
        return Icons.watch;
      default:
        return Icons.bluetooth;
    }
  }
  
  /// 格式化MAC地址
  static String formatMacAddress(String address) {
    if (address.length == 12) {
      return address.replaceAllMapped(
        RegExp(r'(.{2})'),
        (match) => '${match.group(1)}:',
      ).substring(0, 17);
    }
    return address;
  }
}