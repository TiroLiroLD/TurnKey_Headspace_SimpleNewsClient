package com.headspace.simple_news_client

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.Worker
import androidx.work.WorkerParameters
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

class MyWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        Handler(Looper.getMainLooper()).post {
            Toast.makeText(applicationContext, "Background task running", Toast.LENGTH_LONG).show()
        }

        Log.d("MyWorker", "Background task is running")

        // Reschedule the work
        val workRequest = OneTimeWorkRequestBuilder<MyWorker>()
            .setInitialDelay(10, TimeUnit.SECONDS)
            .build()
        WorkManager.getInstance(applicationContext).enqueue(workRequest)

        return Result.success()
    }
}
