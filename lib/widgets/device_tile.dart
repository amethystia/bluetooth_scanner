import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart' as my_service;

class DeviceTile extends StatelessWidget {
  final ScanResult scanResult;
  final VoidCallback? onTap;
  
  const DeviceTile({
    Key? key, 
    required this.scanResult, 
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = scanResult.device;
    final bluetoothService = Provider.of<my_service.BluetoothService>(
      context, 
      listen: false
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.bluetooth,
          color: _getSignalColor(scanResult.rssi),
        ),
        title: Text(
          device.platformName.isEmpty ? '未知设备' : device.platformName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MAC: ${device.remoteId}'),
            Text('信号强度: ${scanResult.rssi} dBm'),
            if (scanResult.advertisementData.serviceUuids.isNotEmpty)
              Text('服务: ${scanResult.advertisementData.serviceUuids.first}'),
          ],
        ),
        trailing: StreamBuilder<BluetoothConnectionState>(
          stream: device.connectionState,
          builder: (context, snapshot) {
            final isConnected = snapshot.data == BluetoothConnectionState.connected;
            return ElevatedButton(
              onPressed: isConnected
                  ? () => bluetoothService.disconnectFromDevice(device)
                  : () => bluetoothService.connectToDevice(device),
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(isConnected ? '断开' : '连接'),
            );
          },
        ),
      ),
    );
  }

  Color _getSignalColor(int rssi) {
    if (rssi > -60) return Colors.green;
    if (rssi > -80) return Colors.orange;
    return Colors.red;
  }
}