package com.example.imitate_android

import io.flutter.plugin.common.MethodChannel
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

object BalanceRecordRepository {
    suspend fun selectAll(): List<Map<String, Any>> = suspendCoroutine { continuation ->
        FlutterEngineManager.methodChannel?.invokeMethod("selectAll", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                println("result = $result")

                if(result is List<*>) {
                    try {
                        // 型変換
                        val typedList = result.map { item ->
                            @Suppress("UNCHECKED_CAST")
                            item as Map<String, Any>
                        }
                        continuation.resume(typedList)
                    } catch (e: ClassCastException) {
                        continuation.resumeWithException(e)
                    }
                } else {
                    continuation.resumeWithException(
                        IllegalArgumentException("Expected List<Map<String, Any>>, but got: ${result?.javaClass}")
                    )
                }
            }

            override fun error(
                errorCode: String,
                errorMessage: String?,
                errorDetails: Any?
            ) {
                println("Error")
            }

            override fun notImplemented() {
                println("notImplemented")
            }
        })
    }


    suspend fun insert(argument: Map<String, Any>) = suspendCoroutine { continuation ->
        FlutterEngineManager.methodChannel?.invokeMethod("insert", argument, object : MethodChannel.Result {
            override fun success(result: Any?) {
                println("result = $result")
                continuation.resume(null)
            }

            override fun error(
                errorCode: String,
                errorMessage: String?,
                errorDetails: Any?
            ) {
                println("Error")
            }

            override fun notImplemented() {
                println("notImplemented")
            }
        })
    }

}