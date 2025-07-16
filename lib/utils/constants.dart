class AppConstants {
  // 应用信息
  static const String appName = '蓝牙扫描器';
  static const String appVersion = '1.0.0';
  
  // 蓝牙扫描设置
  static const int scanTimeoutSeconds = 10;
  static const int connectionTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  
  // 信号强度阈值
  static const int excellentSignalThreshold = -60;
  static const int goodSignalThreshold = -70;
  static const int fairSignalThreshold = -80;
  
  // 颜色定义
  static const Map<String, int> signalColors = {
    'excellent': 0xFF4CAF50, // 绿色
    'good': 0xFF8BC34A,      // 浅绿色
    'fair': 0xFFFF9800,      // 橙色
    'poor': 0xFFF44336,      // 红色
  };
  
  // 常见蓝牙服务UUID
  static const Map<String, String> commonServices = {
    '00001800-0000-1000-8000-00805f9b34fb': 'Generic Access',
    '00001801-0000-1000-8000-00805f9b34fb': 'Generic Attribute',
    '0000180a-0000-1000-8000-00805f9b34fb': 'Device Information',
    '0000180f-0000-1000-8000-00805f9b34fb': 'Battery Service',
    '00001812-0000-1000-8000-00805f9b34fb': 'Human Interface Device',
    '0000110a-0000-1000-8000-00805f9b34fb': 'Audio Source',
    '0000110b-0000-1000-8000-00805f9b34fb': 'Audio Sink',
    '00001108-0000-1000-8000-00805f9b34fb': 'Headset',
    '0000111e-0000-1000-8000-00805f9b34fb': 'Hands-Free',
    '00001200-0000-1000-8000-00805f9b34fb': 'PnP Information',
  };
  
  // 设备类型映射
  static const Map<String, String> deviceTypes = {
    'phone': '手机',
    'computer': '电脑',
    'headset': '耳机',
    'speaker': '扬声器',
    'keyboard': '键盘',
    'mouse': '鼠标',
    'gamepad': '游戏手柄',
    'fitness': '健身设备',
    'watch': '智能手表',
    'unknown': '未知设备',
  };
  
  // 错误消息
  static const Map<String, String> errorMessages = {
    'bluetooth_off': '蓝牙未开启，请先开启蓝牙',
    'permission_denied': '权限被拒绝，请在设置中授予蓝牙权限',
    'scan_failed': '扫描失败，请重试',
    'connection_failed': '连接失败，请检查设备状态',
    'service_discovery_failed': '服务发现失败',
    'characteristic_read_failed': '特征值读取失败',
    'characteristic_write_failed': '特征值写入失败',
  };
  
  // 成功消息
  static const Map<String, String> successMessages = {
    'scan_started': '开始扫描蓝牙设备',
    'scan_stopped': '扫描已停止',
    'device_connected': '设备连接成功',
    'device_disconnected': '设备已断开连接',
    'service_discovered': '服务发现完成',
  };
  
  // 权限说明
  static const Map<String, String> permissionRationales = {
    'bluetooth_scan': '需要蓝牙扫描权限来发现附近的蓝牙设备',
    'bluetooth_connect': '需要蓝牙连接权限来与设备建立连接',
    'bluetooth_advertise': '需要蓝牙广播权限来让设备可被发现',
    'location': '需要位置权限来扫描蓝牙设备（Android系统要求）',
  };
}

class BluetoothConstants {
  // 蓝牙状态
  static const String stateOff = 'off';
  static const String stateOn = 'on';
  static const String stateScanning = 'scanning';
  static const String stateConnecting = 'connecting';
  static const String stateConnected = 'connected';
  
  // 连接状态
  static const String connectionStateDisconnected = 'disconnected';
  static const String connectionStateConnecting = 'connecting';
  static const String connectionStateConnected = 'connected';
  static const String connectionStateDisconnecting = 'disconnecting';
}