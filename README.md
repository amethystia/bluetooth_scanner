这是一个基于Flutter开发的蓝牙设备扫描应用，主要功能包括蓝牙设备搜索、连接、断开连接等。使用flutter_blue_plus库实现蓝牙功能。
技术栈

Flutter SDK: 3.19.0+
flutter_blue_plus: ^1.31.15
permission_handler: ^11.3.1
状态管理: Provider / setState
平台支持: Android, iOS

项目结构
bluetooth_scanner/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── bluetooth_device_model.dart
│   │   └── scan_result_model.dart
│   ├── services/
│   │   ├── bluetooth_service.dart
│   │   └── permission_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── device_list_screen.dart
│   │   └── device_detail_screen.dart
│   ├── widgets/
│   │   ├── device_tile.dart
│   │   ├── scan_button.dart
│   │   └── connection_status.dart
│   └── utils/
│       ├── constants.dart
│       └── helpers.dart
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml
├── ios/
│   └── Runner/
│       └── Info.plist
├── pubspec.yaml
└── README.md

核心功能说明
1. 蓝牙扫描功能

权限请求: 自动请求必要的蓝牙和位置权限
实时扫描: 使用flutter_blue_plus进行设备扫描
信号强度显示: 根据RSSI值显示信号强度
设备信息: 显示设备名称、MAC地址、服务UUID等

2. 设备连接管理

连接/断开: 支持与扫描到的设备进行连接和断开
连接状态: 实时显示设备连接状态
错误处理: 完善的错误处理机制

3. 用户界面

Material Design: 遵循Material Design设计规范
响应式布局: 适配不同屏幕尺寸
状态指示: 清晰的蓝牙状态和扫描状态显示

测试与调试
1. 调试命令
bash# 开启调试模式
flutter run --debug

# 查看日志
flutter logs

# 性能分析
flutter run --profile
2. 常见问题

权限问题: 确保在设备设置中授予了蓝牙权限
扫描失败: 检查蓝牙是否开启，权限是否正确配置
连接超时: 确保目标设备支持连接且在范围内

未来扩展

设备详情页: 显示更多设备信息和服务
数据传输: 实现与连接设备的数据交换
设备管理: 添加已连接设备的管理功能
历史记录: 记录扫描和连接历史

技术支持

Flutter官方文档: https://flutter.dev/docs
flutter_blue_plus: https://pub.dev/packages/flutter_blue_plus
permission_handler: https://pub.dev/packages/permission_handler
