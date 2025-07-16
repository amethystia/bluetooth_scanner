import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceModel {
  final String id;
  final String name;
  final String address;
  final int rssi;
  final bool isConnected;
  final List<String> serviceUuids;
  final DateTime lastSeen;
  final String deviceType;

  BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rssi,
    this.isConnected = false,
    this.serviceUuids = const [],
    required this.lastSeen,
    this.deviceType = 'Unknown',
  });

  factory BluetoothDeviceModel.fromScanResult(ScanResult scanResult) {
    return BluetoothDeviceModel(
      id: scanResult.device.remoteId.toString(),
      name: scanResult.device.platformName.isEmpty 
          ? '未知设备' 
          : scanResult.device.platformName,
      address: scanResult.device.remoteId.toString(),
      rssi: scanResult.rssi,
      serviceUuids: scanResult.advertisementData.serviceUuids
          .map((uuid) => uuid.toString())
          .toList(),
      lastSeen: DateTime.now(),
      deviceType: _getDeviceType(scanResult.advertisementData.serviceUuids),
    );
  }

  static String _getDeviceType(List<Guid> serviceUuids) {
    if (serviceUuids.isEmpty) return '未知设备';
    
    final uuidString = serviceUuids.first.toString().toLowerCase();
    
    if (uuidString.contains('180f')) return '电池设备';
    if (uuidString.contains('1800')) return '通用设备';
    if (uuidString.contains('1801')) return '属性设备';
    if (uuidString.contains('180a')) return '设备信息';
    if (uuidString.contains('1812')) return 'HID设备';
    if (uuidString.contains('110a')) return '音频设备';
    if (uuidString.contains('1108')) return '耳机设备';
    
    return '蓝牙设备';
  }

  BluetoothDeviceModel copyWith({
    String? id,
    String? name,
    String? address,
    int? rssi,
    bool? isConnected,
    List<String>? serviceUuids,
    DateTime? lastSeen,
    String? deviceType,
  }) {
    return BluetoothDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      serviceUuids: serviceUuids ?? this.serviceUuids,
      lastSeen: lastSeen ?? this.lastSeen,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  String toString() {
    return 'BluetoothDeviceModel(id: $id, name: $name, rssi: $rssi, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BluetoothDeviceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}