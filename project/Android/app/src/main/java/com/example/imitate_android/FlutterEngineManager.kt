package com.example.imitate_android

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

object FlutterEngineManager {

    private var flutterEngine: FlutterEngine? = null
    // メソッドチャンネル
    var methodChannel: MethodChannel? = null

    // FlutterEngineを初期化
    fun initialize(context: Context) {
        if(flutterEngine != null) return
        val engine = FlutterEngine(context)

        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        flutterEngine = engine
        setChannel()
    }

    fun setChannel() {
        val engine = flutterEngine ?: return
        methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, "BalanceRecordRepository")
    }
}