package com.headspace.simple_news_client

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.widget.Toast

class BackgroundService : Service() {
    private val handler = Handler()
    private val interval: Long = 5000 // 30 seconds

    private val runnable = object : Runnable {
        override fun run() {
            Toast.makeText(this@BackgroundService, "Background task running", Toast.LENGTH_SHORT).show()
            handler.postDelayed(this, interval)
        }
    }

    override fun onCreate() {
        super.onCreate()
        handler.post(runnable)
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(runnable)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
