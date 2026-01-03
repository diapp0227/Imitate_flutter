package com.example.imitate_android

import android.app.Application

class AppApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        FlutterEngineManager.initialize(this)
    }
}