import 'package:flutter/foundation.dart';
import 'dart:io';

class AppConfig {
  // Environment detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;

  // App version and build info
  static const String appVersion = '1.0.0';
  static const String appName = 'SwiftPA';

  // Debug information
  static void printConfig() {
    if (kDebugMode) {
      print('🔧 App Configuration:');
      print('   Environment: ${isProduction ? 'Production' : 'Development'}');
      print('   Platform: ${kIsWeb ? 'Web' : Platform.operatingSystem}');
      print('   App Version: $appVersion');
    }
  }
}
