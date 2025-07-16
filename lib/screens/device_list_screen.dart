import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/device_tile.dart';
import 'device_detail_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as flutter_blue;

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  String _searchQuery = '';
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设备列表'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索设备名称或地址...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // 过滤器标签
          if (_filterType != 'all')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    label: Text('过滤: ${_getFilterLabel(_filterType)}'),
                    onDeleted: () {
                      setState(() {
                        _filterType = 'all';
                      });
                    },
                  ),
                ],
              ),
            ),
          
          // 设备列表
          Expanded(
            child: Consumer<BluetoothService>(
              builder: (context, bluetoothService, child) {
                final filteredDevices = _filterDevices(
                  bluetoothService.scanResults,
                  _searchQuery,
                  _filterType,
                );
                
                if (filteredDevices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.device_unknown,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty 
                              ? '没有找到设备' 
                              : '没有匹配的设备',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: filteredDevices.length,
                  itemBuilder: (context, index) {
                    final scanResult = filteredDevices[index];
                    return DeviceTile(
                      scanResult: scanResult,
                      onTap: () => _navigateToDeviceDetail(scanResult),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<flutter_blue.ScanResult> _filterDevices(List<flutter_blue.ScanResult> devices, String query, String filterType) {
    return devices.where((scanResult) {
      final device = scanResult.device;
      final deviceName = device.platformName.toLowerCase();
      final deviceAddress = device.remoteId.toString().toLowerCase();
      final searchLower = query.toLowerCase();
      
      // 搜索过滤
      bool matchesSearch = query.isEmpty || 
                          deviceName.contains(searchLower) ||
                          deviceAddress.contains(searchLower);
      
      // 类型过滤
      bool matchesFilter = true;
      switch (filterType) {
        case 'connected':
          // 这里需要检查设备连接状态
          break;
        case 'strong_signal':
          matchesFilter = scanResult.rssi > -60;
          break;
        case 'weak_signal':
          matchesFilter = scanResult.rssi <= -80;
          break;
        case 'named':
          matchesFilter = device.platformName.isNotEmpty;
          break;
        case 'unnamed':
          matchesFilter = device.platformName.isEmpty;
          break;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('过滤选项'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('all', '全部设备'),
              _buildFilterOption('connected', '已连接设备'),
              _buildFilterOption('strong_signal', '强信号设备'),
              _buildFilterOption('weak_signal', '弱信号设备'),
              _buildFilterOption('named', '已命名设备'),
              _buildFilterOption('unnamed', '未命名设备'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _filterType,
      onChanged: (String? newValue) {
        setState(() {
          _filterType = newValue ?? 'all';
        });
        Navigator.of(context).pop();
      },
    );
  }

  String _getFilterLabel(String filterType) {
    switch (filterType) {
      case 'connected': return '已连接';
      case 'strong_signal': return '强信号';
      case 'weak_signal': return '弱信号';
      case 'named': return '已命名';
      case 'unnamed': return '未命名';
      default: return '全部';
    }
  }

  void _navigateToDeviceDetail(flutter_blue.ScanResult scanResult) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(scanResult: scanResult),
      ),
    );
  }
}