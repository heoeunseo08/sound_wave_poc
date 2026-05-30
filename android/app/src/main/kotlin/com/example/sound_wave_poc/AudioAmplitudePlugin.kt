package com.example.sound_wave_poc

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class AudioAmplitudePlugin : FlutterPlugin, MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel =
            MethodChannel(binding.binaryMessenger, "com.example.sound_wave/method_channel")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "com.example.sound_wave/event_channel")
        eventChannel.setStreamHandler(this)

        //TODO 오디오 로직
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }


    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "start" -> result.success(true)
            "stop" -> result.success(true)
            else -> result.notImplemented()
        }
    }

    override fun onListen(arg: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(p0: Any?) {
        TODO("Not yet implemented")
    }

}