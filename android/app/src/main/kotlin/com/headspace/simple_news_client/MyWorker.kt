package com.headspace.simple_news_client

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.plugin.common.MethodChannel
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

class MyWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        Handler(Looper.getMainLooper()).post {
            Toast.makeText(applicationContext, "Background task running", Toast.LENGTH_LONG).show()
        }

        Log.d("MyWorker", "Background task is running")

        // Get the Flutter Engine from the singleton
        val flutterEngine = FlutterEngineManager.flutterEngine
        if (flutterEngine != null) {
            val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.headspace.simple_news_client/background_service")
            Handler(Looper.getMainLooper()).post {
                Log.d("MyWorker", "Invoking fetchNews method on MethodChannel")
                methodChannel.invokeMethod("fetchNews", null)
            }
        } else {
            Log.e("MyWorker", "Flutter engine is not initialized")
        }

        // Reschedule the work
        val workRequest = OneTimeWorkRequestBuilder<MyWorker>()
            .setInitialDelay(1, TimeUnit.MINUTES)
            .build()
        WorkManager.getInstance(applicationContext).enqueue(workRequest)

        return Result.success()
    }
}
