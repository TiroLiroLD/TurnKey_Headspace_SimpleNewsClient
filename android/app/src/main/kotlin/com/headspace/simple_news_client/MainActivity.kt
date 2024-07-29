package com.headspace.simple_news_client

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.headspace.simple_news_client/background_service"
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEngineManager.initialize(this)
        initializeMethodChannel()
        startForegroundService()
        Log.d("MainActivity", "FlutterEngine initialized and MethodChannel set up")
    }

    private fun initializeMethodChannel() {
        FlutterEngineManager.initialize(this)
        val flutterEngine = FlutterEngineManager.flutterEngine ?: return
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    private fun startForegroundService() {
        val intent = Intent(this, MyForegroundService::class.java)
        startService(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
    }
}
