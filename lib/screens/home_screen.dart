import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/device_tile.dart';
import '../widgets/scan_button.dart';
import '../widgets/connection_status.dart';
import '../screens/device_detail_screen.dart';
import '../screens/device_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButtons = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final showButtons = _scrollController.position.maxScrollExtent > 0;
      if (showButtons != _showScrollButtons) {
        setState(() {
          _showScrollButtons = showButtons;
        });
      }
    }
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('蓝牙扫描器'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            tooltip: '设备列表',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeviceListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<BluetoothService>(
        builder: (context, bluetoothService, child) {
          final deviceCount = bluetoothService.scanResults.length;
          return Column(
            children: [
              // 状态栏，始终显示 ConnectionStatus
              ConnectionStatus(),
              // 扫描按钮
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ScanButton(),
              ),
              // 设备统计信息
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '已发现设备: $deviceCount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (deviceCount > 0)
                      Text(
                        bluetoothService.isScanning ? '扫描中...' : '扫描完成',
                        style: TextStyle(
                          fontSize: 14,
                          color: bluetoothService.isScanning ? Colors.blue : Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
              // 分割线
              Divider(height: 1),
              // 设备列表容器 - 限制高度给底部信息栏更多空间
              Expanded(
                flex: 8, // 占用8/10的空间
                child: bluetoothService.scanResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bluetooth_searching,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '点击扫描按钮开始搜索蓝牙设备',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(bottom: 60), // 为底部信息栏留出空间
                        itemCount: bluetoothService.scanResults.length,
                        itemBuilder: (context, index) {
                          final scanResult = bluetoothService.scanResults[index];
                          return DeviceTile(
                            scanResult: scanResult,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceDetailScreen(scanResult: scanResult),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              // 底部信息栏 - 固定高度，更多空间
              if (deviceCount > 0)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            '点击设备可查看详细信息',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swipe_vertical,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '上下滑动查看更多设备',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}