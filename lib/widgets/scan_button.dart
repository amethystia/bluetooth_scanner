import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothService>(
      builder: (context, bluetoothService, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: bluetoothService.isScanning
                ? bluetoothService.stopScan
                : bluetoothService.startScan,
            icon: bluetoothService.isScanning
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.search),
            label: Text(
              bluetoothService.isScanning ? '停止扫描' : '开始扫描',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: bluetoothService.isScanning ? Colors.red : Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}