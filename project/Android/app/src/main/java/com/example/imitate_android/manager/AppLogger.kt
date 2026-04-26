package com.example.imitate_android.manager

import android.util.Log
import com.example.imitate_android.BuildConfig

interface LogDestination {
    fun log(level: AppLogger.Level, category: AppLogger.Category, message: String)
}

object AppLogger {

    enum class Level {
        DEBUG, INFO, WARNING, ERROR
    }

    enum class Category(val tag: String) {
        SCREEN("Screen"),
        ACTION("Action"),
        CHANNEL("Channel")
    }

    var destinations: MutableList<LogDestination> = mutableListOf()

    // MARK: - Screen

    fun screenAppeared(screen: String) {
        val message = "【Android】[$screen] appeared"
        debugLog(Category.SCREEN, message)
        forward(Level.DEBUG, Category.SCREEN, message)
    }

    // MARK: - Action

    fun userAction(action: String, screen: String) {
        val message = "【Android】[$screen] '$action' action"
        debugLog(Category.ACTION, message)
        forward(Level.DEBUG, Category.ACTION, message)
    }

    // MARK: - Channel

    fun channelRequest(method: String) {
        val message = "【Android】[$method] channel requesting"
        debugLog(Category.CHANNEL, message)
        forward(Level.DEBUG, Category.CHANNEL, message)
    }

    fun channelSuccess(method: String) {
        val message = "【Android】[$method] channel success"
        debugLog(Category.CHANNEL, message)
        forward(Level.DEBUG, Category.CHANNEL, message)
    }

    fun channelFailure(method: String, error: String) {
        val message = "【Android】[$method] channel failure: $error"
        debugLog(Category.CHANNEL, message)
        forward(Level.DEBUG, Category.CHANNEL, message)
    }

    // MARK: - Private

    private fun debugLog(category: Category, message: String) {
        if (BuildConfig.DEBUG) {
            Log.d(category.tag, message)
        }
    }

    // TODO: Firebase導入時に FirebaseLogDestination を実装し destinations に追加する
    private fun forward(level: Level, category: Category, message: String) {
        destinations.forEach { it.log(level, category, message) }
    }
}
