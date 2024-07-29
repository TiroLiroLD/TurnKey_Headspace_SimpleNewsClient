package com.headspace.simple_news_client

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import android.util.Log

object FlutterEngineManager {
    var flutterEngine: FlutterEngine? = null
        private set

    fun initialize(context: Context) {
        if (flutterEngine == null) {
            flutterEngine = FlutterEngine(context).apply {
                dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
            }
            Log.d("FlutterEngineManager", "FlutterEngine initialized")
        } else {
            Log.d("FlutterEngineManager", "FlutterEngine already initialized")
        }
    }

    fun destroy() {
        flutterEngine?.destroy()
        flutterEngine = null
        Log.d("FlutterEngineManager", "FlutterEngine destroyed")
    }
}
