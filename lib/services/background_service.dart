import 'package:flutter/services.dart';

class BackgroundService {
  static const MethodChannel _channel = MethodChannel('com.headspace.simple_news_client/background_service');

  static Future<void> startService() async {
    await _channel.invokeMethod('startService');
  }

  static Future<void> stopService() async {
    await _channel.invokeMethod('stopService');
  }
}
