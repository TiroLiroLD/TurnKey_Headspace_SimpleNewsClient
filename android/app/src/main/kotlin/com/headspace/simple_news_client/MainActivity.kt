package com.headspace.simple_news_client

import android.content.Intent
import android.os.Bundle
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.headspace.simple_news_client/background_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startForegroundService()
                    result.success(null)
                }
                "stopService" -> {
                    stopForegroundService()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startForegroundService()
    }

    private fun startForegroundService() {
        val intent = Intent(this, MyForegroundService::class.java)
        startService(intent)
    }

    private fun stopForegroundService() {
        val intent = Intent(this, MyForegroundService::class.java)
        stopService(intent)
        WorkManager.getInstance(this).cancelUniqueWork("MyUniqueWorker")
    }
}
