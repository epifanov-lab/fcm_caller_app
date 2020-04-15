package com.lab.fcmcallerapp

import android.content.Intent
import androidx.annotation.NonNull
import com.lab.fcmcallerapp.services.CallFgService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class FlutterAppActivity: FlutterActivity(), MethodCallHandler {

    private val channelId = "com.lab.fcmcallerapp.channel"

    private lateinit var mChannel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        mChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelId)
        mChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "stop_CallFgService" -> context.stopService(Intent(context, CallFgService::class.java))
            "get_intent_data" -> getIntentData(result)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        println("@@@@@ A.onNewIntent: ${intent.extras}")
        mChannel.invokeMethod("onNewIntent", getArgsMapFromIntent(intent))
    }

    private fun getIntentData(result: MethodChannel.Result) {
        println("@@@@@ getIntentData")
        result.success(getArgsMapFromIntent(intent))
    }

    private fun getArgsMapFromIntent(intent: Intent) : Map<String, String> {
        val data = HashMap<String, String>()
        intent?.extras?.keySet()?.forEach{ key -> data[key] = intent.getStringExtra(key) }
        return data
    }
}
