import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:math' as math;

class ScanResultModel {
  final String deviceId;
  final String deviceName;
  final int rssi;
  final List<String> serviceUuids;
  final Map<String, dynamic> manufacturerData;
  final DateTime timestamp;
  final bool isConnectable;
  final int txPowerLevel;

  ScanResultModel({
    required this.deviceId,
    required this.deviceName,
    required this.rssi,
    this.serviceUuids = const [],
    this.manufacturerData = const {},
    required this.timestamp,
    this.isConnectable = true,
    this.txPowerLevel = 0,
  });

  factory ScanResultModel.fromFlutterBluePlus(ScanResult scanResult) {
    return ScanResultModel(
      deviceId: scanResult.device.remoteId.toString(),
      deviceName: scanResult.device.platformName.isEmpty 
          ? '未知设备' 
          : scanResult.device.platformName,
      rssi: scanResult.rssi,
      serviceUuids: scanResult.advertisementData.serviceUuids
          .map((uuid) => uuid.toString())
          .toList(),
      manufacturerData: scanResult.advertisementData.manufacturerData
          .map((key, value) => MapEntry(key.toString(), value)),
      timestamp: DateTime.now(),
      isConnectable: scanResult.advertisementData.connectable,
      txPowerLevel: scanResult.advertisementData.txPowerLevel ?? 0,
    );
  }

  // 信号强度等级
  SignalStrength get signalStrength {
    if (rssi > -60) return SignalStrength.excellent;
    if (rssi > -70) return SignalStrength.good;
    if (rssi > -80) return SignalStrength.fair;
    return SignalStrength.poor;
  }

  // 信号强度描述
  String get signalDescription {
    switch (signalStrength) {
      case SignalStrength.excellent:
        return '优秀';
      case SignalStrength.good:
        return '良好';
      case SignalStrength.fair:
        return '一般';
      case SignalStrength.poor:
        return '较差';
    }
  }

  // 距离估算 (大概值)
  double get estimatedDistance {
    if (rssi == 0) return -1.0;
    
    double ratio = (txPowerLevel * 1.0) / rssi;
    if (ratio < 1.0) {
      return math.pow(ratio, 10).toDouble();
    } else {
      double accuracy = (0.89976) * math.pow(ratio, 7.7095) + 0.111;
      return accuracy;
    }
  }

  @override
  String toString() {
    return 'ScanResultModel(deviceId: $deviceId, deviceName: $deviceName, rssi: $rssi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResultModel && other.deviceId == deviceId;
  }

  @override
  int get hashCode => deviceId.hashCode;
}

enum SignalStrength { excellent, good, fair, poor }