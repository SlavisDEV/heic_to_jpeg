package io.appzone.heic_to_jpeg

import android.graphics.BitmapFactory
import android.graphics.Bitmap
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream


class HeicToJpegPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "heic_to_jpeg")
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "convert" -> {
                val bytes = call.arguments as? ByteArray
                if (bytes == null) {
                    result.error("bad_args", "Expected byte array", null)
                    return
                }
                try {
                    val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                    if (bitmap == null) {
                        result.error("decode_error", "Cannot decode HEIC", null)
                        return
                    }


                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 90, stream)
                    result.success(stream.toByteArray())
                } catch (e: Exception) {
                    result.error("conversion_error", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}