package com.headspace.simple_news_client

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import android.util.Log

class MyForegroundService : Service() {

    override fun onCreate() {
        super.onCreate()
        startForegroundService()
        FlutterEngineManager.initialize(this) // Initialize Flutter Engine
        scheduleWork()
    }

    private fun startForegroundService() {
        val channelId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel("my_service", "My Background Service")
        } else {
            ""
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Background Service")
            .setContentText("Running background task")
            .setSmallIcon(R.mipmap.ic_launcher)
            .build()

        startForeground(1, notification)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(channelId: String, channelName: String): String {
        val chan = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        val service = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        service.createNotificationChannel(chan)
        return channelId
    }

    private fun scheduleWork() {
        val workRequest = OneTimeWorkRequestBuilder<MyWorker>()
            .setInitialDelay(3, TimeUnit.SECONDS)
            .build()
        WorkManager.getInstance(this).enqueue(workRequest)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        FlutterEngineManager.destroy()
    }
}
