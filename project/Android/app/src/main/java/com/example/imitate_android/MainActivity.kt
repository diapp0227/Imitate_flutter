package com.example.imitate_android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.OutlinedTextFieldDefaults.contentPadding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.lifecycleScope
import com.example.imitate_android.ui.theme.Imitate_androidTheme
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class MainActivity : ComponentActivity() {

    var methodChannel: MethodChannel? = null
    val functionList = listOf("HelloWorld", "test01", "test02", "test03", "test04", "test05")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        // チャンネル名
        val CHANNEL = "HelloWorldRepository"

        // FlutterEngineを初期化
        val flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        var massage: String = "initial Hello World"

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        setContent {
            Imitate_androidTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Greeting(
                        name = massage,
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }

    suspend fun fetch(): String = suspendCoroutine { continuation ->
        methodChannel?.invokeMethod("fetch", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                println("result = $result")
                continuation.resume(result.toString())
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

    fun clickFunctionList(functionName: String) {
        println("clickFunctionList$functionName")
        when(functionName) {
            "HelloWorld" -> print("")
            else -> print(functionName)
        }
    }

    @Composable
    fun Greeting(name: String, modifier: Modifier = Modifier) {

        var message by remember { mutableStateOf(name) }

        LazyColumn (modifier = modifier) {
            items(
                count = functionList.size
                ) { index ->
                    val item = functionList[index]
                Text(
                    text = item,
                    modifier = modifier.fillMaxSize().clickable {
                        clickFunctionList(item)
                    }
                )
            }
        }


// Flutterのコードを一旦コメントアウト
//        Column {
//            Text(
//                text = message,
//                modifier = modifier
//            )
//            Button(
//                onClick = {
//                    println("onClick")
//                    lifecycleScope.launch {
//                        try {
//                            message = fetch()
//                        } catch (e: Exception) {
//                        }
//                    }
//                }
//            ) {
//                Text("update")
//            }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    Imitate_androidTheme {
        Greeting("Android")
    }
}
}