import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../models/scan_result_model.dart';
import '../utils/helpers.dart';
import '../services/bluetooth_service.dart' as my_bluetooth_service;
class DeviceDetailScreen extends StatefulWidget {
  final ScanResult scanResult;

  const DeviceDetailScreen({Key? key, required this.scanResult}) : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  List<my_bluetooth_service.BluetoothService> _services = [];
  bool _isLoadingServices = false;
  late ScanResultModel _scanResultModel;

  @override
  void initState() {
    super.initState();
    _scanResultModel = ScanResultModel.fromFlutterBluePlus(widget.scanResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_scanResultModel.deviceName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshDeviceInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceInfoCard(),
            SizedBox(height: 16),
            _buildSignalInfoCard(),
            SizedBox(height: 16),
            _buildConnectionCard(),
            SizedBox(height: 16),
            _buildServicesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '设备信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow('设备名称', _scanResultModel.deviceName),
            _buildInfoRow('设备地址', _scanResultModel.deviceId),
            _buildInfoRow('可连接', _scanResultModel.isConnectable ? '是' : '否'),
            _buildInfoRow('发现时间', Helpers.formatDateTime(_scanResultModel.timestamp)),
            if (_scanResultModel.manufacturerData.isNotEmpty)
              _buildInfoRow('制造商数据', _scanResultModel.manufacturerData.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '信号信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow('信号强度', '${_scanResultModel.rssi} dBm'),
            _buildInfoRow('信号等级', _scanResultModel.signalDescription),
            _buildInfoRow('发射功率', '${_scanResultModel.txPowerLevel} dBm'),
            if (_scanResultModel.estimatedDistance > 0)
              _buildInfoRow('估算距离', '${_scanResultModel.estimatedDistance.toStringAsFixed(1)} 米'),
            SizedBox(height: 8),
            _buildSignalStrengthIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '连接控制',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            StreamBuilder<BluetoothConnectionState>(
              stream: widget.scanResult.device.connectionState,
              builder: (context, snapshot) {
                final isConnected = snapshot.data == BluetoothConnectionState.connected;
                final isConnecting = snapshot.data == BluetoothConnectionState.connecting;
                
                return Column(
                  children: [
                    _buildInfoRow('连接状态', _getConnectionStateText(snapshot.data)),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isConnecting ? null : () => _toggleConnection(isConnected),
                        child: isConnecting
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('连接中...'),
                                ],
                              )
                            : Text(isConnected ? '断开连接' : '连接设备'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConnected ? Colors.red : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '服务列表',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isLoadingServices)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            SizedBox(height: 12),
            if (_scanResultModel.serviceUuids.isNotEmpty)
              Column(
                children: _scanResultModel.serviceUuids.map((uuid) {
                  return _buildServiceTile(uuid);
                }).toList(),
              )
            else if (_services.isNotEmpty)
              Column(
                children: _services.map((service) {
                  return _buildServiceTile(service.serviceUuid.toString());
                }).toList(),
              )
            else
              Text(
                '没有发现服务信息',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalStrengthIndicator() {
    final strength = _scanResultModel.signalStrength;
    final color = _getSignalColor(strength);
    final percentage = _getSignalPercentage(_scanResultModel.rssi);
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            SizedBox(width: 8),
            Text('${(percentage * 100).toInt()}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTile(String uuid) {
    return ListTile(
      leading: Icon(Icons.settings_bluetooth),
      title: Text(Helpers.getServiceName(uuid)),
      subtitle: Text(uuid),
      dense: true,
    );
  }

  Color _getSignalColor(SignalStrength strength) {
    switch (strength) {
      case SignalStrength.excellent:
        return Colors.green;
      case SignalStrength.good:
        return Colors.lightGreen;
      case SignalStrength.fair:
        return Colors.orange;
      case SignalStrength.poor:
        return Colors.red;
    }
  }

  double _getSignalPercentage(int rssi) {
    if (rssi > -50) return 1.0;
    if (rssi < -100) return 0.0;
    return (rssi + 100) / 50.0;
  }

  String _getConnectionStateText(BluetoothConnectionState? state) {
    switch (state) {
      case BluetoothConnectionState.connected:
        return '已连接';
      case BluetoothConnectionState.connecting:
        return '连接中';
      case BluetoothConnectionState.disconnected:
        return '未连接';
      case BluetoothConnectionState.disconnecting:
        return '断开中';
      default:
        return '未知状态';
    }
  }

  void _toggleConnection(bool isConnected) {
    final bluetoothService = Provider.of<my_bluetooth_service.BluetoothService>(context, listen: false);
    
    if (isConnected) {
      bluetoothService.disconnectFromDevice(widget.scanResult.device);
    } else {
      bluetoothService.connectToDevice(widget.scanResult.device);
    }
  }

  void _refreshDeviceInfo() {
    setState(() {
      _scanResultModel = ScanResultModel.fromFlutterBluePlus(widget.scanResult);
    });
  }
}