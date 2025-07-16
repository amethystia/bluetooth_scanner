import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionService {
  static const List<Permission> _androidPermissions = [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.location,
    Permission.locationWhenInUse,
  ];

  static const List<Permission> _iosPermissions = [
    Permission.bluetooth,
    Permission.locationWhenInUse,
  ];

  /// 检查所有必要权限
  static Future<bool> checkAllPermissions() async {
    final permissions = Platform.isAndroid ? _androidPermissions : _iosPermissions;
    
    for (Permission permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  /// 请求所有必要权限
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final permissions = Platform.isAndroid ? _androidPermissions : _iosPermissions;
    return await permissions.request();
  }

  /// 检查单个权限
  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// 请求单个权限
  static Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  /// 获取权限状态描述
  static String getPermissionStatusDescription(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return '已授权';
      case PermissionStatus.denied:
        return '被拒绝';
      case PermissionStatus.restricted:
        return '受限制';
      case PermissionStatus.limited:
        return '有限制';
      case PermissionStatus.permanentlyDenied:
        return '永久拒绝';
      default:
        return '未知状态';
    }
  }

  /// 检查蓝牙权限
  static Future<bool> checkBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final scanPermission = await Permission.bluetoothScan.status;
      final connectPermission = await Permission.bluetoothConnect.status;
      final locationPermission = await Permission.location.status;
      
      return scanPermission.isGranted && 
             connectPermission.isGranted && 
             locationPermission.isGranted;
    } else {
      final bluetoothPermission = await Permission.bluetooth.status;
      return bluetoothPermission.isGranted;
    }
  }

  /// 请求蓝牙权限
  static Future<bool> requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      
      return statuses.values.every((status) => status.isGranted);
    } else {
      final status = await Permission.bluetooth.request();
      return status.isGranted;
    }
  }

  /// 打开应用设置
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// 获取权限请求说明
  static String getPermissionRationale(Permission permission) {
    switch (permission) {
      case Permission.bluetoothScan:
        return '需要蓝牙扫描权限来发现附近的蓝牙设备';
      case Permission.bluetoothConnect:
        return '需要蓝牙连接权限来与设备建立连接';
      case Permission.bluetoothAdvertise:
        return '需要蓝牙广播权限来让设备可被发现';
      case Permission.location:
      case Permission.locationWhenInUse:
        return '需要位置权限来扫描蓝牙设备（系统要求）';
      case Permission.bluetooth:
        return '需要蓝牙权限来使用蓝牙功能';
      default:
        return '需要此权限来正常使用应用功能';
    }
  }
}