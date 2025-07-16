import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';

class ConnectionStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothService>(
      builder: (context, bluetoothService, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: bluetoothService.isBluetoothOn ? Colors.green[100] : Colors.red[100],
          child: Row(
            children: [
              Icon(
                bluetoothService.isBluetoothOn ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                color: bluetoothService.isBluetoothOn ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  bluetoothService.statusMessage,
                  style: TextStyle(
                    color: bluetoothService.isBluetoothOn ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}