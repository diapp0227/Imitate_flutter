package com.example.imitate_android

import com.example.imitate_android.manager.AppLogger
import io.flutter.plugin.common.MethodChannel
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

object BalanceRecordRepository {

    suspend fun selectAll(): List<Map<String, Any>> = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.selectAll"
        AppLogger.channelRequest(method)
        FlutterEngineManager.methodChannel?.invokeMethod("selectAll", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result is List<*>) {
                    try {
                        @Suppress("UNCHECKED_CAST")
                        val typedList = result.map { it as Map<String, Any> }
                        AppLogger.channelSuccess(method)
                        continuation.resume(typedList)
                    } catch (e: ClassCastException) {
                        AppLogger.channelFailure(method, e.message ?: "ClassCastException")
                        continuation.resumeWithException(e)
                    }
                } else {
                    val error = "Expected List<Map<String, Any>>, but got: ${result?.javaClass}"
                    AppLogger.channelFailure(method, error)
                    continuation.resumeWithException(IllegalArgumentException(error))
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }

    suspend fun insert(argument: Map<String, Any>) = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.insert"
        AppLogger.channelRequest(method)
        FlutterEngineManager.methodChannel?.invokeMethod("insert", argument, object : MethodChannel.Result {
            override fun success(result: Any?) {
                AppLogger.channelSuccess(method)
                continuation.resume(Unit)
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }

    suspend fun getMonthlyIncome(): Int = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.getMonthlyIncome"
        AppLogger.channelRequest(method)
        FlutterEngineManager.methodChannel?.invokeMethod("getMonthlyIncome", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result is Int) {
                    AppLogger.channelSuccess(method)
                    continuation.resume(result)
                } else {
                    val error = "Expected Int, but got: ${result?.javaClass}"
                    AppLogger.channelFailure(method, error)
                    continuation.resumeWithException(IllegalArgumentException(error))
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }

    suspend fun getMonthlyExpenses(): Int = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.getMonthlyExpenses"
        AppLogger.channelRequest(method)
        FlutterEngineManager.methodChannel?.invokeMethod("getMonthlyExpenses", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result is Int) {
                    AppLogger.channelSuccess(method)
                    continuation.resume(result)
                } else {
                    val error = "Expected Int, but got: ${result?.javaClass}"
                    AppLogger.channelFailure(method, error)
                    continuation.resumeWithException(IllegalArgumentException(error))
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }

    suspend fun getDailyBalanceData(year: Int, month: Int): List<Map<String, Any>> = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.getDailyBalanceData"
        AppLogger.channelRequest(method)
        val arguments = mapOf("year" to year, "month" to month)
        FlutterEngineManager.methodChannel?.invokeMethod("getDailyBalanceData", arguments, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result is List<*>) {
                    try {
                        @Suppress("UNCHECKED_CAST")
                        val typedList = result.map { it as Map<String, Any> }
                        AppLogger.channelSuccess(method)
                        continuation.resume(typedList)
                    } catch (e: ClassCastException) {
                        AppLogger.channelFailure(method, e.message ?: "ClassCastException")
                        continuation.resumeWithException(e)
                    }
                } else {
                    val error = "Expected List<Map<String, Any>>, but got: ${result?.javaClass}"
                    AppLogger.channelFailure(method, error)
                    continuation.resumeWithException(IllegalArgumentException(error))
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }

    suspend fun getAvailableYearMonths(): List<String> = suspendCoroutine { continuation ->
        val method = "BalanceRecordRepository.getAvailableYearMonths"
        AppLogger.channelRequest(method)
        FlutterEngineManager.methodChannel?.invokeMethod("getAvailableYearMonths", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                if (result is List<*>) {
                    try {
                        @Suppress("UNCHECKED_CAST")
                        val typedList = result.map { it as String }
                        AppLogger.channelSuccess(method)
                        continuation.resume(typedList)
                    } catch (e: ClassCastException) {
                        AppLogger.channelFailure(method, e.message ?: "ClassCastException")
                        continuation.resumeWithException(e)
                    }
                } else {
                    val error = "Expected List<String>, but got: ${result?.javaClass}"
                    AppLogger.channelFailure(method, error)
                    continuation.resumeWithException(IllegalArgumentException(error))
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                AppLogger.channelFailure(method, "$errorCode: $errorMessage")
                continuation.resumeWithException(Exception("$errorCode: $errorMessage"))
            }

            override fun notImplemented() {
                AppLogger.channelFailure(method, "notImplemented")
                continuation.resumeWithException(UnsupportedOperationException("notImplemented"))
            }
        })
    }
}
