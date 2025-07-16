import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class BluetoothService extends ChangeNotifier {
  List<ScanResult> _scanResults = [];
  String serviceUuid='';
  bool _isScanning = false;
  bool _isBluetoothOn = false;
  String _statusMessage = '';
  String get uuid => serviceUuid; // assuming there's a serviceUuid field
  List<ScanResult> get scanResults => _scanResults;
  bool get isScanning => _isScanning;
  bool get isBluetoothOn => _isBluetoothOn;
  String get statusMessage => _statusMessage;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  BluetoothDevice? _connectedDevice;

  BluetoothService() {
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    // 检查蓝牙状态
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      _isBluetoothOn = state == BluetoothAdapterState.on;
      _updateStatus();
      notifyListeners();
    });

    // 监听扫描结果
    FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    });

    // 监听扫描状态
    FlutterBluePlus.isScanning.listen((scanning) {
      _isScanning = scanning;
      notifyListeners();
    });
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      return statuses.values.every((status) => status.isGranted);
    } else if (Platform.isIOS) {
      var status = await Permission.bluetooth.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> startScan() async {
    if (!_isBluetoothOn) {
      _statusMessage = '请打开蓝牙';
      notifyListeners();
      return;
    }

    bool permissionGranted = await requestPermissions();
    if (!permissionGranted) {
      _statusMessage = '需要蓝牙权限';
      notifyListeners();
      return;
    }

    try {
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 10),
        androidUsesFineLocation: false,
      );
      _statusMessage = '正在扫描...';
    } catch (e) {
      _statusMessage = '扫描失败: $e';
    }
    notifyListeners();
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    _statusMessage = '扫描已停止';
    notifyListeners();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      _statusMessage = '已连接到 ${device.platformName}';
    } catch (e) {
      _statusMessage = '连接失败: $e';
    }
    notifyListeners();
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      if (_connectedDevice?.remoteId == device.remoteId) {
        _connectedDevice = null;
      }
      _statusMessage = '已断开连接';
    } catch (e) {
      _statusMessage = '断开连接失败: $e';
    }
    notifyListeners();
  }

  void _updateStatus() {
    if (_isBluetoothOn) {
      _statusMessage = '蓝牙已开启';
    } else {
      _statusMessage = '蓝牙已关闭';
    }
  }
}